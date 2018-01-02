$(document).ready(function(){
	$(document).on("click", ".billing_user", function(){
      var id = getId(this.id);

      if ($("#billing_user_check_" + id).is(":checked")) {
        //add to the actual param
        addIdToArray("selected_professional_person", id);
        // update to unselect text
        set_unselect_text("#billing_user_select_text_" + id, "#billing_user_unselect_text_" + id);
      }
      else {
        // remove from actual param
        removeIdFromArray("selected_professional_person", id);
        // update to select text
        set_select_text("#billing_user_select_text_" + id, "#billing_user_unselect_text_" + id);
      }
	  });

  $(document).on("click", ".select_user", function(){
    var id = getId(this.id);
    set_selected_user(id);
    if (!$("#select_user_check_" + id).is(":checked")) {
      $("#selected_user_register").val("");
    }
  });

  // show clinic users information
  $(".show_selected_clinic_users_information").click(function(){
    $(this).parent().parent().find("#clinic_users_form").toggleClass("hide");
    if ($(this).hasClass("iconUp")){
      $(this).removeClass("iconUp");
      $(this).addClass("iconBottom");
    }
    else{
      $(this).removeClass("iconBottom");
      $(this).addClass("iconUp");
    }
    $(this).find(".show_selected_clinic_users_information_arrow").toggleClass("hide");
  });

  $(".lockUnlockInvoice").click(function(){
    var id = getId(this.id);
    alert(id)
    is_invoice_lock =  ($("#lock_unlock_user_bill_"+id).val() == "true") ? "false" : "true";
    if (is_invoice_lock == "false"){
      $(".product_total_price_"+id).removeClass("product_total_price")
      $(this).find("i").text(I18n.t("js.general.task.press_hear_to_lock_this_invoice_quality_check"))
    }else{
      $(".product_total_price_"+id).addClass("product_total_price")
      $(this).find("i").text(I18n.t("js.general.task.press_hear_to_unlock_this_invoice_quality_check"))
    }
    is_invoice_lock =  $("#lock_unlock_user_bill_"+id).val(is_invoice_lock)
  });
  

  $(document).on("change", ".billingMethodRadiobtn", function(){
    var form = $(this).closest('form');
    if ($(this).val() == "AUTOMATIC"){
      $(form).find("button[type='submit']").prop('disabled',true);
      $(".billingMethodAutoDesc").removeClass('hide');
      $(".billingMethodDescription").addClass('hide');
      $(".autoDescSystemNotification").removeClass('hide');
    }else{
      $(form).find("button[type='submit']").prop('disabled',false);
      $(".billingMethodAutoDesc").addClass('hide');
      $(".billingMethodDescription").removeClass('hide');
      $(".autoDescSystemNotification").addClass('hide');
    }
  });

  $(document).on("change", ".billing_period_date", function(){
    dateArr = [];
    $(".billing_period_date").each(function() {
      dateArr.push($(this).val())
    });
    console.log(dateArr)
    url = '/send_bills/choose_user';
    $.ajax({
      url: url,
      type: 'GET',
      data: { year: dateArr[0], month: dateArr[1], check_billing_period : "true",}
    });
  });

  for (i = 0; i < 4; i++) {
    $("#user_bill_user_billing_costs_attributes_"+i+"__destroy").next('a').css('display', 'none');
  }

  $(".user_billing_costs").on('cocoon:after-remove', function(){
    calculate_billing_data();
  });

  calculate_billing_data();

  $(document).on('change', $('[id*="billing_reduction_cost_amount_"]'), function(){
    calculate_billing_data();
  });

  $(document).on('change', $("#value_of_invoiced_work_amt"), function(){
    calculate_billing_data();
  });

  $(document).on('change', $("#value_of_work_done_amt"), function(){
    calculate_billing_data();
  });

  if ($("#hygienist_fee").length > 0){
    calculate_additional_fee("#hygienist_fee","#hygienist_additional_note","#hygienist_total_fee");
    calculate_additional_fee("#xray_fee","#xray_additional_note","#xray_total_fee");
    calculate_additional_fee("#own_laboratory_fee","#own_laboratory_additional_note","#own_laboratory_total_fee");  
  }
  

  $(document).on('change', "#hygienist_fee", function(){
    calculate_additional_fee("#hygienist_fee","#hygienist_additional_note","#hygienist_total_fee");
  });

  $(document).on('change', "#hygienist_additional_note", function(){
    calculate_additional_fee("#hygienist_fee","#hygienist_additional_note","#hygienist_total_fee");
  });

  $(document).on('change', "#xray_fee", function(){
    calculate_additional_fee("#xray_fee","#xray_additional_note","#xray_total_fee");
  });

  $(document).on('change', "#xray_additional_note", function(){
    calculate_additional_fee("#xray_fee","#xray_additional_note","#xray_total_fee");
  });

  $(document).on('change', "#own_laboratory_fee", function(){
    calculate_additional_fee("#own_laboratory_fee","#own_laboratory_additional_note","#own_laboratory_total_fee");
  });

  $(document).on('change', "#own_laboratory_additional_note", function(){
    calculate_additional_fee("#own_laboratory_fee","#own_laboratory_additional_note","#own_laboratory_total_fee");
  });

  //additional fee disabling
  $(".is_hygienist_fee").click(function(){
    calculate_additional_fee("#hygienist_fee","#hygienist_additional_note","#hygienist_total_fee");
    disable_text_input("is_hygienist_fee","is_hygienist_fee","hygienist_fee","hygienist_additional_note")
  });

  $(".is_xray_fee").click(function(){
    calculate_additional_fee("#xray_fee","#xray_additional_note","#xray_total_fee");
    disable_text_input("is_xray_fee","is_xray_fee","xray_fee","xray_additional_note")
  });

  $(".is_own_laboratory_fee").click(function(){
    calculate_additional_fee("#own_laboratory_fee","#own_laboratory_additional_note","#own_laboratory_total_fee");
    disable_text_input("is_own_laboratory_fee","is_own_laboratory_fee","own_laboratory_fee","own_laboratory_additional_note")
  });
});

