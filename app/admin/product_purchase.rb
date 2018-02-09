ActiveAdmin.register ProductPurchase do

  menu :if => proc{ current_admin_user }, parent: 'Product details'

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
  permit_params :product_id, :provider_id, :purchase_date, :total_bag, :kg_per_bag, :amount_per_kg

  filter :id
  filter :product
  filter :provider
  
  # Index page definition
  index pagination_total: false do
    selectable_column
    id_column
    column :product
    column :provider
    column :purchase_date
    column :total_bag
    column :kg_per_bag
    column :amount_per_kg
    column :created_at
    actions
  end

  # Show page definition
  show do
    tabs do
      tab "Details" do
        attributes_table_for product_purchase do
          row :id
          row :product
          row :provider
          row :purchase_date
          row :total_bag
          row :kg_per_bag
          row :amount_per_kg
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
          f.input :product
          f.input :provider
          f.input :purchase_date
          f.input :total_bag
          f.input :kg_per_bag
          f.input :amount_per_kg
        end
      end

    end
    f.actions
  end
end
