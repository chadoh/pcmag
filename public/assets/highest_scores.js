function clearIrrelevantInput(a){a.attr("id")=="highest"?$("form#highest input#above").val(""):$("form#highest input#highest").val("")}$(function(){$("li.submission header h2").live("click",function(a){a.preventDefault(),$(this).parents("li.submission").toggleClass("collapsed")}),$("form#highest input[type=number]").blur(function(){clearIrrelevantInput($(this))}),$("form#highest input[type=submit]").submit(function(){clearIrrelevantInput($(this))})})