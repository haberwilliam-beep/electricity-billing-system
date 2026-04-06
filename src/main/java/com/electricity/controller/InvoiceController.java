package com.electricity.controller;

import com.electricity.model.Invoice;
import com.electricity.service.InvoiceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/invoices")
public class InvoiceController {

    private final InvoiceService invoiceService;

    @Autowired
    public InvoiceController(InvoiceService invoiceService) {
        this.invoiceService = invoiceService;
    }

    @GetMapping
    public String invoicePage(Model model) {
        return "invoice";
    }

    @GetMapping("/api/list")
    @ResponseBody
    public Map<String, Object> listInvoices(@RequestParam(value = "page", defaultValue = "1") int page,
                                             @RequestParam(value = "rows", defaultValue = "20") int rows,
                                             @RequestParam(value = "month", required = false) Integer month,
                                             @RequestParam(value = "year", required = false) Integer year) {
        List<Invoice> invoices;
        if (month != null && year != null) {
            invoices = invoiceService.findByMonthAndYear(month, year);
        } else {
            invoices = invoiceService.findAll();
        }
        Map<String, Object> result = new HashMap<>();
        result.put("total", invoices.size());
        result.put("page", page);
        result.put("records", invoices.size());
        result.put("rows", invoices);
        return result;
    }

    @GetMapping("/api/{id}")
    @ResponseBody
    public ResponseEntity<Invoice> getInvoice(@PathVariable Long id) {
        Invoice invoice = invoiceService.findById(id);
        if (invoice == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(invoice);
    }

    @PostMapping("/api/generate/{billId}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> generateInvoice(@PathVariable Long billId) {
        Map<String, Object> response = new HashMap<>();
        try {
            Invoice invoice = invoiceService.generateInvoiceFromBill(billId);
            response.put("success", true);
            response.put("message", "Invoice generated successfully");
            response.put("data", invoice);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Error: " + e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }

    @PutMapping("/api/{id}/status")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> updateStatus(@PathVariable Long id,
                                                             @RequestParam String status) {
        Map<String, Object> response = new HashMap<>();
        try {
            invoiceService.updateStatus(id, status);
            response.put("success", true);
            response.put("message", "Invoice status updated");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Error: " + e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }
}