function set_selected_user(id) {
  $(".select_user_unselect_text").addClass('hide');
  $(".select_user_select_text").removeClass('hide');  
  var $box = $("#select_user_check_" + id);
  set_select_text("#select_user_select_text_" + id, "#select_user_unselect_text_" + id);
  if ($box.is(":checked")) {
    $("#selected_user_register").val(id);
    var group = "input:checkbox[name='" + $box.attr("name") + "']";
    $(group).prop("checked", false);
    $box.prop("checked", true);
    set_unselect_text("#select_user_select_text_" + id, "#select_user_unselect_text_" + id);
    // url = '/send_bills/choose_user';
    // $.ajax({
    //   url: url,
    //   type: 'GET',
    //   data: {select_user : id}
    // });
  }
}

function set_contact(id) {
  $(".billing_user_unselect_text").addClass('hide');
  $(".billing_user_select_text").removeClass('hide');
  var $box = $("#billing_user_check_" + id);
  set_select_text("#billing_user_select_text_" + id, "#billing_user_unselect_text_" + id);
  if ($box.is(":checked")) {
    $("#selected_professional_person").val(id);
    var group = "input:checkbox[name='" + $box.attr("name") + "']";
    $(group).prop("checked", false);
    $box.prop("checked", true);
    set_unselect_text("#billing_user_select_text_" + id, "#billing_user_unselect_text_" + id);
  }
}

