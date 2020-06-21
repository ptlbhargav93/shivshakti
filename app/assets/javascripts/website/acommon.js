$(document).ready(function(){

  common_events();

  $(document).on("change", ".UploadedMedia", function(){
    var id = getId(this.id);
    var reader = new FileReader();
    var ele = $(this).parent().parent().find('.preview_attachments').find('li');
    ele.html("<a href='#'>"+this.files.item(0).name+"</a>");
  });

  $(document).on("click", ".removeUploadedPhoto", function(){
    $('.preview_file_box').html('')
    $(".fileUploadMedia").val('')
  });

  $(document).on("change", ".media-file-upload", function(){
    var id = getId(this.id);
    var reader = new FileReader();
    var parentEl = $(this).closest('.file_attachments');
    var ele = $(parentEl).find('.preview_attachments');

    if ($(parentEl).find(".saved_media_file").length > 0){
      $(parentEl).find(".destroy-media-file").val("0");
    }
    removePreviewFileEle = "<a class='remove-file remove-media-file dib' href='javascript:void(0);'><div class='remove-preview-file remove'><i class='fa fa-times'></i></div></a>";

    preview_file_ele = "<li class='form-group'><a href='javascript:void(0);'>" + this.files.item(0).name + "</a> " + removePreviewFileEle + "</li>";
    $(ele).find("li").addClass("hide");
    $(ele).append(preview_file_ele);
  });

  $(document).on('click', '.hideShowModal', function(){
    $('.modal').modal('hide');
    var show_modal_id = $(this).data('show_modal_id');
    if ($('#' + show_modal_id).length > 0){
      setTimeout(function () {
        $("#" + show_modal_id).modal('show');
      }, 1000);
    }
  });

  $(document).on("click", ".remove-media-file", function(){
    var parentEl = $(this).closest('.file_attachments');
    $(parentEl).find(".media-file-upload").val('');
    if ($(parentEl).find(".saved_media_file").length > 0){
      $(parentEl).find(".destroy-media-file").val("1");
    }
    $(parentEl).find("li").addClass("hide");
  });

  $(document).on("click", ".remove-saved-media-file", function(){
    var parentEl = $(this).closest('.file_attachments');
    var ele = $(parentEl).find('.destroy-media-file');
    var premission = confirm(I18n.t("js.general.task.are_you_sure"));
    if (premission == true) {
      $(ele).val("1");
      $(parentEl).find("li").addClass("hide");
    }
  });
  
  // scroll listing
  $('.scroll').jscroll({
    loadingHtml: '<img src="/loading.gif" alt="Loading" />',
    autoTrigger: true,
    padding: 20,
    nextSelector: 'a.jscroll-next:last',
    callback: common_events
  });

  $('.scroll-person').jscroll({
    loadingHtml: '<img src="/loading.gif" alt="Loading" />',
    autoTrigger: true,
    padding: 20,
    nextSelector: 'a.jscroll-next-person:last',
    callback: common_events
  });

  $("#OrderEmailModal, #LoginInfoEmailModal, #SendInvoiceEmailModal").on('shown.bs.modal', function() {
    $('.ckeditorCustom').ckeditor({
    });
  });

  // open order email modal
  $(document).on('input propertychange paste click', '#user_email',  function() {
    userEmail = $(this).val();
    if (validateEmail(userEmail)) {
      $("#OrderEmailbtn").attr('disabled', false);
    }else{
      $("#OrderEmailbtn").attr('disabled', true);
    }
  })
  if ($("#user_email").val() != ""){
    $("#OrderEmailbtn").attr('disabled', false);
  }
  $(document).on('click', '#OrderEmailbtn',  function() {
    userVal = $('#user_email').val();
    msgText = $("#old_message").val();
    msgText = msgText.replace("userEmail", userVal);
    msgText = msgText.replace(/^\s+|\s+$/gm,'');
    $("#message").html(msgText);
  })

  // order email recipient box add remove
  $(function(){
    var dbmrecipient = $('#input_dbm_recipient');
    var count = $('#input_dbm_recipient p').size();
    $(document).on("click", "#add_recipient_for_dbm_email",  function() {
      $('<p><input type="email" id="recipient_email" name="recipient_email['+ count +']" class="form-control"/><a href="#" id="removedbminput">Remove</a></p>').appendTo(dbmrecipient);
      count++;
      return false;
    });
    $(document).on("click","#removedbminput", function() {
      if( count > 1 )
        {
          $(this).parents('p').remove();
          count--;
        }
      return false;
    });
  });

  // user contract until show/hide
  if ((".contract_until").length > 0) {
    $('.contract_type_time_limited, .contract_probation_true').click(function(){
      var idArr = this.id.split("_");
      var id = idArr[idArr.length - 1];
      $('#contract_until_' + id).show('slow');
    });

    $('.contract_probation_false').click(function(){
      var idArr = this.id.split("_");
      var id = idArr[idArr.length - 1];
      if(!$('#contract_type_time_limited_' + id).is(":checked")) {
        $('#contract_until_' + id).hide('slow');
      }
    });

    $('.contract_type_indefinitely_valid').click(function(){
      var idArr = this.id.split("_");
      var id = idArr[idArr.length - 1];
      if(!$('#contract_probation_true_' + id).is(":checked")) {
        $('#contract_until_' + id).hide('slow');
      }
    });

    var time_limited_contract_types = $(".contract_type_time_limited");
    for(var i=0; i<time_limited_contract_types.length; i++){
      var idArr = time_limited_contract_types[i].id.split("_");
      var id = idArr[idArr.length - 1];
      if ($("#contract_type_time_limited_" + id).is(":checked")){
        $('#contract_until_' + id).show('slow');
      }
      else{
        if ($("#contract_probation_true_" + id).is(":checked")){
          $('#contract_until_' + id).show('slow');
        }
        else {
          $('#contract_until_' + id).hide('slow');
        }
      }
    }
  }

  //add aditional languages
  if ($("#add_new_language").length > 0){
    var total_added_languages = 0;
    $(document).on("click", "#add_new_language",  function() {
      var count = ++total_added_languages;
      $('#input_add_language').append('<div class="added_language" id="added_language_wrapper_' + count + '"><div class="col-xs-12 col-sm-8 col-md-10 form-group"><input type="text" id="input_add_language_'+count+'" name="languages['+ count +']" class="form-control"/></div><div class="col-xs-12 col-sm-3 col-md-2 form-group text-right pt10"><label class="remove_language"  id="remove_language_' + count + '"><a href="javascript:void(0)" class="addLink remove_fields dynamic"><i class="removeIcon"></i>Remove</a></label></div></div>')
    });
    $(document).on("click",".remove_language", function() {
      var idArr = this.id.split("_");
      var id = idArr[idArr.length - 1];
      $("#added_language_wrapper_"+ id).remove();
    });
  }

  if ($("#sales_area").length > 0){
    var total_added_sales_area = $("#sales_area").find($("input")).length;
    $(document).on("click", "#add_new_sales_area",  function() {
      var count = ++total_added_sales_area;
      $('#input_add_sales_area').append('<div class="added_sales_area" id="added_sales_area_wrapper_' + count + '"><div class="col-xs-11 col-sm-7 form-group"><input type="text" id="input_add_sales_area_'+count+'" name="setting[sales_area[region_'+ count +']" class="form-control"/></div><div class="col-xs-12 col-sm-2 form-group pt10"><label class="remove_sales_area"  id="remove_sales_area_' + count + '"><a href="javascript:void(0)" class="addLink remove_fields dynamic"><i class="removeIcon"></i>Remove</a></label></div></div>')
    });
    $(document).on("click",".remove_sales_area", function() {
      var idArr = this.id.split("_");
      var id = idArr[idArr.length - 1];
      $("#added_sales_area_wrapper_"+ id).remove();
    });
  }

  $('#customer_is_shipping').click(function(){
    if($(this).is(":checked")) {
      $("#customer_s_name").val($("#customer_b_name").val())
      $("#customer_s_address").val($("#customer_b_address").val())
      $("#customer_s_city").val($("#customer_b_city").val())
      $("#customer_s_pin_code").val($("#customer_b_pin_code").val())
      $("#customer_s_state").val($("#customer_b_state").val())
      $("#customer_s_state_code").val($("#customer_b_state_code").val())
      $("#customer_s_country").val($("#customer_b_country").val())
      $("#customer_s_gst_number").val($("#customer_b_gst_number").val())
    }
  });

  $('#clear_shipping').click(function(){
    $('#customer_is_shipping').prop("checked", false);
    $("#customer_s_name").val('')
    $("#customer_s_address").val('')
    $("#customer_s_city").val('')
    $("#customer_s_pin_code").val('')
    $("#customer_s_state").val('')
    $("#customer_s_state_code").val('')
    $("#customer_s_country").val('')
    $("#customer_s_gst_number").val('')
  });

  $('.amountClass, .amountClass1').on( 'change', function(){
    var sum = 0;
    var cgst = 0;
    var sgst = 0;
    $('.amountClass').each(function(){
        sum += +$(this).val();
    });
    console.log(sum)
    if ($("#customer_bill_cgst").val() != ""){
      cgst = parseFloat(sum*$("#customer_bill_cgst").val()/100)
    }
    console.log(cgst)
    if ($("#customer_bill_sgst").val() != ""){
      sgst = parseFloat(sum*$("#customer_bill_sgst").val()/100)
    }
    console.log(sgst)
    sum = (parseFloat(sum)+parseFloat(cgst)+parseFloat(sgst)).toFixed(2)

    $("#customer_bill_total_amount").val(sum)
  });

  $("#add_visiting_address").click(function(){
    $("#visiting_address_wrapper").removeClass("hide");
    $("#add_visiting_address_wrapper").remove();
  });

  $("#add_billing_address").click(function(){
    $("#billing_address_wrapper").removeClass("hide");
    $("#add_billing_address_wrapper").remove();
  });

  // profession show/hide
  $('#user_perform_patient_work_true').click(function(){
    $('#choose_profession').show('slow');
  });

  $('#user_perform_patient_work_false').click(function(){
    $('#choose_profession').hide('slow');
  });

  if($('#user_perform_patient_work_true').is(":checked")) {
    $('#choose_profession').show('slow');
  }
  else
  {
    $('#choose_profession').hide('slow');
  }
});

