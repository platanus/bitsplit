class UserMailer < ApplicationMailer
    default from: 'hello@bitsplit.app'
 
    def welcome_email
      @user = params[:user]
      @url  = 'http://www.bitsplit.app'
      mail(to: @user.email, subject: '¡Bienvenido a Bitsplit!')
    end

    def payment_email
      @user = params[:user]
      @amount = params[:amount]
      @url  = 'http://www.bitsplit.app'
      mail(to: @user.email, subject: '¡Nuevo pago en Bitsplit!')
    end

    def recover_email
      @user = params[:user]
      @url  = 'http://www.bitsplit.app'
      mail(to: @user.email, subject: 'Recupera tu contraseña en Bitsplit')
    end

    def unregistered_email
      @user = params[:user]
      @sender = params[:sender]
      @amount = params[:amount]
      @url  = 'http://www.bitsplit.app'
      mail(to: @user.email, subject: '¡Tienes dinero en Bitsplit!')
    end
end