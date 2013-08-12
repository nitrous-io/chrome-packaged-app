AIO.BoxView = Ember.View.extend
  templateName: 'box'

  collapseBox: ->
    @$('.accordion-body').collapse('toggle')
