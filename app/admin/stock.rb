ActiveAdmin.register Stock do

  menu :if => proc{ current_admin_user }, parent: 'Balance & stock'

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
  permit_params :product_id, :stock_date, :open_stock, :stock_in, :stock_out

  filter :id
  filter :product
  
  # Index page definition
  index pagination_total: false do
    selectable_column
    id_column
    column :product
    column :stock_date
    column :open_stock
    column :stock_in
    column :stock_out
    actions
  end

  # Show page definition
  show do
    tabs do
      tab "Details" do
        attributes_table_for stock do
          row :id
          row :product
          row :stock_date
          row :open_stock
          row :stock_in
          row :stock_out
        end
      end
    end
  end

  form multipart: true do |f|
    tabs do
      f.semantic_errors *f.object.errors.keys
      tab "Details" do
        f.inputs "Details" do
          f.input :product
          f.input :stock_date
          f.input :open_stock
          f.input :stock_in
          f.input :stock_out
        end
      end

    end
    f.actions
  end
end
