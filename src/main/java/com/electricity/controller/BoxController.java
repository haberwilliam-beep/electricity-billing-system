package com.electricity.controller;

import com.electricity.dto.ApiResponse;
import com.electricity.model.Box;
import com.electricity.service.AuditLogService;
import com.electricity.service.BoxService;
import com.electricity.service.ZoneService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

@Controller
@RequestMapping("/boxes")
@RequiredArgsConstructor
public class BoxController {

    private final BoxService boxService;
    private final ZoneService zoneService;
    private final AuditLogService auditLogService;

    @GetMapping
    public String list(Model model) {
        model.addAttribute("zones", zoneService.findAllActive());
        return "box/list";
    }

    @GetMapping("/data")
    @ResponseBody
    public Object getData(@RequestParam(defaultValue="1") int page,
                          @RequestParam(defaultValue="10") int rows,
                          @RequestParam(defaultValue="") String search,
                          @RequestParam(required=false) Long zoneId) {
        return boxService.getPagedBoxes(page, rows, search, zoneId);
    }

    @GetMapping("/by-zone/{zoneId}")
    @ResponseBody
    public List<Box> getByZone(@PathVariable Long zoneId) {
        return boxService.findByZoneId(zoneId);
    }

    @GetMapping("/{id}")
    @ResponseBody
    public Box getById(@PathVariable Long id) {
        return boxService.findById(id);
    }

    @PostMapping
    @ResponseBody
    public ResponseEntity<ApiResponse> create(@RequestBody Box box,
                                               HttpServletRequest request) {
        boxService.createBox(box);
        auditLogService.log("CREATE", "Box", box.getId(), "Created box: " + box.getName(), request);
        return ResponseEntity.ok(ApiResponse.ok("Box created successfully"));
    }

    @PutMapping("/{id}")
    @ResponseBody
    public ResponseEntity<ApiResponse> update(@PathVariable Long id, @RequestBody Box box,
                                               HttpServletRequest request) {
        box.setId(id);
        boxService.updateBox(box);
        auditLogService.log("UPDATE", "Box", id, "Updated box: " + box.getName(), request);
        return ResponseEntity.ok(ApiResponse.ok("Box updated successfully"));
    }

    @DeleteMapping("/{id}")
    @ResponseBody
    public ResponseEntity<ApiResponse> delete(@PathVariable Long id, HttpServletRequest request) {
        Box b = boxService.findById(id);
        boxService.deleteBox(id);
        auditLogService.log("DELETE", "Box", id,
                "Deleted box: " + (b != null ? b.getName() : id), request);
        return ResponseEntity.ok(ApiResponse.ok("Box deleted successfully"));
    }
}
