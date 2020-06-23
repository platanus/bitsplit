class UserMailer < ApplicationMailer
    default from: 'hello@bitsplit.app'
 
    def welcome_email
      @user = params[:user]
      @url  = 'http://www.bitsplit.app'
      mail(to: @user.email, subject: 'Welcome to Bitsplit')
    end
end