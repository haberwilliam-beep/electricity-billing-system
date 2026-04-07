package com.electricity.controller;

import com.electricity.model.MeterReading;
import com.electricity.service.ClientService;
import com.electricity.service.MeterReadingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/meter-readings")
public class MeterReadingController {

    private final MeterReadingService meterReadingService;
    private final ClientService clientService;

    @Autowired
    public MeterReadingController(MeterReadingService meterReadingService,
                                   ClientService clientService) {
        this.meterReadingService = meterReadingService;
        this.clientService = clientService;
    }

    @GetMapping
    public String meterReadingPage(Model model) {
        model.addAttribute("clients", clientService.findByType("METER_BASED"));
        return "meter-reading";
    }

    @GetMapping("/api/list")
    @ResponseBody
    public Map<String, Object> listReadings(@RequestParam(value = "page", defaultValue = "1") int page,
                                             @RequestParam(value = "rows", defaultValue = "20") int rows,
                                             @RequestParam(value = "clientId", required = false) Long clientId,
                                             @RequestParam(value = "month", required = false) Integer month,
                                             @RequestParam(value = "year", required = false) Integer year) {
        List<MeterReading> readings;
        if (clientId != null) {
            readings = meterReadingService.findByClientId(clientId);
        } else if (month != null && year != null) {
            readings = meterReadingService.findByMonthAndYear(month, year);
        } else {
            readings = meterReadingService.findAll();
        }
        Map<String, Object> result = new HashMap<>();
        result.put("total", readings.size());
        result.put("page", page);
        result.put("records", readings.size());
        result.put("rows", readings);
        return result;
    }

    @PostMapping("/api/save")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> saveReading(@RequestBody MeterReading reading) {
        Map<String, Object> response = new HashMap<>();
        try {
            if (reading.getId() == null) {
                meterReadingService.createReading(reading);
                response.put("message", "Meter reading saved successfully");
            } else {
                meterReadingService.updateReading(reading);
                response.put("message", "Meter reading updated successfully");
            }
            response.put("success", true);
            response.put("data", reading);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Error: " + e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }

    @DeleteMapping("/api/{id}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> deleteReading(@PathVariable Long id) {
        Map<String, Object> response = new HashMap<>();
        try {
            meterReadingService.deleteReading(id);
            response.put("success", true);
            response.put("message", "Meter reading deleted successfully");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Error: " + e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }
}
