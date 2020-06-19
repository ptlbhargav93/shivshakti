
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery 
  # with: :exception

  before_filter :current_brand

  before_filter :set_locale

  before_filter :current_brand_custom_domain_or_subdomain, :current_brand_custom_domain_or_slug

  before_action :common_nav_header_menu, :only => [:index, :show, :new, :create, :edit, :update], :if => "controller_name == 'directors' or controller_name == 'executives' or controller_name == 'dentists' or controller_name == 'clinics'"

  before_action :fetch_all_type_users, only: [:index, :user_filter, :next_users, :filter, :next_clinics], :if => "controller_name == 'directors' or controller_name == 'executives' or controller_name == 'dentists' or controller_name == 'clinics'"

  before_action :open_card_param, only: [:show]

  include ApplicationHelper

  LOCALE_LANG = ["en", "fi"]

  class BrandNotFound < StandardError
  end  

  def page
    params[:page] || 1
  end

  def limit
    params[:per] || Settings.system.per_page
  end

  def first_limit
    params[:per] || Settings.system.per_page_first
  end  

  def current_brand
    begin
      @current_brand ||= Brand.find_by_slug(session[:current_brand_slug]) || Brand.find_by_custom_domain(request.host) || Brand.find_by_slug('shivshakti')
    rescue ActiveRecord::RecordNotFound => e
      raise BrandNotFound
    end
  end  

  def current_brand_custom_domain_or_subdomain
    custom_domain = @current_brand.custom_domain ? @current_brand.custom_domain : request.subdomain
    if custom_domain == 'staff'
      redirect_to request.protocol + request.domain.to_s + '/shivshakti'
    end
    return custom_domain
  end

  def current_brand_custom_domain_or_slug
    @current_brand.custom_domain ? @current_brand.custom_domain : @current_brand.slug
  end

  def set_turnover_steps user
    if params[:patient_turnover_per_month].present?
      turover_hash = {}
      params[:patient_turnover_per_month].each do |(key,value)|
        clinic_user = user.clinic_users.find(key)
        value.each_with_index do |(k,v),idx|
          idx+=1
          turover_hash["step_#{idx}"] = v
        end
        clinic_user.update_attributes({patient_turnover_per_month: turover_hash})
      end
    end
    if params[:patient_employee_model_per_month].present?
      employee_hash = {}
      params[:patient_employee_model_per_month].each do |(key,value)|
        clinic_user = user.clinic_users.find(key)
        value.each_with_index do |(k,v),idx|
          idx+=1
          employee_hash["step_#{idx}"] = v
        end
        clinic_user.update_attributes({patient_employee_model_per_month: employee_hash})
      end
    end
  end

  private

  def authenticate_executive!
    redirect_to root_path if authenticate_user! and !current_user.executive?
  end

  def authenticate_staff!
    redirect_to root_path if authenticate_user! and !current_user.staff?
  end

  def set_lang_cookie
    # set language cookie using query string parameter 'lang'
    session[:lang] = params[:locale] if params[:locale] and LOCALE_LANG.include?(params[:locale])
  end
  
  def set_locale
    set_lang_cookie
    I18n.locale = session[:lang] || params[:locale] || I18n.default_locale
  end

  def extract_locale_from_accept_language_header
    request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first if request.env['HTTP_ACCEPT_LANGUAGE']
  end

  def open_card_param
    session[:open_card] = true
  end

  def check_user_skills user
    params[:language_skills].present? ? set_user_skills(:language_skills, user) : user.language_skills.destroy_all
  end

  def set_other_languages user
    new_languages = []
    if user.languages.present?
      current_languages = user.languages.split(",")
      current_languages.each do |current_language|
        new_languages.push(current_language) if params["language_#{current_language}"].present? and params["language_#{current_language}"] == "true"
      end
    end
    if params[:languages].present?
      params[:languages].each do |key,value|
        new_languages.push(value) unless new_languages.include?(value)
      end
    end
    user.languages = new_languages.join(",")
  end

  def get_user_type_redirection_path user
    if current_user.can_update_user? user
      user_role = user.user_role.role.downcase.pluralize
      if ["executives","directors","dentists"].include?(user_role)
        return eval("#{user_role}_path")
      end
    else
      return root_path
    end
  end

  def fetch_users
    if controller_name == "dentists"
      session[:user_role] = session[:user_role].nil? ? params[:user_role] : session[:user_role]
      users = eval("User.joins(:user_role).where('user_roles.role = ?',UserRole.roles[session[:user_role]])")
    else
      users = controller_name == "clinics" ? eval("@current_brand.#{controller_name}") : eval("User.#{controller_name}")
    end

    search_type = "#{controller_name.singularize}_search".to_sym

    if params[:search].present?      
      search = session[search_type] = params[:search]
    else
      if params[:role].present?
        search = session[search_type] = nil
      else
        search = session[search_type] if session[search_type].present?
      end
    end
    if search.present?
      session[search_type] = search
      users = controller_name == "clinics" ? users.where('clinic_name LIKE ? or city LIKE ?', "%#{search}%", "%#{search}%") : (users.where('first_name LIKE ? or last_name LIKE ? or city LIKE ?', "%#{search}%", "%#{search}%", "%#{search}%"))
    end

    if controller_name == "dentists"
      users = users.includes(:clinic_users)
      dentist_clinic = "#{controller_name.singularize}_clinic".to_sym
      dentist_speciality_types = "#{controller_name.singularize}_speciality_types".to_sym  
      dentist_language_skill = "#{controller_name.singularize}_language_skill".to_sym   
      
      if params[:clinic].present?
        clinic = session[dentist_clinic] = params[:clinic]
      else
        if params[:role].present?
          clinic = session[dentist_clinic] = nil
        else
          clinic = session[dentist_clinic] if session[dentist_clinic].present?
        end
      end
      if clinic.present?
        session[dentist_clinic] = clinic
        users = users.joins(:clinics).where("clinic_users.clinic_id = ?",clinic)
      end

      if params[:speciality_types].present?
        speciality_type = session[dentist_speciality_types] = params[:speciality_types]
      else
        if params[:role].present?
          speciality_type = session[dentist_speciality_types] = nil
        else
          speciality_type = session[dentist_speciality_types] if session[dentist_speciality_types].present?
        end
      end
      if speciality_type.present?
        session[dentist_speciality_types] = speciality_type
        users = users.where("speciality = ?",User.specialities[speciality_type])
      end

      if params[:language_skill].present?      
        language_skill = session[dentist_language_skill] = params[:language_skill]
      else
        if params[:role].present?
          language_skill = session[dentist_language_skill] = nil
        else
          language_skill = session[dentist_language_skill] if session[dentist_language_skill].present?
        end
      end
      conditions = []
      values = []
      if language_skill.present?
        session[dentist_language_skill] = language_skill
        conditions << "(user_skills.skill_id = ? AND user_skills.skill_type = 'LanguageSkill')"
        values << language_skill
      end
      users = users.joins(:user_skills).where("(#{conditions.join(' OR ')})", *values) if conditions.present?
    end

    users = params[:order].present? ? users.order("id #{params[:order]}").uniq : users.order('id DESC')
  end

  def set_other_job_role user
    if params[:user][:job_role].present?
      if params[:o_job_role].present?
        params[:user][:job_role] = ''
        user.other_job_role = params[:o_job_role]
      end
    else
      user.job_role = ""
    end
  end

  def remove_users_blank_resources
    if params[:user].present?
      if params[:user][:resources_attributes].present?
        params[:user][:resources_attributes].each do |key, resource|
          unless resource["id"].present?
            unless resource["media"].present?
              params[:user][:resources_attributes].delete(key)
            end
          end
        end
      end
    end
  end

  def common_nav_header_menu
    if action_name == "index"
      @nav_header_menus = [
                          {:href => desktop_executives_path, :label => t("nav_header.desktop"), :arrowBack => false},
                          {:href => resources_and_variables_executives_path, :label => t("nav_header.resources_and_variable"), :arrowBack => true}
                        ]
      @back_to_top = true
      session[:open_card] = nil
    else
      if authenticate_user!
          if current_user.staff?
              @nav_header_menus = [
                      {:href => root_path, :label => t("nav_header.desktop"), :arrowBack => false},
                      {:href => clinic_profile_directors_path, :label => t("nav_header.my_clinic_profile"), :arrowBack => true}
                    ]
          else
            @nav_header_menus = [
                                  {:href => desktop_executives_path, :label => t("nav_header.desktop"), :arrowBack => false},
                                  {:href => eval("#{controller_name}_path"), :label => t("nav_header.#{controller_name}"), :arrowBack => true},
                                ]
          end
      end
    end
  end
  
  def fetch_all_type_users
    limitation = (action_name  == "next_users" or action_name  == "next_clinics") ? limit : first_limit 
    eval("@#{controller_name} = fetch_users.page(page).per(limitation)")
    render layout: false if action_name  == "next_users" or action_name  == "next_clinics"
  end

  def set_user_skills skill_type, user
    skills = []
    params[skill_type].each do |skill_id|
      skills << user.user_skills.find_or_create_by(skill_id: skill_id, skill_type: skill_type.to_s.camelize.singularize)
    end
    skills_to_be_removed = user.user_skills.where(skill_type: skill_type.to_s.camelize.singularize) - skills
    skills_to_be_removed.each{|s| s.destroy} if skills_to_be_removed.present?
  end

  def set_pdf_asset_url
    request_protocol = Rails.env.development? ? "//" : request.protocol
    if @current_brand.custom_domain.present?
      @domain_url = "#{request_protocol}#{@current_brand.custom_domain}/default/pdf/"
    else
      @domain_url = "#{Settings.system.domain}/default/pdf/"
    end
  end
end
