ActiveAdmin.register Deposit do
  menu parent: 'Accounting'
  actions :index, :show
  includes :user
end
