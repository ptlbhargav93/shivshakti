$(document).ready(function(){

  //load working clinic field
  if ($(".working-clinics").length == 0){
    $(".addWorkingClinic").trigger('click');
    $(".nested-fields").first().find( ".removeWorkingClinic" ).css('display','none')
  }else{
    $(".working-clinics").first().find( ".removeWorkingClinic" ).css('display','none')
  }

  // hide show laboratory fee based on dentist commited to it
  if($(".is_committed_to_laboratory_fee").length > 0){
    $(".is_committed_to_laboratory_fee").change(function() {
      var inputValue = $(this).attr("value")
      var idArr = this.id.split("_");
      var id = idArr[idArr.length - 1];
      if ($(this).is(':checked')) {
        if (inputValue == "true"){
          $("#own_lab_fee_" + id).removeClass('hide');  
        }
        else{
          $("#own_lab_fee_" + id).addClass('hide');
        }
      }
    });
  }
  
  $.each($('.is_committed_to_laboratory_fee'), function() {
    var committed_radio_checked = $(this).attr('id');
    var idArr = committed_radio_checked.split("_")
    var id = idArr[idArr.length - 1];
    if ($("#is_committed_to_laboratory_fee_true_"+ id).is(':checked')){
      $("#own_lab_fee_" + id).removeClass('hide');
    }
    else{
      $("#own_lab_fee_" + id).addClass('hide');
    }
  });

  //reward share and fee disabling
  if ($(".fixed_rental_radio").length > 0){
    $(".fixed_rental_radio").closest('div').next().find('input').attr("disabled", false);
  }

  if ($(".fixed_reward_radio").length > 0){
    $(".fixed_reward_radio").closest('div').next().find('input').attr("disabled", false);
  }

  $(".fixed_rental_radio").click(function(){
    enable_disable_text_input_box("empty","fixed_rental_radio","fixed_rental_","fixed_rental_per_month_","fixed_rental_per_hour_")
  });

  $(".fixed_rental_per_month").click(function(){
    enable_disable_text_input_box("empty","fixed_rental_per_month","fixed_rental_","fixed_rental_per_month_","fixed_rental_per_hour_")
  });

  $(".fixed_rental_per_hour").click(function(){
    enable_disable_text_input_box("empty","fixed_rental_per_hour","fixed_rental_","fixed_rental_per_month_","fixed_rental_per_hour_")
  });

  // reward share and fee diabling for relationship type employee model
  $(".fixed_reward_radio").click(function(){
    enable_disable_text_input_box("empty","fixed_reward_radio","fixed_reward_","fixed_salary_per_month_","fixed_salary_per_hour_")
  });

  $(".fixed_salary_per_month").click(function(){
    enable_disable_text_input_box("empty","fixed_salary_per_month","fixed_reward_","fixed_salary_per_month_","fixed_salary_per_hour_")
  });

  $(".fixed_salary_per_hour").click(function(){
    enable_disable_text_input_box("empty","fixed_salary_per_hour","fixed_reward_","fixed_salary_per_month_","fixed_salary_per_hour_")
  });

  // incentive model disabling
  $(".incentive_type_per_month").click(function(){
    enable_disable_text_input_box(this,"incentive_type_per_month","hourly_rental_rate_","hourly_reward_rate_","average_hourly_rate_","after_rental_rate_")
  });

  $(".incentive_type_per_hour").click(function(){
    enable_disable_text_input_box(this,"incentive_type_per_hour","hourly_rental_rate_","hourly_reward_rate_","average_hourly_rate_","after_rental_rate_")
  });

  //additional fee disabling
  $(".is_hygienist_fee").click(function(){
    enable_disable_text_input_box(this,"is_hygienist_fee","is_hygienist_fee_check_","hygienist_fee_")
  });

  $(".is_xray_fee").click(function(){
    enable_disable_text_input_box(this,"is_xray_fee","is_xray_fee_check_","xray_fee_","xray_billing_per_")
  });

  $(".is_own_laboratory_fee").click(function(){
    enable_disable_text_input_box(this,"is_own_laboratory_fee","is_own_laboratory_fee_check_","own_laboratory_fee_")
  });

  //Payment rules disabling
  $(".third_party_latest_day").click(function(){
    enable_disable_text_input_box(this,"third_party_latest_day","third_party_latest_day_","dentist_share_latest_day_","clinics_share_latest_day_")
  });

  $(".dentist_share_latest_day").click(function(){
    enable_disable_text_input_box(this,"dentist_share_latest_day","third_party_latest_day_","dentist_share_latest_day_","clinics_share_latest_day_")
  });

  $(".clinics_share_latest_day").click(function(){
    enable_disable_text_input_box(this,"clinics_share_latest_day","third_party_latest_day_","dentist_share_latest_day_","clinics_share_latest_day_")
  });

  if($(".add_introduction_text").length > 0){
    $(".add_introduction_text").click(function() {
      var idArr = this.id.split("_");
      var id = idArr[idArr.length - 1];
      $(".add_introduction_text" + id).remove();
      $("#introduction_text_area" + id).removeClass('hide');
    });
  }

  if($("#user_introduction").val() != ""){
    $(".add_introduction_text").remove();
    $("#introduction_text_area").removeClass('hide');
  }

  //add aditional job role
  $(document).on("click", ".add_new_job_role",  function() {
    $(".remove_job_role").parent().remove();
    $("#other_job_role").append('<div class="col-xs-12 col-sm-3 col-md-2 form-group text-right pt10"><label class="remove_job_role"  id="remove_job_role"><a href="javascript:void(0)" class="addLink remove_fields dynamic"><i class="removeIcon"></i>Remove</a></label></div>')
    $(".add_new_job_role").addClass('hide')
    $("#other_job_role").removeClass('hide')
  });
  $(document).on("click",".remove_job_role", function() {
    showAddNewOtherJobRole()
  });

  $(document).on("click",".job_role", function() {
    $(".other_job_role").prop("checked", false);
  });

  $(document).on("click",".closeTab", function() {
    $(this).parent().remove();
    showAddNewOtherJobRole()
  });

  $(document).on("click",".edit_note_date", function() {
    $(this).parent().parent().remove();
    $(".add_new_job_role").addClass('hide')
    $("#other_job_role").removeClass('hide')
    $(".remove_job_role").parent().remove();
    $("#other_job_role").append('<div class="col-xs-12 col-sm-3 col-md-2 form-group text-right pt10"><label class="remove_job_role"  id="remove_job_role"><a href="javascript:void(0)" class="addLink remove_fields dynamic"><i class="removeIcon"></i>Remove</a></label></div>')
  });


  $(document).on("click",".other_job_role", function() {
    $(".job_role").prop("checked", false);
  });
  
  $(".linkedin-icon").click(function() {
    enable_disable_social_input_box("linkedin-icon","linkedin-form")
  });

  $(".facebook-icon").click(function() {
    enable_disable_social_input_box("facebook-icon","facebook-form")
  });

  $(".twitter-icon").click(function() {
    enable_disable_social_input_box("twitter-icon","twitter-form")
  });

  $(".youtube-icon").click(function() {
    enable_disable_social_input_box("youtube-icon","youtube-form")
  });

  $(".whatsapp-icon").click(function() {
    enable_disable_social_input_box("whatsapp-icon","whatsapp-form")
  });

  $(".skype-icon").click(function() {
    enable_disable_social_input_box("skype-icon","skype-form")
  });

  $(".has_billing_place_info").click(function(){
    var idArr = $(this).attr("id").split("_");
    var id = idArr[idArr.length-1];
    $("#has_billing_place_info_"+ id).change(function () {
      if ($("#has_billing_place_info_"+ id).find('input:checkbox:first').is(':checked')){
        $("#dentist_name_"+id).removeAttr('disabled');
        $("#billing_place_number_"+id).removeAttr('disabled');
      }
      else
      {
        $("#dentist_name_"+id).attr({'disabled': 'disabled'});
        $("#billing_place_number_"+id).attr({'disabled': 'disabled'});
      }
    });
  });

  if ($(".has_billing_place_info").length > 0){
    var has_billing_place_info_id = $(".has_billing_place_info").attr("id")
    var id_arr =  has_billing_place_info_id.split("_")
    var id = id_arr[id_arr.length-1];
    if ($("#has_billing_place_info_"+ id).find('input:checkbox:first').is(':checked')){
      $("#dentist_name_"+id).removeAttr('disabled');
      $("#billing_place_number_"+id).removeAttr('disabled');
    }
    else
    {
      $("#dentist_name_"+id).attr({'disabled': 'disabled'});
      $("#billing_place_number_"+id).attr({'disabled': 'disabled'});
    }  
  }

  // add turnover steps in incentive model
  $(document).on("click", ".add_new_incentive_steps",  function() {
    var remove = I18n.t("js.general.task.remove")
    var clinic_user_id_arr = $(this).attr("id").split("_")
    var clinic_user_id = clinic_user_id_arr[clinic_user_id_arr.length - 2]
    var relationship_type_id = clinic_user_id_arr[clinic_user_id_arr.length - 3]
    var user_role = clinic_user_id_arr[clinic_user_id_arr.length - 1]
    var newTextBoxDiv = $(document.createElement('div'))
    var length = parseInt($(".all_steps_"+clinic_user_id).length)+1;

    if(relationship_type_id == "MODEL"){
      if (user_role == "HYGIENIST"){
        var turnover_type = "employee_turnover"
        var reward_type = "employee_rental"
        var patient_per_month_type_id = "patient_employee_model_per_month"
      }
      else
      {
        var turnover_type = "employee_turnover"
        var reward_type = "employee_reward"
        var patient_per_month_type_id = "patient_employee_model_per_month"
      }
    }
    else
    {
        var turnover_type = "turnover"
        var reward_type = "rental"
        var patient_per_month_type_id = "patient_turnover_per_month"
    }
    var turnover_step_html_input = '<div class ="all_steps_'+clinic_user_id+'"><div class="row row5 form-group"><div class="col-xs-2 pt12"><label>'+I18n.t("js.general.clinic_users.turnover")+'</label></div>' +
      '<div class="col-xs-3"><input class ="virtualKeyboard form-control" type="text" name="'+patient_per_month_type_id+'['+clinic_user_id+'][step_'+length+']['+turnover_type+']" id="'+patient_per_month_type_id+'_'+turnover_type+'_'+clinic_user_id +'_'+ length + '" value="" ></div>'+
      '<div class="col-xs-2 pt12"><label>'+I18n.t("js.general.clinic_users.rental")+'</label></div>' +
      '<div class="col-xs-3"><input class ="virtualKeyboard form-control" type="text" name="'+patient_per_month_type_id+'['+clinic_user_id+'][step_'+length+']['+reward_type+']" id="'+patient_per_month_type_id+'_'+reward_type+'_'+clinic_user_id +'_'+ length + '" value="" ></div>' +
      '<a class = "removestep col-xs-1 pt12" href="javascript:void(0)" id="removestep_'+clinic_user_id+'_'+length+'">'+remove+'</a></div>'
  
    newTextBoxDiv.after().html(turnover_step_html_input);
      
    newTextBoxDiv.appendTo("#input_step_box_"+clinic_user_id).find('.virtualKeyboard').keyboard({
      layout: 'custom',
      restrictInput : true, // Prevent keys not in the displayed keyboard from being typed in
      preventPaste : true,  // prevent ctrl-v and right click
      autoAccept : true, 
      keyBinding: 'mousedown touchstart',   
      position: {
        of: null, // null = attach to input/textarea; use $(sel) to attach elsewhere
        my: 'center top',
        at: 'center top',
        at2: 'center bottom', // used when "usePreview" is false
        collision: 'flipfit flipfit'
      },
      usePreview: true,
      initialFocus: true,
      reposition: true,
    });
    length++;
  });

  $(document).on("click",".removestep", function() {
    $(this).parent().remove();
  });
});

