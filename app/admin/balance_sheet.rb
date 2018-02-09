ActiveAdmin.register BalanceSheet do

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
  permit_params :account_date, :open_balance, :income_balance, :expense_balance, :close_balance

  filter :id
  filter :account_date
  
  # Index page definition
  index pagination_total: false do
    selectable_column
    id_column
    column :account_date
    column :open_balance
    column :income_balance
    column :expense_balance
    column :close_balance
    actions
  end

  # Show page definition
  show do
    tabs do
      tab "Details" do
        attributes_table_for balance_sheet do
          row :id
          row :account_date
          row :open_balance
          row :income_balance
          row :expense_balance
          row :close_balance
        end
      end
    end
  end

  form multipart: true do |f|
    tabs do
      f.semantic_errors *f.object.errors.keys
      tab "Details" do
        f.inputs "Details" do
          f.input :account_date
          f.input :open_balance
          f.input :income_balance
          f.input :expense_balance
          f.input :close_balance
        end
      end

    end
    f.actions
  end
end
