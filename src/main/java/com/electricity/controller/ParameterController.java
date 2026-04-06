package com.electricity.controller;

import com.electricity.model.Parameter;
import com.electricity.service.ParameterService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/parameters")
public class ParameterController {

    private final ParameterService parameterService;

    @Autowired
    public ParameterController(ParameterService parameterService) {
        this.parameterService = parameterService;
    }

    @GetMapping
    public String parametersPage(Model model) {
        model.addAttribute("parameters", parameterService.findAll());
        return "parameters";
    }

    @GetMapping("/api/list")
    @ResponseBody
    public Map<String, Object> listParameters() {
        List<Parameter> parameters = parameterService.findAll();
        Map<String, Object> result = new HashMap<>();
        result.put("total", parameters.size());
        result.put("page", 1);
        result.put("records", parameters.size());
        result.put("rows", parameters);
        return result;
    }

    @PostMapping("/api/save")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> saveParameter(@RequestBody Parameter parameter) {
        Map<String, Object> response = new HashMap<>();
        try {
            parameterService.saveParameter(parameter);
            response.put("success", true);
            response.put("message", "Parameter saved successfully");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Error: " + e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }

    @PutMapping("/api/{id}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> updateParameter(@PathVariable Long id,
                                                                @RequestBody Parameter parameter) {
        Map<String, Object> response = new HashMap<>();
        try {
            parameter.setId(id);
            parameterService.updateParameter(parameter);
            response.put("success", true);
            response.put("message", "Parameter updated successfully");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Error: " + e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }

    @DeleteMapping("/api/{id}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> deleteParameter(@PathVariable Long id) {
        Map<String, Object> response = new HashMap<>();
        try {
            parameterService.deleteParameter(id);
            response.put("success", true);
            response.put("message", "Parameter deleted successfully");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Error: " + e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }
}
