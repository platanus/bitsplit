class UnregisteredUserService < PowerTypes::Service.new(:email)
  
  def create
    random_password = (0...8).map { (65 + rand(26)).chr }.join
    new_user = User.create!(email: @email,
                            password: random_password, 
                            password_confirmation: random_password)
  end
end
