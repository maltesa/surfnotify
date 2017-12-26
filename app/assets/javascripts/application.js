//= require rails-ujs
//= require turbolinks
//= require jquery3
//= require jquery_ujs
//= require popper
//= require bootstrap-sprockets
//= require selectize
//= require_tree .

document.addEventListener('turbolinks:load', function() {
  $('select').selectize({
    plugins: ['remove_button']
  });
});