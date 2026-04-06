package com.electricity.controller;

import com.electricity.dto.ApiResponse;
import com.electricity.model.Customer;
import com.electricity.service.AuditLogService;
import com.electricity.service.BoxService;
import com.electricity.service.CustomerService;
import com.electricity.service.ZoneService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;

@Controller
@RequestMapping("/customers")
@RequiredArgsConstructor
public class CustomerController {

    private final CustomerService customerService;
    private final BoxService boxService;
    private final ZoneService zoneService;
    private final AuditLogService auditLogService;

    @GetMapping
    public String list(Model model) {
        model.addAttribute("zones", zoneService.findAllActive());
        model.addAttribute("boxes", boxService.findAllActive());
        return "customer/list";
    }

    @GetMapping("/data")
    @ResponseBody
    public Object getData(@RequestParam(defaultValue="1") int page,
                          @RequestParam(defaultValue="10") int rows,
                          @RequestParam(defaultValue="") String search,
                          @RequestParam(defaultValue="") String billingType,
                          @RequestParam(required=false) Long zoneId) {
        return customerService.getPagedCustomers(page, rows, search, billingType, zoneId);
    }

    @GetMapping("/{id}")
    @ResponseBody
    public Customer getById(@PathVariable Long id) {
        return customerService.findById(id);
    }

    @PostMapping
    @ResponseBody
    public ResponseEntity<ApiResponse> create(@RequestBody Customer customer,
                                               HttpServletRequest request) {
        customerService.createCustomer(customer);
        auditLogService.log("CREATE", "Customer", customer.getId(),
                "Created customer: " + customer.getName(), request);
        return ResponseEntity.ok(ApiResponse.ok("Customer created successfully"));
    }

    @PutMapping("/{id}")
    @ResponseBody
    public ResponseEntity<ApiResponse> update(@PathVariable Long id,
                                               @RequestBody Customer customer,
                                               HttpServletRequest request) {
        customer.setId(id);
        customerService.updateCustomer(customer);
        auditLogService.log("UPDATE", "Customer", id,
                "Updated customer: " + customer.getName(), request);
        return ResponseEntity.ok(ApiResponse.ok("Customer updated successfully"));
    }

    @DeleteMapping("/{id}")
    @ResponseBody
    public ResponseEntity<ApiResponse> delete(@PathVariable Long id, HttpServletRequest request) {
        Customer c = customerService.findById(id);
        customerService.deleteCustomer(id);
        auditLogService.log("DELETE", "Customer", id,
                "Deleted customer: " + (c != null ? c.getName() : id), request);
        return ResponseEntity.ok(ApiResponse.ok("Customer deleted successfully"));
    }
}
