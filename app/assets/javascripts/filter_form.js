$(document).ready(function(){
    $("input[name$='[user_view]'").change(function(){
        var radio = $(this).val();
        if(radio==="dep") {
            $(".dept-list").show("fast");
            $('select option:first-child').attr("selected", "selected");
        } else {
            $(".dept-list").hide("fast");
        };
    });
});

