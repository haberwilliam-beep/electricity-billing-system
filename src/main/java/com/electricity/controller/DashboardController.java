package com.electricity.controller;

import com.electricity.service.CustomerService;
import com.electricity.service.IssuanceService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/dashboard")
@RequiredArgsConstructor
public class DashboardController {

    private final CustomerService customerService;
    private final IssuanceService issuanceService;

    @GetMapping
    public String dashboard(Model model) {
        long totalClients = customerService.findAll().size();
        long totalIssuances = issuanceService.findAll().size();

        model.addAttribute("totalClients", totalClients);
        model.addAttribute("totalIssuances", totalIssuances);

        return "dashboard";
    }
}
