# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

rateAnswer = (rating, token) ->
  $('#token').val(token)
  ratingField = $('#rating')
  ratingField.val(rating)
  ratingField.closest('form').submit()

# This function has to be global because the event handlers have to be reattached
# after a new question and therefore new HTML is returned.
# http://stackoverflow.com/questions/4214731/coffeescript-global-variables
@initClickHandlers = () ->
  $('#show-solution').on 'click', (event) ->
    event.preventDefault()

    $('#solution').toggleClass('hide')

    # A timout has to be used for Firefox 27 not to immediately show the element
    # without fading it in.
    setTimeout ->
      $('#solution').toggleClass('in')
    , 100

  $('.rate-link').on 'click', (event) ->
    event.preventDefault()

    rateAnswer($(this).data('rating'), $(this).data('token'))

$ ->
  initClickHandlers()
