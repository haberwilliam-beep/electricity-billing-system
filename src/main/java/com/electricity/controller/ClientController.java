package com.electricity.controller;

import com.electricity.model.Client;
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
@RequestMapping("/clients")
public class ClientController {

    private final ClientService clientService;

    @Autowired
    public ClientController(ClientService clientService) {
        this.clientService = clientService;
    }

    @GetMapping
    public String clientList(Model model) {
        return "client-list";
    }

    @GetMapping("/api/list")
    @ResponseBody
    public Map<String, Object> listClients(@RequestParam(value = "page", defaultValue = "1") int page,
                                            @RequestParam(value = "rows", defaultValue = "20") int rows) {
        List<Client> clients = clientService.findAll();
        Map<String, Object> result = new HashMap<>();
        result.put("total", clients.size());
        result.put("page", page);
        result.put("records", clients.size());
        result.put("rows", clients);
        return result;
    }

    @GetMapping("/api/{id}")
    @ResponseBody
    public ResponseEntity<Client> getClient(@PathVariable Long id) {
        Client client = clientService.findById(id);
        if (client == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(client);
    }

    @PostMapping("/api/save")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> saveClient(@RequestBody Client client) {
        Map<String, Object> response = new HashMap<>();
        try {
            if (client.getId() == null) {
                clientService.createClient(client);
                response.put("message", "Client created successfully");
            } else {
                clientService.updateClient(client);
                response.put("message", "Client updated successfully");
            }
            response.put("success", true);
            response.put("data", client);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Error: " + e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }

    @DeleteMapping("/api/{id}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> deleteClient(@PathVariable Long id) {
        Map<String, Object> response = new HashMap<>();
        try {
            clientService.deleteClient(id);
            response.put("success", true);
            response.put("message", "Client deleted successfully");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Error: " + e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }
}
