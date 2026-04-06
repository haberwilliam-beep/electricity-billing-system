package com.electricity.controller;

import com.electricity.dto.ApiResponse;
import com.electricity.model.Issuance;
import com.electricity.service.AuditLogService;
import com.electricity.service.IssuanceService;
import com.electricity.service.ParameterService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.math.BigDecimal;

@Controller
@RequestMapping("/issuances")
@RequiredArgsConstructor
public class IssuanceController {

    private final IssuanceService issuanceService;
    private final ParameterService parameterService;
    private final AuditLogService auditLogService;

    @GetMapping
    public String list(Model model) {
        BigDecimal defaultRate = parameterService.getDecimalValue("EXCHANGE_RATE");
        model.addAttribute("defaultExchangeRate", defaultRate);
        return "issuance/list";
    }

    @GetMapping("/data")
    @ResponseBody
    public Object getData(@RequestParam(defaultValue="1") int page,
                          @RequestParam(defaultValue="10") int rows) {
        return issuanceService.getPagedIssuances(page, rows);
    }

    @GetMapping("/{id}")
    @ResponseBody
    public Issuance getById(@PathVariable Long id) {
        return issuanceService.findById(id);
    }

    @PostMapping
    @ResponseBody
    public ResponseEntity<ApiResponse> create(@RequestBody Issuance issuance,
                                               HttpServletRequest request) {
        issuanceService.createIssuance(issuance);
        auditLogService.log("CREATE", "Issuance", issuance.getId(),
                "Created issuance for month: " + issuance.getBillingMonth(), request);
        return ResponseEntity.ok(ApiResponse.ok("Issuance created successfully",
                issuance.getId()));
    }

    @PutMapping("/{id}")
    @ResponseBody
    public ResponseEntity<ApiResponse> update(@PathVariable Long id, @RequestBody Issuance issuance,
                                               HttpServletRequest request) {
        issuance.setId(id);
        issuanceService.updateIssuance(issuance);
        auditLogService.log("UPDATE", "Issuance", id,
                "Updated issuance: " + issuance.getBillingMonth(), request);
        return ResponseEntity.ok(ApiResponse.ok("Issuance updated successfully"));
    }

    @DeleteMapping("/{id}")
    @ResponseBody
    public ResponseEntity<ApiResponse> delete(@PathVariable Long id, HttpServletRequest request) {
        issuanceService.deleteIssuance(id);
        auditLogService.log("DELETE", "Issuance", id, "Deleted issuance id: " + id, request);
        return ResponseEntity.ok(ApiResponse.ok("Issuance deleted successfully"));
    }
}
