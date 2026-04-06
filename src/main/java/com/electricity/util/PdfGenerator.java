package com.electricity.util;

import com.electricity.model.Bill;
import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;
import org.springframework.stereotype.Component;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * Utility to generate PDF invoices using iText.
 */
@Component
public class PdfGenerator {

    private static final Font TITLE_FONT   = new Font(Font.FontFamily.HELVETICA, 16, Font.BOLD);
    private static final Font HEADER_FONT  = new Font(Font.FontFamily.HELVETICA, 11, Font.BOLD, BaseColor.WHITE);
    private static final Font NORMAL_FONT  = new Font(Font.FontFamily.HELVETICA, 10);
    private static final Font LABEL_FONT   = new Font(Font.FontFamily.HELVETICA, 10, Font.BOLD);
    private static final BaseColor HEADER_BG = new BaseColor(0, 102, 204);
    private static final BaseColor ALT_BG    = new BaseColor(240, 248, 255);

    public void generateBillsPdf(List<Bill> bills, String billingMonth,
                                  HttpServletResponse response) throws DocumentException, IOException {
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition",
                "inline; filename=\"bills_" + billingMonth + ".pdf\"");

        Document document = new Document(PageSize.A4.rotate(), 20, 20, 20, 20);
        PdfWriter.getInstance(document, response.getOutputStream());
        document.open();

        // Title
        Paragraph title = new Paragraph("Electricity Generator Billing System", TITLE_FONT);
        title.setAlignment(Element.ALIGN_CENTER);
        document.add(title);

        Paragraph sub = new Paragraph("Billing Month: " + billingMonth, NORMAL_FONT);
        sub.setAlignment(Element.ALIGN_CENTER);
        document.add(sub);
        document.add(Chunk.NEWLINE);

        // Separate meter and amper bills
        List<Bill> meterBills = bills.stream()
                .filter(b -> "METER".equals(b.getBillingType()))
                .collect(java.util.stream.Collectors.toList());
        List<Bill> amperBills = bills.stream()
                .filter(b -> "AMPER".equals(b.getBillingType()))
                .collect(java.util.stream.Collectors.toList());

        if (!meterBills.isEmpty()) {
            document.add(new Paragraph("Meter-Based Clients", LABEL_FONT));
            document.add(Chunk.NEWLINE);
            document.add(buildMeterTable(meterBills));
            document.add(Chunk.NEWLINE);
        }

        if (!amperBills.isEmpty()) {
            document.add(new Paragraph("Amper-Based Clients", LABEL_FONT));
            document.add(Chunk.NEWLINE);
            document.add(buildAmperTable(amperBills));
        }

        document.close();
    }

    private PdfPTable buildMeterTable(List<Bill> bills) throws DocumentException {
        PdfPTable table = new PdfPTable(10);
        table.setWidthPercentage(100);
        table.setWidths(new float[]{3,2,2,2,2,2,2,2,2,2});

        String[] headers = {"Customer","Zone","Box","Prev Read","Curr Read",
                            "Consumption","Price/kWh","Sub Fee","Total USD","Total LBP"};
        addHeaderRow(table, headers);

        boolean alt = false;
        for (Bill b : bills) {
            BaseColor bg = alt ? ALT_BG : BaseColor.WHITE;
            addCell(table, b.getCustomerName(), bg);
            addCell(table, b.getZoneName(), bg);
            addCell(table, b.getBoxName(), bg);
            addCell(table, fmt(b.getPrevReading()), bg);
            addCell(table, fmt(b.getCurrReading()), bg);
            addCell(table, fmt(b.getConsumption()), bg);
            addCell(table, fmt(b.getPricePerKwh()), bg);
            addCell(table, fmt(b.getSubFee()), bg);
            addCell(table, fmt(b.getTotalUsd()), bg);
            addCell(table, fmt(b.getTotalLbp()), bg);
            alt = !alt;
        }
        return table;
    }

    private PdfPTable buildAmperTable(List<Bill> bills) throws DocumentException {
        PdfPTable table = new PdfPTable(8);
        table.setWidthPercentage(100);
        table.setWidths(new float[]{3,2,2,2,2,2,2,2});

        String[] headers = {"Customer","Zone","Box","Amper Cap","Price/Amper","Sub Fee","Total USD","Total LBP"};
        addHeaderRow(table, headers);

        boolean alt = false;
        for (Bill b : bills) {
            BaseColor bg = alt ? ALT_BG : BaseColor.WHITE;
            addCell(table, b.getCustomerName(), bg);
            addCell(table, b.getZoneName(), bg);
            addCell(table, b.getBoxName(), bg);
            addCell(table, fmt(b.getAmperCapacity()), bg);
            addCell(table, fmt(b.getPricePerAmper()), bg);
            addCell(table, fmt(b.getSubFee()), bg);
            addCell(table, fmt(b.getTotalUsd()), bg);
            addCell(table, fmt(b.getTotalLbp()), bg);
            alt = !alt;
        }
        return table;
    }

    private void addHeaderRow(PdfPTable table, String[] headers) {
        for (String h : headers) {
            PdfPCell cell = new PdfPCell(new Phrase(h, HEADER_FONT));
            cell.setBackgroundColor(HEADER_BG);
            cell.setHorizontalAlignment(Element.ALIGN_CENTER);
            cell.setPadding(5);
            table.addCell(cell);
        }
    }

    private void addCell(PdfPTable table, String value, BaseColor bg) {
        PdfPCell cell = new PdfPCell(new Phrase(value != null ? value : "", NORMAL_FONT));
        cell.setBackgroundColor(bg);
        cell.setPadding(4);
        table.addCell(cell);
    }

    private String fmt(Object val) {
        return val != null ? val.toString() : "-";
    }
}
