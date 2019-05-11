"use strict";

var lotto_nums = {};

$(document).ready(function() {

    var $base_warning = $("#base_warning");
    var $populate_warning = $("#populate_warning");
    var $submit_field_warning = $("#submit_field_warning");
    var $no_results_warning = $("#no_results_warning");

    var $results_table = $("#results_table");
    var $totals_table = $("#totals_table");

    $base_warning.hide();
    $populate_warning.hide();
    $submit_field_warning.hide();
    $no_results_warning.hide();

    $results_table.hide();
    $totals_table.hide();

    $(".number_field").on("change", function(){
        $populate_warning.hide();

        var number = $(this).val();

        if (validate_number($(this).attr("id"), number)){
            $(this).removeClass("invalid").addClass("valid");
            $base_warning.hide();
        }
        else {
            $(this).removeClass("valid").addClass("invalid");
            $base_warning.show();
        }
    });

    $("#submit_button").click(function(event){

        $base_warning.hide();
        $populate_warning.hide();
        $submit_field_warning.hide();
        $no_results_warning.hide();

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

        $results_table.find("tr:gt(0)").remove();

        $.ajax({
            async: true,
            type: 'GET',
            url: '/fetch_data/' + JSON.stringify(Object.values(lotto_nums)),
            success: function(data){
                var json = $.parseJSON(data);

                var winning_draws = json["winning_draws"];
                var total_spent_on_tickets = json["total_spent_on_tickets"];
                var total_number_payout = json["total_number_payout"];
                var net_win_loss = json["net_win_loss"];

                jQuery.each(winning_draws, function(index, draw){
                    $("#results_table tr:last").after(
                        "<tr>" +
                        "<td>" + draw["DRAW DATE"] + "</td>" +
                        "<td>" + draw["WIN_AMOUNT"] + "</td>" +
                        "<td>" + draw["DRAW NUMBER"] + "</td>" +
                        "<td>" + draw["NUMBER_MATCHES"] + "</td>" +
                        "<td>" + draw["BONUS_MATCH"] + "</td>" +
                        "</tr>"
                    );
                });

                if (winning_draws.length > 0){
                    $results_table.show();
                }
                else {
                    $no_results_warning.show();
                }

                $("#total_won").text(total_number_payout);
                $("#total_spent_on_tickets").text(total_spent_on_tickets);
                $("#net_win_loss").text(net_win_loss);

                $totals_table.show();

            }
        });
    });
});

function validate_number(id, num){
    var within_range = (num <= 49 && num >= 1);

    var duplicate = false;

    lotto_nums[id] = null;

    $.each(lotto_nums, function(k, v){
        if (v === num){
            duplicate = true;
        }
    });

    if (within_range && ! duplicate){
        lotto_nums[id] = num;
        return true;
    }

    return false;
}
