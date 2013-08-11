AIO.BoxView = Ember.View.extend
  templateName: 'views/box'

  collapseBox: ->
    @$('.accordion-body').collapse('toggle')