function checkNumericVal(val){
  val = (isNaN(val)) ? 0 : val;
  return val;
}

function validateEmail(email) {
  var re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
  return re.test(email);
}

function fadeOutFlashMessage(id){
  $("#" + id).delay(3000).fadeOut(500);
}

function getId(id){
  var idArr = id.split("_");
  return idArr[idArr.length - 1];
}

function set_select_text(selectId, unselectId) {
  $(selectId).removeClass('hide');
  $(unselectId).addClass('hide');
}

function set_unselect_text(selectId, unselectId) {
  $(selectId).addClass('hide');
  $(unselectId).removeClass('hide');
}

function addIdToArray(holderId, id) {
  var idArr = $("#" + holderId).val();
  idArr = idArr ? idArr.split(",") : [];
  var index = idArr.indexOf(id);
  if (index < 0) {
    idArr.push(id);
    $("#" + holderId).val(idArr.join(","));
  }
}

function removeIdFromArray(holderId, id) {
  var idArr = $("#" + holderId).val();
  idArr = idArr ? idArr.split(",") : [];
  var index = idArr.indexOf(id);
  if (index > -1) {
    idArr.splice(index, 1);
    $("#" + holderId).val(idArr.join(","));
  }
}

function setFlashMessage(parentId, flashId, msg, fadeOut, animate){
  $("#" + parentId).html(getFlashMessageEle(msg, flashId));
  if (animate != false){
    SetFocusOnTopOfPage()
    //$('html, body').animate({scrollTop:$('#' + parentId).position().top}, 'slow');
  }
  if (fadeOut != false) {
    fadeOutFlashMessage(flashId);
  }
}

