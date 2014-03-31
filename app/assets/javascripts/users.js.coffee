# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/$(document).ready ->
$(document).ready ->
  $(".notice-mail").bind "change", ->
    $.ajax(
      url: "/users/" + @value + "/notice"
      type: "POST"
      data:
        not_notice: @checked
    ).always (response) ->
      response.responseText
      return

    return

  return