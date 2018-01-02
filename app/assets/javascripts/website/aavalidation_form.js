$(function(){

  I18n.locale = document.documentElement.lang;
  $.fn.datepicker.defaults.language = I18n.locale;

  // user form validation
  $('#executive-form, #director-form, #dentist-form').formValidation({
    framework: 'bootstrap',
    fields: {
      user_first_name: {
        selector: "#user_first_name",
        validators: {
            notEmpty: {message: I18n.t("js.general.task.mandatory_field")}
        }
      },
      user_last_name: {
        selector: "#user_last_name",
        validators: {
            notEmpty: {message: I18n.t("js.general.task.mandatory_field")}
        }
      },
      user_email: {
        selector: "#user_email",
        validators: {
            notEmpty: {message: I18n.t("js.general.task.mandatory_field")}
        }
      }
    }
  });

  // responisble preson register form
  $('#register-responsible-person').formValidation({
    framework: 'bootstrap',
    fields: {
      responsible_area_of_responsibility: {
        selector: "#responsible_area_of_responsibility",
        validators: {
            notEmpty: {message: I18n.t("js.general.task.mandatory_field")}
        }
      },
      responsible_first_name: {
        selector: "#responsible_first_name",
        validators: {
            notEmpty: {message: I18n.t("js.general.task.mandatory_field")}
        }
      },
      responsible_last_name: {
        selector: "#responsible_last_name",
        validators: {
            notEmpty: {message: I18n.t("js.general.task.mandatory_field")}
        }
      },            
      responsible_email: {
        selector: "#responsible_email",
        validators: {
            notEmpty: {message: I18n.t("js.general.task.mandatory_field")}
        }
      }      
    }
  });  


  //office form validation
  $('#clinic-form').formValidation({
    framework: 'bootstrap',
    fields: {
      office_office_name: {
        selector: "#clinic_clinic_name",
        validators: {
            notEmpty: {message: I18n.t("js.general.task.mandatory_field")}
        }
      },
      office_company_id: {
        selector: "#clinic_company_id",
        validators: {
            notEmpty: {message: I18n.t("js.general.task.mandatory_field")}
        }
      },
      office_company_name: {
        selector: "#clinic_company_name",
        validators: {
            notEmpty: {message: I18n.t("js.general.task.mandatory_field")}
        }
      },
      office_email: {
        selector: "#clinic_email",
        validators: {
            notEmpty: {message: I18n.t("js.general.task.mandatory_field")}
        }
      }      
    }
  });

  //order_email_form
  $('#order_email_form').formValidation({
    framework: 'bootstrap',
    fields: {
      input_recipient_email: {
        selector: "#input_recipient_email",
        validators: {
            notEmpty: {message: I18n.t("js.general.task.mandatory_field")}
        }
      },
      subject: {
        selector: "#subject",
        validators: {
            notEmpty: {message: I18n.t("js.general.task.mandatory_field")}
        }
      },
      message: {
        selector: "#message",
        validators: {
            notEmpty: {message: I18n.t("js.general.task.mandatory_field")}
        }
      }      
    }
  });

  //send_login_info_by_email_form
  $('#send_login_info_by_email_form, #send_invoice_via_email_form').formValidation({
    framework: 'bootstrap',
    fields: {
      recipient_email: {
        selector: "#recipient_email",
        validators: {
            notEmpty: {message: I18n.t("js.general.task.mandatory_field")}
        }
      },
      subject: {
        selector: "#subject",
        validators: {
            notEmpty: {message: I18n.t("js.general.task.mandatory_field")}
        }
      },
      message: {
        selector: "#message",
        validators: {
            notEmpty: {message: I18n.t("js.general.task.mandatory_field")}
        }
      }      
    }
  });   

  // send feedback email form
  $('#send_feedback_email_form').bootstrapValidator({
    feedbackIcons: {
      valid: 'fa fa-ok',
      invalid: 'fa fa-remove',
      validating: 'fa fa-refresh'
    },
    fields: {
      feedback_message: {
        selector: "#feedback_message",
        validators: {
            notEmpty: {message: I18n.t("js.general.task.mandatory_field")}
        }
      }
    }
  });
});
