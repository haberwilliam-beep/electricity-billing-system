package com.electricity.controller;

import com.electricity.dto.ApiResponse;
import com.electricity.model.Parameter;
import com.electricity.service.AuditLogService;
import com.electricity.service.ParameterService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

@Controller
@RequestMapping("/parameters")
@RequiredArgsConstructor
public class ParameterController {

    private final ParameterService parameterService;
    private final AuditLogService auditLogService;

    @GetMapping
    public String list(Model model) {
        model.addAttribute("params", parameterService.findAll());
        return "parameter/list";
    }

    @GetMapping("/data")
    @ResponseBody
    public List<Parameter> getData() {
        return parameterService.findAll();
    }

    @PostMapping("/save")
    @ResponseBody
    public ResponseEntity<ApiResponse> save(@RequestBody List<Parameter> params,
                                             HttpServletRequest request) {
        for (Parameter p : params) {
            parameterService.saveParameter(p);
        }
        auditLogService.log("UPDATE", "Parameter", null, "Updated system parameters", request);
        return ResponseEntity.ok(ApiResponse.ok("Parameters saved successfully"));
    }
}
