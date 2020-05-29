class MoneyService < PowerTypes::Service.new(:sender, :receiver, :amount, :wallet_origin)
  # all transaction will have a transfer within its transaction
  # as a minimun
  # 1) bitsplit-buda: transfer -> withdrawal
  # 2) buda-bitsplit: payment -> transfer
  # 3) buda-buda: payment -> transfer -> withdrawal
  # 4) bitsplit-bitsplit: transfer

  def payment
    @ledgerizer = LedgerizerService.new
    return buda(@receiver.wallet) if @wallet_origin == 'buda'
    return bitsplit(@receiver.wallet) if @wallet_origin == 'bitsplit'
  end

  private

  def buda(receiver_wallet)
    return buda_buda if receiver_wallet == 'buda'
    return buda_bitsplit if receiver_wallet == 'bitsplit'
  end

  def bitsplit(receiver_wallet)
    return bitsplit_buda if receiver_wallet == 'buda'
    return bitsplit_bitsplit if receiver_wallet == 'bitsplit'
  end

  def bitsplit_buda
    # generate ln in buda and pay it with opennode
    api_key, api_secret = @receiver.buda_keys
    buda_service = BudaUserService.new(api_key: api_key, api_secret: api_secret)
    open_node_service = OpenNodeService.new

    # get ln code from buda
    response = buda_service.generate_invoice(@amount)
    ln_code = JSON.parse(response.body)['invoice']['encoded_payment_request']
    # pass ln_code to opennode to execute payment
    open_node_service.send_withdrawal_request(ln_code)

    @ledgerizer.transfer(@sender, @receiver, @amount)
    @ledgerizer.withdrawal(@receiver, @amount)
  end

  def buda_bitsplit
    # generate charge in opennode and pay it with buda
    api_key, api_secret = @sender.buda_keys
    buda_service = BudaUserService.new(api_key: api_key, api_secret: api_secret)
    open_node_service = OpenNodeService.new

    # get ln code from opennode
    response = open_node_service.send_charge_request(@amount, 'BTC')
    ln_code = JSON.parse(response.body)['data']['lightning_invoice']['payreq']
    # pass ln_code to buda to execute payment
    simulate = ENV.fetch('INVOICE_PAYMENT_SIMULATION')
    buda_service.pay_invoice(@amount, ln_code, simulate)

    @ledgerizer.deposit(@sender, @amount)
    @ledgerizer.transfer(@sender, @receiver, @amount)
  end

  def buda_buda
    payments_service = PaymentsService.new(sender: @sender, receiver: @receiver)
    _success, @error_message, _new_payment = payments_service.create_payment(@amount)

    @ledgerizer.deposit(@sender, @amount)
    @ledgerizer.transfer(@sender, @receiver, @amount)
    @ledgerizer.withdrawal(@receiver, @amount)
  end

  def bitsplit_bitsplit
    @ledgerizer.transfer(@sender, @receiver, @amount)
  end
end
