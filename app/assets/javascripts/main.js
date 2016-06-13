// main.js

$(function() {
  if ($("#stocklist").length > 0) {
//  setTimeout(updateStockValues, 5000);  // test, not for real use
    setTimeout(updateStockView, 50);
  }
});

function updateStockValues() {  // test function to update stocks
  $.getJSON("/stockservice");
//  $.getJSON("/stockservice", function(data) {
//  });
  setTimeout(updateStockValues, 20000);
}

function updateStockView() {
  $.getJSON("/stocks", function(data) {
    $.each(data, function(i, obj) {
      var tr;

      tr = $("#stocklist td.companysymbol:contains('" + obj.companysymbol + "')").parent();

//    console.log(obj);
//    console.log([obj.companysymbol, obj.value, obj.delta]);

      tr.children(".value").text(obj.value); // works, independent of order
      if (new Number(obj.delta) < 0) {
//      console.log("delta is negative");
        tr.children(".delta").text(obj.delta).css("color","red");
      } else {
//      console.log("delta is positive");
        tr.children(".delta").text(obj.delta).css("color","green");
      }

    });
  });
  setTimeout(updateStockView, 10000);
}

