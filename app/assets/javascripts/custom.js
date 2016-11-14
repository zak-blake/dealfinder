function fadeAlert(){
  $(document).ready(function(){
    setTimeout(function(){
    $('.alert').fadeOut();
    }, 2000);
  })
}

function hideGroupShow(hideClass, showClass){
  console.log(showClass);
  $("." + hideClass).hide();
  $("." + showClass).show();
}
