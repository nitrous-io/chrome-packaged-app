NIO.BoxListController = Ember.ArrayController.extend
  newBox: ->
    NIO.Utils.openInWebView "app#boxes/new", 1200, 750

  refreshBoxes: ->
    NIO.Box.fetch(true)
    .done ->
      # TODO: Show a flash message to user.
      console.log 'boxes updated'


