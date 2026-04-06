package com.electricity.controller;

import com.electricity.dto.ApiResponse;
import com.electricity.model.Translation;
import com.electricity.service.AuditLogService;
import com.electricity.service.TranslationService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;

@Controller
@RequestMapping("/translations")
@RequiredArgsConstructor
public class TranslationController {

    private final TranslationService translationService;
    private final AuditLogService auditLogService;

    @GetMapping
    public String list() {
        return "translation/list";
    }

    @GetMapping("/data")
    @ResponseBody
    public Object getData(@RequestParam(defaultValue="1") int page,
                          @RequestParam(defaultValue="10") int rows,
                          @RequestParam(defaultValue="") String search) {
        return translationService.getPagedTranslations(page, rows, search);
    }

    @PostMapping
    @ResponseBody
    public ResponseEntity<ApiResponse> save(@RequestBody Translation translation,
                                             HttpServletRequest request) {
        translationService.save(translation);
        auditLogService.log("UPSERT", "Translation", translation.getId(),
                "Saved translation key: " + translation.getMsgKey(), request);
        return ResponseEntity.ok(ApiResponse.ok("Translation saved"));
    }

    @DeleteMapping("/{id}")
    @ResponseBody
    public ResponseEntity<ApiResponse> delete(@PathVariable Long id, HttpServletRequest request) {
        translationService.delete(id);
        auditLogService.log("DELETE", "Translation", id, "Deleted translation id: " + id, request);
        return ResponseEntity.ok(ApiResponse.ok("Translation deleted"));
    }
}
