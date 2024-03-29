# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $('form').on 'click', '.remove_fields', (event) ->
    $(this).prev('input[type=hidden]').val('1')
    $(this).closest('fieldset').hide()
    event.preventDefault()

  $('form').on 'click', '.add_fields', (event) ->
    time = new Date().getTime()
    regexp = new RegExp($(this).data('id'), 'g')
    $(this).before($(this).data('fields').replace(regexp, time))
    event.preventDefault()

  SyntaxHighlighter.highlight()

  $(".submitter-anchor").click (e) ->
    e.preventDefault()
    $(this).parents('form').find(".submitter").click()

  $("label.radio").prepend("<span></span>")
  $("label.radio").each (i, label) ->
    input = $(label).find("input")
    input.insertBefore(label)
    $(label).attr("for", input.attr("id"))

  $("label.checkbox").prepend("<span></span>")
  $("label.checkbox").each (i, label) ->
    input = $(label).find("input")
    input.insertBefore(label)
    $(label).attr("for", input.attr("id"))

  $(".nav-tabs").tab()
