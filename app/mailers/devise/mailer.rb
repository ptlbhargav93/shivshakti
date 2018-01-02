if defined?(ActionMailer)
  class Devise::Mailer < Devise.parent_mailer.constantize
    include Devise::Mailers::Helpers
    
    default :from => "'#{I18n.t('max')}' <no-reply@fenux.fi>"

    def confirmation_instructions(record, token, opts={})
      @token = token
        @signup_supportersclub = opts[:signup_supportersclub]
      @ssl = opts[:ssl]
      devise_mail(record, :confirmation_instructions, opts)
    end

    def reset_password_instructions(record, token, opts={})
      @token = token
      devise_mail(record, :reset_password_instructions, opts)
    end

    def unlock_instructions(record, token, opts={})
      @token = token
      devise_mail(record, :unlock_instructions, opts)
    end
  end
end
