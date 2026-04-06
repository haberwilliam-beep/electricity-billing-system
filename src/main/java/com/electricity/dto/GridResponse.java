package com.electricity.dto;

import lombok.Data;
import java.util.List;

/**
 * Generic response wrapper for jqGrid JSON responses.
 */
@Data
public class GridResponse<T> {
    private int page;
    private int total;
    private long records;
    private List<T> rows;

    public GridResponse(int page, int pageSize, long records, List<T> rows) {
        this.page = page;
        this.records = records;
        this.rows = rows;
        this.total = (int) Math.ceil((double) records / pageSize);
    }
}
