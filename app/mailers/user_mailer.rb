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
      @sender = params[:sender]
      @url  = 'http://www.bitsplit.app'
      subject = 'Bitsplit: ' + @sender + ' te transfirió ' + @amount.to_s + ' BTC'
      mail(to: @user.email, subject: subject)
    end

    def recover_password
      @user = params[:user]
      @token = params[:token]
      last = 'token=' + @token + '&email=' + @user.email
      @url  = 'https://pl-bitsplit-staging.herokuapp.com/new-password?' + last
      mail(to: @user.email, subject: 'Recupera tu contraseña en Bitsplit')
    end

    def password_recovered
      @user = params[:user]
      @url  = 'http://www.bitsplit.app'
      mail(to: @user.email, subject: 'Cambio de contraseña exitoso')
    end

    def unregistered_email
      @user = params[:user]
      @sender = params[:sender]
      @amount = params[:amount]
      @token = params[:token]
      last = 'token=' + @token + '&email=' + @user.email
      @url  = 'https://pl-bitsplit-staging.herokuapp.com/new-account?' + last
      mail(to: @user.email, subject: '¡Tienes dinero en Bitsplit!')
    end
end