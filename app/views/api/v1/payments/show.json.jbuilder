json.data do
    json.type "payments"
    json.attributes{
        json.sent_payments @sent_payments_format
        json.received_payments @received_payments_format
    }
end