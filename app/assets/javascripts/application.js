//= require jquery
//= require jquery_ujs

//= require cookie
//= require json2

//= require underscore
//= require backbone

//= require wmsb

$(function() {
  $('.icon-cancel-circle').on('click', function() {
    $(this).parents('.notifications').hide();
  });
});
