ActiveAdmin.register CustomerAccount do

  menu :if => proc{ current_admin_user }, parent: 'Customer details'

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
  permit_params :customer_id, :debit_amount, :debit_bill_number, :debit_bill_date, :credit_amount, :credit_bill_number, :credit_bill_date, :verified

  filter :id
  filter :customer
  
  # Index page definition
  index pagination_total: false do
    selectable_column
    id_column
    column :customer
    column :debit_amount
    column :debit_bill_number
    column :debit_bill_date
    column :credit_amount
    column :credit_bill_number
    column :credit_bill_date
    column :verified
    actions
  end

  # Show page definition
  show do
    tabs do
      tab "Details" do
        attributes_table_for customer_account do
          row :id
          row :customer
          row :debit_amount
          row :debit_bill_number
          row :debit_bill_date
          row :credit_amount
          row :credit_bill_number
          row :credit_bill_date
          row :verified
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
          f.input :customer_id
          f.input :debit_amount
          f.input :debit_bill_number
          f.input :debit_bill_date
          f.input :credit_amount
          f.input :credit_bill_number
          f.input :credit_bill_date
          f.input :verified
        end
      end

    end
    f.actions
  end
end
