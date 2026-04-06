package com.electricity.controller;

import com.electricity.model.Bill;
import com.electricity.service.BillingService;
import com.electricity.service.ClientService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/billing")
public class BillingController {

    private final BillingService billingService;
    private final ClientService clientService;

    @Autowired
    public BillingController(BillingService billingService, ClientService clientService) {
        this.billingService = billingService;
        this.clientService = clientService;
    }

    @GetMapping
    public String billingPage(Model model) {
        model.addAttribute("clients", clientService.findActive());
        return "billing";
    }

    @GetMapping("/api/list")
    @ResponseBody
    public Map<String, Object> listBills(@RequestParam(value = "page", defaultValue = "1") int page,
                                          @RequestParam(value = "rows", defaultValue = "20") int rows,
                                          @RequestParam(value = "month", required = false) Integer month,
                                          @RequestParam(value = "year", required = false) Integer year) {
        List<Bill> bills;
        if (month != null && year != null) {
            bills = billingService.findByMonthAndYear(month, year);
        } else {
            bills = billingService.findAll();
        }
        Map<String, Object> result = new HashMap<>();
        result.put("total", bills.size());
        result.put("page", page);
        result.put("records", bills.size());
        result.put("rows", bills);
        return result;
    }

    @PostMapping("/api/generate/meter")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> generateMeterBill(
            @RequestParam Long clientId,
            @RequestParam Long meterReadingId,
            @RequestParam int billingMonth,
            @RequestParam int billingYear) {
        Map<String, Object> response = new HashMap<>();
        try {
            Bill bill = billingService.generateMeterBasedBill(clientId, meterReadingId, billingMonth, billingYear);
            response.put("success", true);
            response.put("message", "Bill generated successfully");
            response.put("data", bill);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Error: " + e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }

    @PostMapping("/api/generate/amper")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> generateAmperBill(
            @RequestParam Long clientId,
            @RequestParam int billingMonth,
            @RequestParam int billingYear) {
        Map<String, Object> response = new HashMap<>();
        try {
            Bill bill = billingService.generateAmperBasedBill(clientId, billingMonth, billingYear);
            response.put("success", true);
            response.put("message", "Bill generated successfully");
            response.put("data", bill);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Error: " + e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }

    @DeleteMapping("/api/{id}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> deleteBill(@PathVariable Long id) {
        Map<String, Object> response = new HashMap<>();
        try {
            billingService.deleteBill(id);
            response.put("success", true);
            response.put("message", "Bill deleted successfully");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Error: " + e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }
}