function showAddNewOtherJobRole(){
  $("#other_job_role_text_box").val("");
  $("#other_job_role").addClass('hide');
  $(".add_new_job_role").removeClass('hide');
}

function enable_disable_text_input_box(object,className,elementID1,elementID2,elementID3,elementID4){
  if (arguments[0] instanceof Object){
    var idArr = object.id.split("_");
    var id = idArr[idArr.length - 1];  
  }
  else
  {
    var idArr = $("."+className).attr("id").split("_");
    var id = idArr[idArr.length - 1];  
  }
  
  if (className == "fixed_rental_radio" || className == "fixed_reward_radio" || className == "third_party_latest_day"){
    $("#" + elementID1+ id).removeAttr('disabled');
    $("#" + elementID2+ id).attr({'disabled': 'disabled'});
    $("#" + elementID3+ id).attr({'disabled': 'disabled'});
  }
  else if(className == "fixed_rental_per_month" || className == "fixed_salary_per_month" || className == "dentist_share_latest_day"){
    $("#" + elementID2+ id).removeAttr('disabled');
    $("#" + elementID1+ id).attr({'disabled': 'disabled'});
    $("#" + elementID3+ id).attr({'disabled': 'disabled'});
  }
  else if(className == "fixed_rental_per_hour" || className == "fixed_salary_per_hour" || className == "clinics_share_latest_day"){
    $("#" + elementID3+ id).removeAttr('disabled');
    $("#" + elementID1+ id).attr({'disabled': 'disabled'});
    $("#" + elementID2+ id).attr({'disabled': 'disabled'});
  }
  else if (className == "incentive_type_per_month"){
    $(".all_steps_"+ id).find('input').removeAttr('disabled')
    $(".add_new_incentive_steps").unbind('click')
    $("#" + elementID1+ id).attr({'disabled': 'disabled'})
    $("#" + elementID2+ id).attr({'disabled': 'disabled'})
    $("#" + elementID3+ id).attr({'disabled': 'disabled'})
    $("#" + elementID4+ id).attr({'disabled': 'disabled'})
  }
  else if (className == "incentive_type_per_hour"){
    $(".all_steps_"+ id).find('input').attr({'disabled': 'disabled'})
    $("#add_new_incentive_steps_EMPLOYEE_MODEL_"+id).click(function () {return false;})
    $("#add_new_incentive_steps_PRACTITIONER_"+id).click(function () {return false;})
    $("#add_new_incentive_steps_PAYROLL_COMPANY_"+id).click(function () {return false;})
    $("#" + elementID1+ id).removeAttr('disabled')
    $("#" + elementID2+ id).removeAttr('disabled')
    $("#" + elementID3+ id).removeAttr('disabled')
    $("#" + elementID4+ id).removeAttr('disabled')
  }

  if (className.length > 0){
    if(className == "is_hygienist_fee" || className == "is_xray_fee" || className == "is_own_laboratory_fee")
    {
      $("#" + elementID1+ id).change(function () {
        if ($("#" + elementID1+ id).find('input:checkbox:first').is(':checked')){
          $(".xray_fee_type").change(function () {
            if ($("#xray_fee_radio_button").is(':checked')){
              $("#" + elementID2+ id).removeAttr('disabled');
              $("#" + elementID3+ id).attr({'disabled': 'disabled'});
            }
            else if($("#xray_billing_per_radio_button").is(':checked'))
            {
              $("#" + elementID2+ id).attr({'disabled': 'disabled'});
              $("#" + elementID3+ id).removeAttr('disabled');
            }
          });
          $("#" + elementID2+ id).removeAttr('disabled');
        }
        else{
          $("#" + elementID2+ id).attr({'disabled': 'disabled'});
          $("#" + elementID3+ id).attr({'disabled': 'disabled'});
        }
      });
    }
  }
}

function enable_disable_social_input_box(IconClassName,InputClassID){
  var social_text_box_ids = ["linkedin-form","facebook-form","twitter-form","youtube-form","whatsapp-form","skype-form"]
  var social_icons = ["linkedin-icon","facebook-icon","twitter-icon","youtube-icon","whatsapp-icon","skype-icon"]
  
  if (IconClassName == "linkedin-icon" || IconClassName == "facebook-icon" || IconClassName == "twitter-icon" || IconClassName == "youtube-icon" || IconClassName == "whatsapp-icon" || IconClassName == "skype-icon"){
    var social_id = IconClassName.split("-")[0]
    var selected_social_icon = [social_id+"-form"]
    var social_text_boxs = $(social_text_box_ids).not(selected_social_icon).get().toString().split(",")
    for(i=0; i < social_text_boxs.length; i++){
      $("#"+social_text_boxs[i]).addClass("hide")
    }
    $("#"+social_id+"-form").removeClass('hide');
  }
}