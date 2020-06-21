$(document).ready(function(){
  var t;

  // common filter event
  $('#filterFormId').on( 'change', function(){
    $('#loader-image').show();
    $('#filterFormId').submit();
  });

  $(document).on('keyup', '#search, #city, #state',  function() {
    clearTimeout(t);    
    t = setTimeout(function () {
      $('#filterFormId').submit();
      $("#loader-image").show();
    }, 500);
  });  
});
