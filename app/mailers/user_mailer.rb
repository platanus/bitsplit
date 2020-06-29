class UserMailer < ApplicationMailer
    default from: 'hello@bitsplit.app'
 
    def welcome_email
      @user = params[:user]
      @url  = 'https://pl-bitsplit-staging.herokuapp.com'
      mail(to: @user.email, subject: '¡Bienvenido a Bitsplit!')
    end

    def payment_email
      @user = params[:user]
      @amount = ('%.10f' % params[:amount].to_s).sub(/0*$/,"")
      @sender = params[:sender]
      @url  = 'https://pl-bitsplit-staging.herokuapp.com'
      subject = 'Bitsplit: ' + @sender.email + ' te transfirió ' + @amount.to_s + ' BTC'
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
      @url  = 'https://pl-bitsplit-staging.herokuapp.com'
      mail(to: @user.email, subject: 'Cambio de contraseña exitoso')
    end

    def unregistered_email
      @user = params[:user]
      @sender = params[:sender]
      @amount = ('%.10f' % params[:amount].to_s).sub(/0*$/,"")
      @token = params[:token]
      last = 'token=' + @token + '&email=' + @user.email
      @url  = 'https://pl-bitsplit-staging.herokuapp.com/new-account?' + last
      mail(to: @user.email, subject: '¡Tienes dinero en Bitsplit!')
    end
end