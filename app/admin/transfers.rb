ActiveAdmin.register Transfer do
  menu parent: 'Accounting'
  actions :index, :show
  includes :sender, :receiver
end
