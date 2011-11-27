$(function(){
  $('a.toggle-adding-role').live('click', function(e){
    e.preventDefault();
    $(this).closest('footer').toggleClass('add-role');
  });
  $('form.role input.string').live('focusin', function(){
    $(this).autocomplete("/people/auto_complete_for_person_first_name_middle_name_last_name_email");
  }).live('keyup', function(e){
    if (e.keyCode == 27) { $(this).closest('form').find('a.toggle-adding-role').click(); }
  }).blur().focus();
});