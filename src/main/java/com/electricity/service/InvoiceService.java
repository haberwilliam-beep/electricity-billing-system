package com.electricity.service;

import com.electricity.dao.InvoiceDao;
import com.electricity.model.Bill;
import com.electricity.model.Invoice;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Service
@Transactional
public class InvoiceService {

    private final InvoiceDao invoiceDao;
    private final BillingService billingService;

    @Autowired
    public InvoiceService(InvoiceDao invoiceDao, BillingService billingService) {
        this.invoiceDao = invoiceDao;
        this.billingService = billingService;
    }

    public Invoice findById(Long id) {
        return invoiceDao.findById(id);
    }

    public Invoice findByInvoiceNumber(String invoiceNumber) {
        return invoiceDao.findByInvoiceNumber(invoiceNumber);
    }

    public List<Invoice> findAll() {
        return invoiceDao.findAll();
    }

    public List<Invoice> findByClientId(Long clientId) {
        return invoiceDao.findByClientId(clientId);
    }

    public List<Invoice> findByMonthAndYear(int billingMonth, int billingYear) {
        return invoiceDao.findByMonthAndYear(billingMonth, billingYear);
    }

    /**
     * Generates an invoice from an existing bill.
     *
     * @param billId the bill ID
     * @return the generated Invoice
     */
    public Invoice generateInvoiceFromBill(Long billId) {
        Bill bill = billingService.findById(billId);

        Invoice invoice = new Invoice();
        invoice.setInvoiceNumber(generateInvoiceNumber());
        invoice.setBillId(billId);
        invoice.setClientId(bill.getClientId());
        invoice.setBillingMonth(bill.getBillingMonth());
        invoice.setBillingYear(bill.getBillingYear());
        invoice.setIssueDate(LocalDate.now());
        invoice.setDueDate(LocalDate.now().plusDays(30));
        invoice.setTotalAmountUsd(bill.getTotalAmountUsd());
        invoice.setTotalAmountLbp(bill.getTotalAmountLbp());
        invoice.setExchangeRate(bill.getExchangeRate());
        invoice.setStatus(Invoice.InvoiceStatus.ISSUED);

        invoiceDao.insert(invoice);

        // Mark bill as invoiced
        billingService.updateStatus(billId, Bill.BillStatus.INVOICED.name());

        return invoice;
    }

    public void updateInvoice(Invoice invoice) {
        invoiceDao.update(invoice);
    }

    public void deleteInvoice(Long id) {
        invoiceDao.deleteById(id);
    }

    public void updateStatus(Long id, String status) {
        invoiceDao.updateStatus(id, status);
    }

    public long countAll() {
        return invoiceDao.countAll();
    }

    private String generateInvoiceNumber() {
        String datePrefix = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyyMMdd"));
        long count = invoiceDao.countAll() + 1;
        return String.format("INV-%s-%04d", datePrefix, count);
    }
}
