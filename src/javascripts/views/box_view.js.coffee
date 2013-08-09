AIO.BoxView = Ember.View.extend
  templateName: 'views/box'

  collapseBox: ->
    @$('.collapse').collapse('toggle')
