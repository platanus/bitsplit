ActiveAdmin.register NotificationToken do
  actions :index, :show
  includes :user
end
