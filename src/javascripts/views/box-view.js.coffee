AIO.BoxView = Ember.View.extend
  templateName: 'box'
  classNames: ['aio-box-view accordion-group']

  collapseBox: ->
    @$('.accordion-body').collapse('toggle')
