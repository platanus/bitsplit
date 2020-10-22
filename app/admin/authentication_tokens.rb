ActiveAdmin.register AuthenticationToken do
  actions :index, :show
  includes :user
end
