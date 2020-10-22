ActiveAdmin.register UserDeposit do
  actions :index, :show
  includes :user
end
