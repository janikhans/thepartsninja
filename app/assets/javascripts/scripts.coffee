
#Sticky nav woohoo!
(($) ->
  $(window).load ->
    $('#navigation').sticky topSpacing: 0
    return
  #jQuery to collapse the navbar on scroll
  $(window).scroll ->
    if $('.navbar').offset().top > 50
      $('.navbar-fixed-top').addClass 'top-nav-collapse'
    else
      $('.navbar-fixed-top').removeClass 'top-nav-collapse'
    return
  return
) jQuery

#Make the dropdown automatically drop - looks snazzy!
$(document).ready ->
  $('.dropdown').hover (->
    $('.dropdown-menu', this).not('.in .dropdown-menu').stop(true, true).slideDown 'medium'
    $(this).toggleClass 'open'
    return
  ), ->
    $('.dropdown-menu', this).not('.in .dropdown-menu').stop(true, true).slideUp 'fast'
    $(this).toggleClass 'open'
    return
  return