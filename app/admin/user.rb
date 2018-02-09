ActiveAdmin.register User do

  menu :if => proc{ current_admin_user }, parent: 'System Settings'

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end
  permit_params :is_active, :is_deleted, :email, :password, :password_confirmation,
                :first_name, :last_name

  filter :id
  filter :email
  filter :first_name
  filter :last_name
  
  # Index page definition
  index pagination_total: false do
    selectable_column
    id_column
    column :email
    column :first_name
    column :last_name
    column :is_active
    column :is_deleted
    column :created_at
    actions
  end

  # Show page definition
  show do
    tabs do
      tab "Details" do
        attributes_table_for user do
          row :id
          row :email
          row :first_name
          row :last_name
          row :is_active
          row :is_deleted
          row :last_sign_in_at
          row :created_at
          row :updated_at
        end
      end
    end
  end

  form multipart: true do |f|
    tabs do
      f.semantic_errors *f.object.errors.keys
      tab "Details" do
        f.inputs "Details" do
          f.input :email
          if f.object.new_record?
            f.input :password, required: true
            f.input :password_confirmation, required: true
          else
            f.input :password, required: false
            f.input :password_confirmation, required: false
          end
          f.input :first_name, required: true
          f.input :last_name, required: true
          f.input :is_active
          f.input :is_deleted
        end
      end
    end
    f.actions
  end

  controller do

    def update
      if params[:user][:password].blank? and params[:user][:password_confirmation].blank?
        params[:user].delete("password")
        params[:user].delete("password_confirmation")
      end
      super
    end
  end
end
