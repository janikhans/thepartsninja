# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
  $('#part_brand_name').autocomplete
    source: $('#part_brand_name').data('autocomplete-source')