$(document).ready(function(){
  
  if($(".add_clinic_introduction_text").length > 0){
    $(".add_clinic_introduction_text").click(function() {
      $("#clinic_introduction_text_area").removeClass('hide');
      $(".add_clinic_introduction_text").remove();
    });
  }

  if($("#clinic_introduction").val() != ""){
    $("#clinic_introduction_text_area").removeClass('hide');
  }

  $(document).on("click", ".responsible_person", function(){
    var id = getId(this.id);
    // set_responsible_person(id)
    //if checked
    if ($("#responsible_person_check_" + id).is(":checked")) {
      //add to the actual param
      addIdToArray("selected_responsible_person", id);
      // update to unselect text
      set_unselect_text("#responsible_select_text_" + id, "#responsible_unselect_text_" + id);
    }
    else {
      // remove from actual param
      removeIdFromArray("selected_responsible_person", id);
      // update to select text
      set_select_text("#responsible_select_text_" + id, "#responsible_unselect_text_" + id);
    }
  });

  $("#addResponsibleBtn").click(function(){
    $('#responsiblePersons').modal('toggle');
  });

	$("#add_visiting_address").click(function(){
	  $("#visiting_address_wrapper").removeClass("hide");
	  $("#add_visiting_address_wrapper").remove();
	});
	
	$("#add_billing_address").click(function(){
	  $("#billing_address_wrapper").removeClass("hide");
	  $("#add_billing_address_wrapper").remove();
	});

  if ($("#new_opening_hours").length > 0) {
    $("#monday_start_hour").focusout(function(){
      monday_start_hour = $(this).val();
      start_hours = $(".start_hour");
      for(i = 0; i < start_hours.length; i++) {
        $(start_hours[i]).val(monday_start_hour)
      }
    });

    $("#monday_start_minute").focusout(function(){
      monday_start_minute = $(this).val();
      start_minutes = $(".start_minute");
      for(i = 0; i < start_minutes.length; i++) {
        $(start_minutes[i]).val(monday_start_minute)
      }
    });

    $("#monday_end_hour").focusout(function(){
      monday_end_hour = $(this).val();
      end_hours = $(".end_hour");
      for(i = 0; i < end_hours.length; i++) {
        $(end_hours[i]).val(monday_end_hour)
      }
    });

    $("#monday_end_minute").focusout(function(){
      monday_end_minute = $(this).val();
      end_minutes = $(".end_minute");
      for(i = 0; i < end_minutes.length; i++) {
        $(end_minutes[i]).val(monday_end_minute)
      }
    });
  }

	$("#openingHoursBtn").click(function(){
    $("#opening-hours-loader").show();
  });
});

function set_filtered_responsible_person() {

  var idArr = $("#selected_responsible_person").val().split(",");
  for(var i=0; i<idArr.length; i++){
    var id = idArr[i];
    if ($("#responsible_person_check_" + id).length > 0) {
      $("#responsible_person_check_" + id).prop('checked', true);
      set_unselect_text("#responsible_select_text_" + id, "#responsible_unselect_text_" + id);
    }
  }
}

function set_responsible_person(id) {
  $(".responsible_unselect_text").addClass('hide');
  $(".responsible_select_text").removeClass('hide');  
  var $box = $("#responsible_person_check_" + id);
  set_select_text("#responsible_select_text_" + id, "#responsible_unselect_text_" + id);
  if ($box.is(":checked")) {
    $("#selected_responsible_person").val(id);
    var group = "input:checkbox[name='" + $box.attr("name") + "']";
    $(group).prop("checked", false);
    $box.prop("checked", true);
    set_unselect_text("#responsible_select_text_" + id, "#responsible_unselect_text_" + id);
  }
}