function submitScoreWithDelay(a){var b=$(a).closest("span"),c=b.attr("data-attendee")+b.attr("data-packlet");score_timers[c]||(score_timers[c]=setTimeout(function(){a.submit()},500))}var score_timers=[];$(function(){$("li:regex(class,(submission|packlet)) header h2").live("click",function(a){a.preventDefault(),$(this).parents("li:regex(class,(submission|packlet))").toggleClass("collapsed")}),$("#attendee_person").live("focus blur",function(a){a.type=="focusin"?$(this).autocomplete("/people/auto_complete_for_person_first_name_middle_name_last_name_email"):$(this).val()==""?$("span.name").html($(this).val().split(" ")[0].replace(/"/g,"")):$("span.name").html($(this).val().split(" ")[0].replace(/"/g,"")+"'s")}),$("ol.packlets").sortable({axis:"y",items:"li",handle:"span.drag-handle-wrap",update:function(a,b){li=b.item,packlet_id=li.attr("id").split("_")[1],$.ajax({type:"PUT",dataType:"script",url:"/packlets/"+packlet_id+"/update_position",data:{position:li.prevAll().length}})}}),$("div.scores-wrap").css({width:$("div.scores").length*55}),$("form.score input[type=submit]").hide(),$("input[type=number]").live("mouseout blur",function(){var a=$(this).attr("data-original"),b=$(this).val();a!=b&&submitScoreWithDelay($(this))}),$("form#new_attendee[data-remote]").live("ajax:before",function(){attendee_email=$(this).find("input#attendee_person").val().split(" ").pop(),$(this).attr("data-viewer")==attendee_email&&$(this).submit(),$(this).append("<img src='/assets/indicator.gif' class='indicator' alt='loading'/>")}).live("ajax:complete",function(){$(this).find("img.indicator").remove()})})