function calculate_billing_data(){
  var TotalBillingReduction = 0;
  var TotalOtherAddition = 0;
  var TotatAdditionalReduction = 0;
  var TotalAdditionalAddition = 0;

  var value_of_invoiced_work_amt = $("#value_of_invoiced_work_amt").val()
  var value_of_work_done_amt = $("#value_of_work_done_amt").val()

  var billing_reduction_elements = document.getElementsByClassName('billing_reduction_cost_amount');
  var billing_reduction_cost_name_elements = document.getElementsByClassName('billing_reduction_cost_name')

  var other_rental_addition_elements = document.getElementsByClassName('other_rental_addition_cost_amount');
  var other_rental_addition_cost_name_elements = document.getElementsByClassName('other_rental_addition_cost_name')

  var additonal_addition_elements = document.getElementsByClassName('other_billing_addition_cost_amount');
  var additonal_addition_cost_name_elements = document.getElementsByClassName('other_billing_addition_cost_name');

  var additonal_reduction_elements = document.getElementsByClassName('other_billing_reduction_cost_amount')
  var additonal_reduction_cost_name_elements = document.getElementsByClassName('other_billing_reduction_cost_name');

  var billing_reduction_cost_amount_array = $.map($('[id*="billing_reduction_cost_amount_"]'), function(n, i){
    if (n.value == undefined){
      n.value = 0;
    }
    else if(n.value == ""){
      n.value = 0;
    }
    else if(n.value.trim().length == 0){
      n.value = 0;
    }
    else{
      return n.value.replace(/,/g, ".");
    }
  });

  var other_rental_addition_cost_amount_array = $.map($('[id*="other_rental_addition_cost_amount_"]'), function(n, i){
    if (n.value == undefined){
      n.value = 0;
    }
    else if(n.value == ""){
      n.value = 0;
    }
    else if(n.value.trim().length == 0){
      n.value = 0;
    }
    else{
      return n.value.replace(/,/g, ".");
    }
  });

  var additonal_addition_cost_amount_array = $.map($('[id*="other_billing_addition_cost_amount_"]'), function(n, i){
    if (n.value == undefined){
      n.value = 0;
    }
    else if(n.value == ""){
      n.value = 0;
    }
    else if(n.value.trim().length == 0){
      n.value = 0;
    }
    else{
      return n.value.replace(/,/g, ".");
    }
  });

  var additonal_reduction_cost_amount_array = $.map($('[id*="other_billing_reduction_cost_amount_"]'), function(n, i){
    if (n.value == undefined){
      n.value = 0;
    }
    else if(n.value == ""){
      n.value = 0;
    }
    else if(n.value.trim().length == 0){
      n.value = 0;
    }
    else{
      return n.value.replace(/,/g, ".");
    }
  });

  if ($(billing_reduction_elements).length > 0 ){

    for(var i=0; i <= billing_reduction_elements.length - 1; i++){
      TotalBillingReduction += checkNumericVal(parseFloat(billing_reduction_cost_amount_array[i]));      
    }

    $("#through_blling_reduction_total").val(TotalBillingReduction)
    for(var i=0; i <= other_rental_addition_elements.length - 1; i++){
      TotalOtherAddition += checkNumericVal(parseFloat(other_rental_addition_cost_amount_array[i]));      
    }

    if ($("#base_for_rent_or_reward").val() == "VALUE_OF_INVOICED_WORK"){
      if (value_of_invoiced_work_amt == undefined || value_of_invoiced_work_amt == ""){
        var final = TotalOtherAddition + TotalBillingReduction
        $("#rent_basis_billing_label").val(final.toFixed(2).toString().replace(".",","))
        if ($("#dentist_reward_base").length > 0){
          calculate_dentist_share_of_billing("#rent_basis_billing","#dentist_reward_base","#dentist_share_of_billing")
        }
      }
      else if (value_of_invoiced_work_amt != ""){
        var final = parseFloat(value_of_invoiced_work_amt.replace(/,/g, "."))-parseFloat(TotalBillingReduction)+parseFloat(TotalOtherAddition);
        $("#rent_basis_billing_label").val(convert_to_string(final))
        if ($("#dentist_reward_base").length > 0){
          calculate_dentist_share_of_billing("#rent_basis_billing","#dentist_reward_base","#dentist_share_of_billing")
        }
      }
    }else{
      if (value_of_work_done_amt == undefined || value_of_work_done_amt == ""){
        var final = TotalOtherAddition + TotalBillingReduction
        $("#rent_basis_billing_label").val(final.toFixed(2).toString().replace(".",","))
        if ($("#dentist_reward_base").length > 0){
          calculate_dentist_share_of_billing("#rent_basis_billing","#dentist_reward_base","#dentist_share_of_billing")
        }
      }
      else if (value_of_work_done_amt != ""){
        var final = parseFloat(value_of_work_done_amt.replace(/,/g, "."))-parseFloat(TotalBillingReduction)+parseFloat(TotalOtherAddition);
        $("#rent_basis_billing_label").val(convert_to_string(final))
        if ($("#dentist_reward_base").length > 0){
          calculate_dentist_share_of_billing("#rent_basis_billing","#dentist_reward_base","#dentist_share_of_billing")
        }
      }
    }
  }

  if (additonal_addition_elements.length > 0 || additonal_reduction_elements.length > 0){
    for(var i=0; i <= additonal_addition_elements.length - 1; i++){
        TotalAdditionalAddition += checkNumericVal(parseFloat(additonal_addition_cost_amount_array[i]));      
      }

    for(var i=0; i <= additonal_reduction_elements.length - 1; i++){
        TotatAdditionalReduction += checkNumericVal(parseFloat(additonal_reduction_cost_amount_array[i]));      
      }
    }

  var calculate_xray_fee = (checkNumericVal(parseFloat($("#table_xray_comission_established").text()))*checkNumericVal(parseFloat($("#table_xray_fee").val()))/100)
  $("#table_xray_total_fee").text(calculate_xray_fee)
  var additional_fee_total = checkNumericVal(parseFloat($("#table_xray_total_fee").text().replace(/,/g, "."))) + checkNumericVal(parseFloat($("#table_hygienist_total_fee").text().replace(/,/g, "."))) + checkNumericVal(parseFloat($("#table_own_laboratory_total_fee").text().replace(/,/g, ".")))

  if ($("#dentist_share_of_billing").length > 0){
    $("#periods_additional_fee_total").val(additional_fee_total.toFixed(2).toString().replace(".",","))
    $("#dentist_share_in_period").val(checkNumericVal(parseFloat($("#dentist_share_of_billing").val().replace(/,/g, "."))) + checkNumericVal(parseFloat(additional_fee_total)) + checkNumericVal(parseFloat(TotalAdditionalAddition)) - checkNumericVal(parseFloat(TotatAdditionalReduction)))
    
    $("input.billing_reduction_cost_amount").attr("disabled","disabled")
    $("input.billing_reduction_cost_name").attr("disabled","disabled")

    $("input.other_billing_addition_cost_name").attr("disabled","disabled")
    $("input.other_billing_addition_cost_amount").attr("disabled","disabled")

    $("input.other_billing_reduction_cost_name").attr("disabled","disabled")
    $("input.other_billing_reduction_cost_amount").attr("disabled","disabled")

    $("input.other_rental_addition_cost_amount").attr("disabled","disabled")
    $("input.other_rental_addition_cost_name").attr("disabled","disabled")

    $(".removeUserBillingCost").addClass('hide')
  }
}

