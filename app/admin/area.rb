ActiveAdmin.register Area do

  menu :if => proc{ current_admin_user }, parent: 'Area Details'

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
  permit_params :name, :city_id

  filter :id
  filter :name
  
  # Index page definition
  index pagination_total: false do
    selectable_column
    id_column
    column :name
    column :city
    column :created_at
    actions
  end

  # Show page definition
  show do
    tabs do
      tab "Details" do
        attributes_table_for area do
          row :id
          row :name
          row :city
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
          f.input :name, include_blank: false
          f.input :city
        end
      end

    end
    f.actions
  end
end
