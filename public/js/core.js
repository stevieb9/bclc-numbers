"use strict";

var lotto_nums = [];

$(document).ready(function() {

    $("#warning").hide();

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

    console.log(lotto_nums);
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
