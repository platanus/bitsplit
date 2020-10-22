ActiveAdmin.register UserWithdrawal do
  actions :index, :show
  includes :user
end
