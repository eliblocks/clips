function authModal(e) {
  e.preventDefault();
  var origin = e.currentTarget.href
  var href = $("#auth-button").eq(0).attr('href').replace(/\?origin.*/, '');
  var new_href = href + '?origin=' + origin;
  $("#auth-button").eq(0).attr('href', new_href);
  $('#login-modal').modal();
}




