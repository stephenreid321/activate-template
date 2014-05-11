$(function() {

  $(document).on('click', 'a[data-confirm]', function(e) {
    var message = $(this).data('confirm');
    if (!confirm(message)) {
      e.preventDefault();
      e.stopped = true;
    }
  });

  $(document).on('click', 'a.popup', function(e) {
    window.open(this.href, null, 'width=600,height=300,left=150,top=150').focus();
    return false;
  });
  
  // $("body").fitVids();

});