function calculate_additional_fee(element_id1, element_id2, element_id3){
  var fee = $(element_id1).val()
  var additional_note = $(element_id2).val()
  if ( fee != "" && fee!= undefined){
    if (additional_note != "") {
      var total_fee =  convert_to_string(parseFloat(fee.replace(/,/g, ".")) * parseFloat(additional_note.replace(/,/g, ".")))
      $(element_id3).val(total_fee)
    }
    else if (additional_note == "" || additional_note == undefined) {
      $(element_id2).val(0)
      var total_fee =  convert_to_string(parseFloat(fee.replace(/,/g, ".")) * parseFloat(0))
      $(element_id3).val(total_fee) 
    }
    
  }
}

function convert_to_string(element){
  return element.toFixed(2).toString().replace(".",",")
}

function disable_text_input(className,elementID1,elementID2,elementID3){
  if (className.length > 0){
    if(className == "is_hygienist_fee" || className == "is_xray_fee" || className == "is_own_laboratory_fee")
    {
      $("#" + elementID1).change(function () {
        if ($("#" + elementID1).find('input:checkbox:first').is(':checked')){
          $("#" + elementID2).removeAttr('disabled');
          $("#" + elementID3).removeAttr('disabled');
          if (className == "is_hygienist_fee"){
            if ($("#hygienist_additional_note").val() == "" || $("#hygienist_additional_note").val() == undefined){
              $("#hygienist_additional_note").val(0)
            }  
          }
          else if (className == "is_xray_fee") {
            if ($("#xray_additional_note").val() == "" || $("#xray_additional_note").val() == undefined){
              $("#xray_additional_note").val(0)
            } 
          }
          else{
            if ($("#own_laboratory_additional_note").val() == "" || $("#own_laboratory_additional_note").val() == undefined){
              $("#own_laboratory_additional_note").val(0)
            }
          }
        }
        else{
          $("#" + elementID2).attr({'disabled': 'disabled'});
          $("#" + elementID3).attr({'disabled': 'disabled'});
        }
      });
    }
  }
}

function calculate_dentist_share_of_billing(elementID1,elementID2,elementID3){
  var rent_basis_billing = $(elementID1).val().replace(/,/g, ".")
  var dentist_reward_base = $(elementID2).val().replace(/,/g, ".")
  console.log(dentist_reward_base)
  if (dentist_reward_base != ""){
    var calculate_share = rent_basis_billing * (1 - parseFloat(dentist_reward_base)/100)
    $(elementID3).val(convert_to_string(Math.round(calculate_share.toFixed(2))))
  }
  else{
    var calculate_share = rent_basis_billing * (1)
    $(elementID3).val(convert_to_string(Math.round(calculate_share.toFixed(2))))
  }
}