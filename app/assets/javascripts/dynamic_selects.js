function update_next_select(url, select) {
  $.getJSON(url, function(json){
    $(select).empty();
    $(select).append($('<option>').text("Select..."));
    $.each(json, function(i, obj){
      $(select).append($('<option>').text(obj.name).attr('value', obj.id));
    });
    $(select).trigger("chosen:updated");
  });
};

function empty_and_reset_select(select, text) {
  $(select).empty();
  $(select).append($("<option></option>").text(text));
  $(select).trigger("chosen:updated");
};


function dynamic_vehicle_form(form) {
  $("#"+ form +"_brand").on("change", function() {
    empty_and_reset_select("#"+ form +"_model", "Model...")
    empty_and_reset_select("#"+ form +"_submodel", "Submodel...")
    empty_and_reset_select("#"+ form +"_year", "Year...")
    update_link();
    var brandId = $(this).val();
    if (brandId > 0 ) {
      var url = "/brands/"+brandId+"/models";
      update_next_select(url, "#"+ form +"_model");
    };
  });

  $("#"+ form +"_model").on("change", function() {
    empty_and_reset_select("#"+ form +"_submodel", "Submodel...")
    empty_and_reset_select("#"+ form +"_year", "Year...")
    update_link();
    var modelId = $(this).val();
    if (modelId > 0 ) {
      var url = "/vehicle_models/"+modelId+"/submodels";
      update_next_select(url, "#"+ form +"_submodel");
    };
  });

  $("#"+ form +"_submodel").on("change", function() {
    empty_and_reset_select("#"+ form +"_year", "Year...")
    update_link();
    var submodelId = $(this).val();
    if (submodelId > 0 ) {
      var url = "/vehicle_submodels/"+submodelId+"/vehicles";
      update_next_select(url, "#"+ form +"_year");
    };
  });
};
