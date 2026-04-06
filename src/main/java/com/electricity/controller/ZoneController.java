package com.electricity.controller;

import com.electricity.dto.ApiResponse;
import com.electricity.model.Zone;
import com.electricity.service.AuditLogService;
import com.electricity.service.ZoneService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

@Controller
@RequestMapping("/zones")
@RequiredArgsConstructor
public class ZoneController {

    private final ZoneService zoneService;
    private final AuditLogService auditLogService;

    @GetMapping
    public String list() {
        return "zone/list";
    }

    @GetMapping("/data")
    @ResponseBody
    public Object getData(@RequestParam(defaultValue="1") int page,
                          @RequestParam(defaultValue="10") int rows,
                          @RequestParam(defaultValue="") String search) {
        return zoneService.getPagedZones(page, rows, search);
    }

    @GetMapping("/all")
    @ResponseBody
    public List<Zone> getAll() {
        return zoneService.findAllActive();
    }

    @GetMapping("/{id}")
    @ResponseBody
    public Zone getById(@PathVariable Long id) {
        return zoneService.findById(id);
    }

    @PostMapping
    @ResponseBody
    public ResponseEntity<ApiResponse> create(@RequestBody Zone zone,
                                               HttpServletRequest request) {
        zoneService.createZone(zone);
        auditLogService.log("CREATE", "Zone", zone.getId(), "Created zone: " + zone.getName(), request);
        return ResponseEntity.ok(ApiResponse.ok("Zone created successfully"));
    }

    @PutMapping("/{id}")
    @ResponseBody
    public ResponseEntity<ApiResponse> update(@PathVariable Long id, @RequestBody Zone zone,
                                               HttpServletRequest request) {
        zone.setId(id);
        zoneService.updateZone(zone);
        auditLogService.log("UPDATE", "Zone", id, "Updated zone: " + zone.getName(), request);
        return ResponseEntity.ok(ApiResponse.ok("Zone updated successfully"));
    }

    @DeleteMapping("/{id}")
    @ResponseBody
    public ResponseEntity<ApiResponse> delete(@PathVariable Long id, HttpServletRequest request) {
        Zone z = zoneService.findById(id);
        zoneService.deleteZone(id);
        auditLogService.log("DELETE", "Zone", id,
                "Deleted zone: " + (z != null ? z.getName() : id), request);
        return ResponseEntity.ok(ApiResponse.ok("Zone deleted successfully"));
    }
}
