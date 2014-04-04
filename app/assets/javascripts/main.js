// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

var Shortener = function(form_elem, sc){

  var _this = {};

  var $form = null;
  var $sc = null;

  function _init(form, sc)
  {
    $form = $(form);
    $sc = $(sc);

    _attach_events();
  }

  function _attach_events()
  {
    $form.on({
      submit: _submit_form
    });
  }

  function _submit_form(e){
    e.preventDefault();

    console.log(_this);
  }


  _init(form_elem, sc);

  return _this;
};