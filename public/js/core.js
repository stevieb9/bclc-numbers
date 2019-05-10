"use strict";

var lotto_nums = [];

$(document).ready(function() {

    var $warning = $("#warning");
    var $populate_warning = $("#populate_warning");
    var $submit_field_warning = $("#submit_field_warning");

    var $results_table = $("#results_table");

    $warning.hide();
    $populate_warning.hide();
    $submit_field_warning.hide();

    $results_table.hide();

    $(".number_field").on("change", function(){
        $populate_warning.hide();

        var number = $(this).val();

        if (validate_number(number)){
            $(this).removeClass("invalid").addClass("valid");
            $warning.hide();
        }
        else {
            $(this).removeClass("valid").addClass("invalid");
            $warning.show();
        }
    });

    $("#submit_button").click(function(event){

        $populate_warning.hide();
        $submit_field_warning.hide();
        $warning.hide();

        var field_name_portion = "num";

        for (var i=1; i<7; i++){
            var field_id = "#" + field_name_portion + i;
            if ($.trim($(field_id).val()) === ""){
                $populate_warning.show();
                return false;
            }
            if ($(field_id).hasClass("invalid")){
                $submit_field_warning.show();
                return false;
            }
        }

        $.ajax({
            async: false,
            type: 'GET',
            url: '/fetch_data/' + JSON.stringify(lotto_nums),
            success: function(data){
                var json = $.parseJSON(data);
                //console.log(data);

                jQuery.each(json, function(index, info){
                    $("#results_table tr:last").after(
                        "<tr>" +
                        "<td>" + info["DRAW DATE"] + "</td>" +
                        "<td>" + info["WIN_AMOUNT"] + "</td>" +
                        "<td>" + info["DRAW NUMBER"] + "</td>" +
                        "<td>" + info["NUMBER_MATCHES"] + "</td>" +
                        "<td>" + info["BONUS_MATCH"] + "</td>" +
                        "</tr>"
                    );
                });


                $results_table.show();
            }
        });
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