package com.electricity.controller;

import com.electricity.service.BillingService;
import com.electricity.service.ClientService;
import com.electricity.service.InvoiceService;
import com.electricity.service.MeterReadingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/dashboard")
public class DashboardController {

    private final ClientService clientService;
    private final BillingService billingService;
    private final InvoiceService invoiceService;
    private final MeterReadingService meterReadingService;

    @Autowired
    public DashboardController(ClientService clientService,
                                BillingService billingService,
                                InvoiceService invoiceService,
                                MeterReadingService meterReadingService) {
        this.clientService = clientService;
        this.billingService = billingService;
        this.invoiceService = invoiceService;
        this.meterReadingService = meterReadingService;
    }

    @GetMapping
    public String dashboard(Model model) {
        long totalClients = clientService.findAll().size();
        long meterBasedClients = clientService.findByType("METER_BASED").size();
        long amperBasedClients = clientService.findByType("AMPER_BASED").size();
        long totalInvoices = invoiceService.countAll();

        model.addAttribute("totalClients", totalClients);
        model.addAttribute("meterBasedClients", meterBasedClients);
        model.addAttribute("amperBasedClients", amperBasedClients);
        model.addAttribute("totalInvoices", totalInvoices);
        model.addAttribute("recentInvoices", invoiceService.findAll());

        return "dashboard";
    }
}
