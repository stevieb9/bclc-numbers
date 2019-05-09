"use strict";

var lotto_nums = [];

$(document).ready(function() {

    $(".warning").hide();

    $(".number_field").on("change", function(){
        var number = $(this).val();

        if (validate_number(number)){
            $(this).removeClass("invalid").addClass("valid");
            $("#warning").hide();
        }
        else {
            $(this).removeClass("valid").addClass("invalid");
            $("#warning").show();
        }
    });

    $("#submit_button").click(function(event){
        var field_name_portion = "num";

        for (var i=1; i<7; i++){
            var field_id = "#" + field_name_portion + i;
            if ($.trim($(field_id).val()) === ""){
                $("#populate_warning").show();
                return false;
            }
            else {
                $("#populate_warning").hide();
            }
            if ($(field_id).hasClass("invalid")){
                $("#submit_field_warning").show();
            }
            else {
                $("#submit_field_warning").hide();
            }
        }
    });
});

function validate_number(num){
    var within_range = (num <= 49 && num >= 1);
    var duplicate = lotto_nums.includes(num);

    if (within_range && ! duplicate){
        lotto_nums.push(num);
        return true;
    }

    return false;
}
