$(document).ready(function() {
  $("#brand a.add_fields").
    data("association-insertion-position", 'before').
    data("association-insertion-node", 'this');

  $('#brand').bind('cocoon:after-insert',
     function() {
       $("#brand_from_list").hide();
       $("#brand a.add_fields").hide();
     });
  $('#brand').bind("cocoon:after-remove",
     function() {
       $("#brand_from_list").show();
       $("#brand a.add_fields").show();
     });
});