function getFlashMessageEle(msg, flashId){
  return "<div id='" + flashId + "' class='alert alert-dismissible alert-success'><button class='close' data-dismiss='alert' type='button'>×</button>" + msg + "</div>"
}

function SetFocusOnTopOfPage(){
  $(".modal").animate({ scrollTop: 0 }, "slow");
}

function common_events(){

  initiateDatePicker();

  $('.fileUploadMedia').on( 'change', function(){
    if (this.files && this.files[0]) {
      var reader = new FileReader();
      reader.onload = function (e) {
        $('.preview_file_box').html('<div class="preview-photos row row10 removeUploadedPhoto"><div class="upload-image-col"><div class="upload-image-box"><a href = "javascript:void(0);" class="remove"><i class="fa fa-times"></i></a><div class="uploadedImg"><img src='+e.target.result+'></div></div></div></div>');
      }
      reader.readAsDataURL(this.files[0]);
    }
  });

  // date picker
  $('#customer_bill_bill_date').datepicker({
    format: 'dd.mm.yyyy',
    weekStart: 1,
    autoclose: true,
    todayHighlight: true,
    clearBtn: true,
    disableTouchKeyboard: true,
    Readonly: true
  });  
  $('.datepickeron').datepicker({
    format: 'dd.mm.yyyy',
    weekStart: 1,
    autoclose: true,
    todayHighlight: true,
    clearBtn: true,
    disableTouchKeyboard: true,
    Readonly: true
  }).attr("readonly", "readonly");

  // virtual keyboard
  $('.container').on('cocoon:after-insert', function(e, insertedItem) {

    $('.amountClass, .amountClass1').on( 'change', function(){
      var sum = 0;
      var cgst = 0;
      var sgst = 0;
      $('.amountClass').each(function(){
          sum += +$(this).val();
      });
      console.log(sum)
      if ($("#customer_bill_cgst").val() != ""){
        cgst = parseFloat(sum*$("#customer_bill_cgst").val()/100)
      }
      console.log(cgst)
      if ($("#customer_bill_sgst").val() != ""){
        sgst = parseFloat(sum*$("#customer_bill_sgst").val()/100)
      }
      console.log(sgst)
      sum = (parseFloat(sum)+parseFloat(cgst)+parseFloat(sgst)).toFixed(2)

      $("#customer_bill_total_amount").val(sum)
    });
    if ($("#pc_browser").val() != 'true') {
      $('.virtualKeyboard').attr('readonly', true);
    }    
    $('.virtualKeyboard').keyboard({
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

    // date picker
    $('.datepickeron').datepicker({
      format: 'dd.mm.yyyy',
      weekStart: 1,
      autoclose: true,
      todayHighlight: true,
      clearBtn: true,
      disableTouchKeyboard: true,
      Readonly: true
    }).attr("readonly", "readonly");
  });

  if ($("#pc_browser").val() != 'true') {
    $('.virtualKeyboard').attr('readonly', true);
  }

  $('.virtualKeyboard').keyboard({
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

  if ($("#pc_browser").val() != 'true') {
    $('.virtualKeyboard, .virtualKeyboardRoom').attr('readonly', true);
  } 

  if ($("#pc_browser").val() == "true"){
    var userPreview = true
  }
  else{
    var userPreview = false
  }

  $("#flash_msg").delay(4000).fadeOut(500);

  $(".filter-btn-cls, #filter-btn, #saveMedia, #saveMediaNext").click(function(){
    $("#loader-image").show();
  });
  
  $(".pre-icon-load").click(function(){
    $(".pre-icon").show();
  });

  $(".pre-load-form").submit(function(){    
    $(".pre-icon").show();
  });

  $('.navbar-toggle').click(function(){
    $(this).toggleClass('active');
    $('.navbar-collapse').toggleClass('active');
    $('.menuOverlay').toggleClass('active');
  });

  $('.menuOverlay').click(function(){
    $('.navbar-toggle').click();
    // $(this).removeClass('active');
    // $('.navbar-collapse').toggleClass('active');
    // $('.navbar-toggle').toggleClass('active');
  });
}

function initiateDatePicker(normal = $('.datepickeron'), year = $('.datepickeron-year')){
  // date picker
  $(normal).datepicker({
    format: 'dd.mm.yyyy',
    weekStart: 1,
    autoclose: true,
    todayHighlight: true,
    clearBtn: true,
    disableTouchKeyboard: true,
    Readonly: true
  }).attr("readonly", "readonly");

  // date picker
  $(year).datepicker({
    minViewMode: 2,
    format: 'yyyy'
  }).attr("readonly", "readonly");
}
