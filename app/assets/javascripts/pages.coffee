# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

###global jQuery:false ###

(($) ->
  $(window).load ->
    $('#navigation').sticky topSpacing: 0
    return
  $('ul.nav li.dropdown').hover (->
    $(this).find('.dropdown-menu').stop(true, true).delay(200).fadeIn 500
    return
  ), ->
    $(this).find('.dropdown-menu').stop(true, true).delay(200).fadeOut 500
    return
  #jQuery to collapse the navbar on scroll
  $(window).scroll ->
    if $('.navbar').offset().top > 50
      $('.navbar-fixed-top').addClass 'top-nav-collapse'
    else
      $('.navbar-fixed-top').removeClass 'top-nav-collapse'
    return
  #jQuery for page scrolling feature - requires jQuery Easing plugin
  $ ->
    $('.navbar-nav li a').bind 'click', (event) ->
      $anchor = $(this)
      nav = $($anchor.attr('href'))
      if nav.length
        $('html, body').stop().animate { scrollTop: $($anchor.attr('href')).offset().top }, 1500, 'easeInOutExpo'
        event.preventDefault()
      return
    $('a.totop,a#btn-scroll,a.btn-scroll,.carousel-inner .item a.btn').bind 'click', (event) ->
      $anchor = $(this)
      $('html, body').stop().animate { scrollTop: $($anchor.attr('href')).offset().top }, 1500, 'easeInOutExpo'
      event.preventDefault()
      return
    return
  #nivo lightbox
  $('.gallery-item a').nivoLightbox
    effect: 'fadeScale'
    theme: 'default'
    keyboardNav: true
    clickOverlayToClose: true
    onInit: ->
    beforeShowLightbox: ->
    afterShowLightbox: (lightbox) ->
    beforeHideLightbox: ->
    afterHideLightbox: ->
    onPrev: (element) ->
    onNext: (element) ->
    errorMessage: 'The requested content cannot be loaded. Please try again later.'
  jQuery('.appear').appear()
  jQuery('.appear').on 'appear', (data) ->
    id = $(this).attr('id')
    jQuery('.nav li').removeClass 'active'
    jQuery('.nav a[href=\'#' + id + '\']').parent().addClass 'active'
    return
  return
) jQuery

$(document).ready ->
  $('.dropdown').hover (->
    $('.dropdown-menu', this).not('.in .dropdown-menu').stop(true, true).slideDown 'fast'
    $(this).toggleClass 'open'
    return
  ), ->
    $('.dropdown-menu', this).not('.in .dropdown-menu').stop(true, true).slideUp 'fast'
    $(this).toggleClass 'open'
    return
  return