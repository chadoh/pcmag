(function(){jQuery(function(){return $(document).on("click","a.toggle-adding-role",function(e){return e.preventDefault(),$(this).closest("footer").toggleClass("add-role")}),$(document).on("focusin",'input[name="role[person]"]',function(){return $(this).autocomplete("/people/auto_complete_for_person_first_name_middle_name_last_name_email")}),$(document).on("keyup",'input[name="role[person]"]',function(e){return e.keyCode===27?$(this).closest("form").find("a.toggle-adding-role").click():void 0}),$('input[name="role[person]"]:visible').first().blur().focus()})}).call(this);