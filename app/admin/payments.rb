ActiveAdmin.register Payment do
  actions :index, :show
  includes :sender, :receiver
end
