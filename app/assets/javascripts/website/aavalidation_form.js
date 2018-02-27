$(function(){

  I18n.locale = document.documentElement.lang;
  $.fn.datepicker.defaults.language = I18n.locale;

  // user form validation
  $('#executive-form').formValidation({
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

  // responisble customer register form
  $('#register-customer').formValidation({
    framework: 'bootstrap',
    fields: {
      customer_name: {
        selector: "#customer_name",
        validators: {
            notEmpty: {message: I18n.t("js.general.task.mandatory_field")}
        }
      }      
    }
  });

  // customer bill register form
  $('#register-customer-bill').formValidation({
    framework: 'bootstrap',
    fields: {
      customer_bill_bill_number: {
        selector: "#customer_bill_bill_number",
        validators: {
            notEmpty: {message: I18n.t("js.general.task.mandatory_field")}
        }
      },
      customer_bill_bill_date: {
        selector: "#customer_bill_bill_date",
        validators: {
            notEmpty: {message: I18n.t("js.general.task.mandatory_field")}
        }
      },
      customer_bill_total_amount: {
        selector: "#customer_bill_total_amount",
        validators: {
            notEmpty: {message: I18n.t("js.general.task.mandatory_field")}
        }
      }                  
    }
  });  

  $('#register-provider').formValidation({
    framework: 'bootstrap',
    fields: {
      provider_name: {
        selector: "#provider_name",
        validators: {
            notEmpty: {message: I18n.t("js.general.task.mandatory_field")}
        }
      }      
    }
  });  

  // customer bill
  $('#register-customer-bill').formValidation({
    framework: 'bootstrap',
    fields: {
      bill_number: {
        selector: "#bill_number",
        validators: {
            notEmpty: {message: I18n.t("js.general.task.mandatory_field")}
        }
      },
      bill_date: {
        selector: "#bill_date",
        validators: {
            notEmpty: {message: I18n.t("js.general.task.mandatory_field")}
        }
      },
      customer_id: {
        selector: "#customer_id",
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
