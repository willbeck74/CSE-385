SELECT  *,
        [Balance] = (InvoiceTotal - PaymentTotal - CreditTotal)
FROM Invoices
WHERE isDeleted = 0 AND (InvoiceTotal - PaymentTotal - CreditTotal) > 0

SELECT * 
FROM vwInvoices
WHERE Balance > 0