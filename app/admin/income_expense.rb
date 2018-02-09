ActiveAdmin.register IncomeExpense do

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
  permit_params :amount_type, :amount_date, :amount, :customer_id, :user_id, :provider_id

  filter :id
  filter :amount_type
  
  # Index page definition
  index pagination_total: false do
    selectable_column
    id_column
    column :amount_type
    column :amount_date
    column :amount
    column :customer
    column :user
    column :provider
    column :close_balance
    actions
  end

  # Show page definition
  show do
    tabs do
      tab "Details" do
        attributes_table_for income_expense do
          row :id
          row :amount_type
          row :amount_date
          row :amount
          row :customer
          row :user
          row :provider
        end
      end
    end
  end

  form multipart: true do |f|
    tabs do
      f.semantic_errors *f.object.errors.keys
      tab "Details" do
        f.inputs "Details" do
          f.input :amount_date
          f.input :amount_date
          f.input :amount
          f.input :customer
          f.input :user
          f.input :provider
          f.textarea :detail
        end
      end

    end
    f.actions
  end
end
