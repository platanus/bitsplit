ActiveAdmin.register User do
  actions :index, :show, :edit, :update
  permit_params :email, :password, :password_confirmation, :name, :last_name, :birth_date, :picture,
                :wallet, :api_key, :api_secret, :splitwise_token, :oauth_token, :oauth_secret,
                :splitwise_user_id, :splitwise_secret

  index do
    selectable_column
    id_column
    column :email
    column :name
    column :last_name
    column :birth_date
    column :picture
    column :wallet
    column :splitwise_user_id
    column :logged
    column :created_at
    actions
  end

  filter :email
  filter :name
  filter :last_name
  filter :birth_date
  filter :wallet
  filter :splitwise_user_id
  filter :logged
  filter :created_at

  form do |f|
    f.inputs do
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :name
      f.input :last_name
      f.input :birth_date
      f.input :wallet
      f.input :api_key
      f.input :api_secret
      f.input :splitwise_user_id
      f.input :splitwise_token
      f.input :splitwise_secret
      f.input :oauth_token
      f.input :oauth_secret
    end
    f.actions
  end
end
