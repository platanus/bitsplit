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

    invoice_payment = pay_invoice
    if invoice_payment == nil
      return false, @error_message
    end

    make_ledgerazer_registration
    return true, @error_message
  end


  def generate_invoice
    if receiver_wallet == 'buda'
      return nil unless check_user_buda_account(@receiver)
      api_key, api_secret = @receiver.buda_keys
      buda_service = BudaUserService.new(api_key: api_key, api_secret: api_secret)
      response = buda_service.generate_invoice(@amount)
      return nil unless check_buda_invoice_creation(response)
      invoice = JSON.parse(response.body)['invoice']['encoded_payment_request']
    
    else
      open_node_service = OpenNodeService.new
      response = open_node_service.send_charge_request(@amount, 'BTC')
      return nil unless check_opennode_response(response)
      invoice = JSON.parse(response.body)['data']['lightning_invoice']['payreq']
    
    end
    return invoice
  end

  def pay_invoice
    if @wallet_origin == 'buda'
      return nil unless check_user_buda_account(@sender)
      api_key, api_secret = @sender.buda_keys
      buda_service = BudaUserService.new(api_key: api_key, api_secret: api_secret)
      simulate = ENV.fetch('INVOICE_PAYMENT_SIMULATION')
      invoice_payment = buda_service.pay_invoice(@amount, invoice, simulate)
      return nil unless check_buda_invoice_payment(invoice_payment)
   
    else
      open_node_service = OpenNodeService.new
      invoice_payment = open_node_service.send_withdrawal_request(invoice)
      return nil unless check_opennode_response(invoice_payment)
    
    end
    return invoice_payment
  end
  
  def check_user_buda_account(user)
    if user.api_key.nil? || user.api_secret.nil? 
      @error_message = 'user does not have buda api_keys'
      return false
    end 
    return true
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
    data = JSON.parse(response.body)['data']
    if !data.has_key? 'id'
      @error_message = response
      return false
    end
    return true
  end

  def make_ledgerazer_registration
    @ledgerizer = LedgerizerService.new
    
    if @wallet_origin != 'bitsplit'
      @ledgerizer.deposit(@sender, @amount)
    end

    @ledgerizer.transfer(@sender, @receiver, @amount)

    if @receiver.wallet != 'bitsplit'
      @ledgerizer.withdrawal(@receiver, @amount)
    end
  end

end
