ActiveAdmin.register User do

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
  permit_params :role, :is_active, :is_deleted, :email, :password, :password_confirmation,
                :first_name, :last_name,
                resources_attributes: [:id, :media, :resource_type_id, :resource_spec_id, :_destroy]

  filter :id
  filter :role, as: :select, collection: User.roles.to_a
  filter :email
  filter :first_name
  filter :last_name
  
  # Index page definition
  index pagination_total: false do
    selectable_column
    id_column
    column :role
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
          row :role
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

      tab "Resources" do
        table_for user.resources do
          column :id do |r|
            link_to r.id, admin_resource_path(r.id)
          end
          column :media do |r|
            if r.resource_type.name == "IMAGE"
              image_tag r.media.url(:small)
            else
              link_to r.media_file_name, r.media.url
            end
          end
          column "Resource Type" do |r|
            r.resource_type
          end
          column "Resource Spec" do |r|
            r.resource_spec
          end
        end
      end
    end
  end

  form multipart: true do |f|
    tabs do
      f.semantic_errors *f.object.errors.keys
      tab "Details" do
        f.inputs "Details" do
          f.input :role, include_blank: false
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


      if !object.new_record?
        tab "Resources" do
          f.inputs "Resources" do
            f.has_many :resources, new_record: "Add a resource", allow_destroy: true do |ff|
              ff.semantic_errors *ff.object.errors.keys

              ff.input :media, :as => :file
              ff.input :resource_type, required: true
              ff.input :resource_spec, required: true
            end
          end
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
