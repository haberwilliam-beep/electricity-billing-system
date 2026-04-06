package com.electricity.controller;

import com.electricity.dto.ApiResponse;
import com.electricity.dto.BillingResult;
import com.electricity.model.Bill;
import com.electricity.model.Issuance;
import com.electricity.service.AuditLogService;
import com.electricity.service.BillingService;
import com.electricity.service.IssuanceService;
import com.electricity.util.MeterReadingPair;
import com.electricity.util.PdfGenerator;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/billing")
@RequiredArgsConstructor
public class BillingController {

    private final BillingService billingService;
    private final IssuanceService issuanceService;
    private final AuditLogService auditLogService;
    private final PdfGenerator pdfGenerator;

    @GetMapping
    public String list(Model model) {
        model.addAttribute("issuances", issuanceService.findAll());
        return "billing/list";
    }

    @GetMapping("/data")
    @ResponseBody
    public Object getData(@RequestParam(defaultValue="1") int page,
                          @RequestParam(defaultValue="10") int rows,
                          @RequestParam(required=false) Long issuanceId) {
        return billingService.getPagedBills(page, rows, issuanceId);
    }

    @GetMapping("/issuance/{issuanceId}")
    public String viewIssuanceBilling(@PathVariable Long issuanceId, Model model) {
        Issuance issuance = issuanceService.findById(issuanceId);
        model.addAttribute("issuance", issuance);
        return "billing/billing";
    }

    @PostMapping("/trial/{issuanceId}")
    @ResponseBody
    public ResponseEntity<BillingResult> runTrial(@PathVariable Long issuanceId,
                                                   @RequestBody Map<String, Map<String, String>> readings,
                                                   HttpServletRequest request) {
        Map<Long, MeterReadingPair> meterReadings = parseReadings(readings);
        BillingResult result = billingService.runTrial(issuanceId, meterReadings);
        auditLogService.log("TRIAL_BILLING", "Issuance", issuanceId,
                "Trial billing run for issuance: " + issuanceId, request);
        return ResponseEntity.ok(result);
    }

    @PostMapping("/final/{issuanceId}")
    @ResponseBody
    public ResponseEntity<ApiResponse> runFinal(@PathVariable Long issuanceId,
                                                 @RequestBody Map<String, Map<String, String>> readings,
                                                 HttpServletRequest request) {
        Map<Long, MeterReadingPair> meterReadings = parseReadings(readings);
        billingService.runFinal(issuanceId, meterReadings);
        auditLogService.log("FINAL_BILLING", "Issuance", issuanceId,
                "Final billing completed for issuance: " + issuanceId, request);
        return ResponseEntity.ok(ApiResponse.ok("Final billing completed successfully"));
    }

    @GetMapping("/pdf/{issuanceId}")
    public void generatePdf(@PathVariable Long issuanceId,
                             HttpServletResponse response) throws Exception {
        Issuance issuance = issuanceService.findById(issuanceId);
        List<Bill> bills = billingService.getBillsByIssuance(issuanceId, false);
        String billingMonth = issuance != null ? issuance.getBillingMonth().toString() : "unknown";
        pdfGenerator.generateBillsPdf(bills, billingMonth, response);
    }

    private Map<Long, MeterReadingPair> parseReadings(Map<String, Map<String, String>> readings) {
        Map<Long, MeterReadingPair> map = new HashMap<>();
        if (readings == null) return map;
        for (Map.Entry<String, Map<String, String>> entry : readings.entrySet()) {
            try {
                Long customerId = Long.parseLong(entry.getKey());
                Map<String, String> vals = entry.getValue();
                BigDecimal prev = new BigDecimal(vals.getOrDefault("prev", "0"));
                BigDecimal curr = new BigDecimal(vals.getOrDefault("curr", "0"));
                map.put(customerId, new MeterReadingPair(prev, curr));
            } catch (NumberFormatException ignored) {
            }
        }
        return map;
    }
}
