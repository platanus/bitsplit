class MoneyService < PowerTypes::Service.new(:sender, :receiver, :amount, :wallet_origin)
  @error_message = 'error'
  # all transaction will have a transfer within its transaction
  # as a minimun
  # 1) bitsplit-buda: transfer -> withdrawal
  # 2) buda-bitsplit: payment -> transfer
  # 3) buda-buda: payment -> transfer -> withdrawal
  # 4) bitsplit-bitsplit: transfer
  def payment
    invoice = generate_invoice
    if invoice == nil
      return false, @error_message
    end
    
    if invoice != false
      payment = pay_invoice(invoice)
      if payment == nil
        return false, @error_message
      end
    else
      payment = "internal payment done"
    end
    make_ledgerizer_registration
    return true, payment
  end

  def generate_invoice
    if @receiver.wallet == 'buda'
      api_key, api_secret = @receiver.buda_keys
      buda_service = BudaUserService.new(api_key: api_key, api_secret: api_secret)
      response = buda_service.generate_invoice(@amount)
      return nil unless check_buda_invoice_creation(response)
      invoice = JSON.parse(response.body)['invoice']['encoded_payment_request']
    else
      return false unless @wallet_origin != @receiver.wallet
      open_node_service = OpenNodeService.new
      response = open_node_service.send_charge_request(@amount, nil, nil)
      return nil unless check_opennode_response(response)
      invoice = JSON.parse(response.body)['data']['lightning_invoice']['payreq']
    end
    invoice
  end

  def pay_invoice(invoice)
    if @wallet_origin == 'buda'
      api_key, api_secret = @sender.buda_keys
      buda_service = BudaUserService.new(api_key: api_key, api_secret: api_secret)
      simulate = ENV.fetch('INVOICE_PAYMENT_SIMULATION')
      payment = buda_service.pay_invoice(@amount, invoice, simulate)
      return nil unless check_buda_invoice_payment(payment)
   
    elsif @wallet_origin == 'bitsplit'
      open_node_service = OpenNodeService.new
      payment = open_node_service.send_withdrawal_request(invoice)
      return nil unless check_opennode_response(payment)
    
    else
      @error_message = 'this origin wallet type is not available'
      return nil
    end
    payment
  end

  def check_buda_invoice_creation(response)
    if !response.has_key? 'invoice'
      @error_message = response
      return false
    end
    return true
  end

  def check_buda_invoice_payment(invoice_payment)
    if !invoice_payment.has_key? 'withdrawal'
      @error_message = invoice_payment
      return false
    end
    return true
  end

  def check_opennode_response(response)
    if !JSON.parse(response.body).has_key? 'data'
      @error_message = response
      return false
    end
    data = JSON.parse(response.body)['data']
    if !data.has_key? 'id'
      @error_message = response
      return false
    end
    return true
  end

  def make_ledgerizer_registration
    @ledgerizer = LedgerizerService.new
    if @wallet_origin != 'bitsplit'
      @ledgerizer.deposit(@sender, @amount)
    end

    @ledgerizer.transfer(@sender, @receiver, @amount.to_f)

    if @receiver.wallet != 'bitsplit'
      @ledgerizer.withdrawal(@receiver, @amount)
    end
  end

end
