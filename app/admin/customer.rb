ActiveAdmin.register Customer do

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
  permit_params :company_name

  filter :id
  filter :company_name
  
  # Index page definition
  index pagination_total: false do
    selectable_column
    id_column
    column :company_name
    column :person_name
    column :mobile_number1
    column :area
    column :gst_number
    actions
  end

  # Show page definition
  show do
    tabs do
      tab "Details" do
        attributes_table_for area do
          row :id
          row :company_name
          row :person_name
          row :mobile_number1
          row :mobile_number1
          row :mobile_number3
          row :address
          row :city
          row :area
          row :gst_number
        end
      end
    end
  end

  form multipart: true do |f|
    tabs do
      f.semantic_errors *f.object.errors.keys
      tab "Details" do
        f.inputs "Details" do
          f.input :company_name
          f.input :person_name
          f.input :mobile_number1
          f.input :mobile_number2
          f.input :mobile_number3
          f.textarea :address
          f.input :city_id
          f.input :area_id
          f.input :gst_number
        end
      end

    end
    f.actions
  end
end
