function update_select(url, select) {
  $.getJSON(url, function(json){
    $(select).empty();
    $(select).append($('<option>').text("Select..."));
    $.each(json, function(i, obj){
      $(select).append($('<option>').text(obj.name).attr('value', obj.id));
    });
    $(select).trigger("chosen:updated");
  });
};

// function update_select_with_optgroups(url, select) {
//   var $select = $("<select>");
//   $select.appendTo("#somewhere");
//
//   $.each(json, function(i, optgroups) {
//       $.each(optgroups, function(groupName, options) {
//           var $optgroup = $("<optgroup>", {label: groupName});
//           $optgroup.appendTo($select);
//
//           $.each(options, function(j, option) {
//               var $option = $("<option>", {text: option.name, value: option.id});
//               $option.appendTo($optgroup);
//           });
//       });
//   });
// };

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
    var brandId = $(this).val();
    if (brandId > 0 ) {
      var url = "/brands/"+brandId+"/models";
      update_select(url, "#"+ form +"_model");
    };
  });

  $("#"+ form +"_model").on("change", function() {
    empty_and_reset_select("#"+ form +"_submodel", "Submodel...")
    empty_and_reset_select("#"+ form +"_year", "Year...")
    var modelId = $(this).val();
    if (modelId > 0 ) {
      var url = "/vehicle_models/"+modelId+"/submodels";
      update_select(url, "#"+ form +"_submodel");
    };
  });

  $("#"+ form +"_submodel").on("change", function() {
    empty_and_reset_select("#"+ form +"_year", "Year...")
    var submodelId = $(this).val();
    if (submodelId > 0 ) {
      var url = "/vehicle_submodels/"+submodelId+"/vehicles";
      update_select(url, "#"+ form +"_year");
    };
  });
};

// function dynamic_product_type_form(form) {
//   $("#"+ form +"_parent").on("change", function() {
//     empty_and_reset_select("#"+ form +"_subcategories", "Subcategory...")
//     empty_and_reset_select("#compatibility_check_product_type_id", "Part...")
//     var categoryId = $(this).val();
//     if (categoryId > 0 ) {
//       var url = "/categories/"+categoryId+"/subcategories";
//       update_select(url, "#"+ form +"_subcategories");
//     };
//   });
//   $("#"+ form +"_subcategories").on("change", function() {
//     var subcategoryId = $(this).val();
//     if (subcategoryId > 0 ) {
//       var url = "/categories/"+subcategoryId+"/product_types";
//       update_select(url, "#compatibility_check_product_type_id");
//     };
//   });
// };

function dynamic_category_form(form) {
  $("#"+ form +"_category_parent").on("change", function() {
    empty_and_reset_select("#"+ form +"_category_subcategories", "Subcategory...")
    var categoryId = $(this).val();
    if (categoryId > 0 ) {
      var url = "/categories/"+categoryId+"/subcategories";
      update_select(url, "#"+ form + "_category_subcategories");
    };
  });
  $("#"+ form +"_category_subcategories").on("change", function() {
    var subcategoryId = $(this).val();
    if (subcategoryId > 0 ) {
      var url = "/categories/"+subcategoryId+"/product_types";
      update_select(url, "#" + form + "_product_type_id");
    };
  });
};

function dynamic_part_attributes_form(form) {
  $("#"+ form +"_product_type_id").on("change", function() {
    empty_and_reset_select("#"+ form +"_part_attributes", "Specify...")
    var productTypeId = $(this).val();
    if (productTypeId > 0 ) {
      var url = "/product_types/"+productTypeId+"/part_attributes";
      update_select(url, "#" + form + "_part_attributes");
    };
  });
};
