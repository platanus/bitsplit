class MoneyService < PowerTypes::Service.new(:sender, :receiver, :amount, :wallet_origin)
  # all transaction will have a transfer within its transaction
  # as a minimun
  # 1) bitsplit-buda: transfer -> withdrawal
  # 2) buda-bitsplit: payment -> transfer
  # 3) buda-buda: payment -> transfer -> withdrawal
  # 4) bitsplit-bitsplit: transfer

  def payment
    @error_message = 'error'

    #generar invoice
    if @receiver.wallet == 'buda'

      # verificar que el receptor tenga cuenta en buda 
      if @receiver.api_key.nil? || @receiver.api_secret.nil? 
        @error_message = 'receiver user does not have buda api_keys'
        return false, @error_message
      end
      api_key, api_secret = @receiver.buda_keys
      buda_service = BudaUserService.new(api_key: api_key, api_secret: api_secret)
      response = buda_service.generate_invoice(@amount)

      # verificar que el invoice se creó correctamente 
      if !response.has_key? 'invoice'
        @error_message = response
        return false, @error_message
      end
      invoice = JSON.parse(response.body)['invoice']['encoded_payment_request']
    
    else
      open_node_service = OpenNodeService.new
      response = open_node_service.send_charge_request(@amount, 'BTC')
      data = JSON.parse(response.body)['data']
      
      # verificar que el invoice se creó correctamente 
      if !data.has_key? 'id'
        @error_message = response
        return false, @error_message
      end
      invoice = JSON.parse(response.body)['data']['lightning_invoice']['payreq']
    end

    #pagar invoice
    if @wallet_origin == 'buda'
      # verificar que el emisor tenga cuenta en buda
      if @sender.api_key.nil? || @sender.api_secret.nil? 
        @error_message = 'sender user does not have buda api_keys'
        return false, @error_message
      end
      api_key, api_secret = @sender.buda_keys
      buda_service = BudaUserService.new(api_key: api_key, api_secret: api_secret)
      simulate = ENV.fetch('INVOICE_PAYMENT_SIMULATION')
      invoice_payment = buda_service.pay_invoice(@amount, invoice, simulate)
      # verificar que el pago se realizó correctamente
      if !invoice_payment.has_key? 'withdrawal'
        @error_message = invoice_payment
        return false, @error_message
      end

    else @wallet_origin == 'bitsplit'
      open_node_service = OpenNodeService.new
      invoice_payment = open_node_service.send_withdrawal_request(invoice)
      data = JSON.parse(response.body)['data']
      # verificar que el pago se realizó correctamente
      if !data.has_key? 'id'
        @error_message = invoice_payment
        return false, @error_message
      end
    end
  
    #hacer registro en ledgerizer
    @ledgerizer = LedgerizerService.new

    #si el que envía lo hace desde una wallet distinta a bitsplit, registrar depósio
    if @wallet_origin != 'bitsplit'
      @ledgerizer.deposit(@sender, @amount)
    end

    # registrar la transferencia
    @ledgerizer.transfer(@sender, @receiver, @amount)

    #si el que recibe lo hace desde una wallet distinta a bitsplit, registrar retiro
    if @receiver.wallet != 'bitsplit'
      @ledgerizer.withdrawal(@receiver, @amount)
    end

    return true, @error_message
  end
end
