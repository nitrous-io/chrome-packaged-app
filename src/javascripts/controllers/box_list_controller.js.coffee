NIO.BoxListController = Ember.ArrayController.extend
  newBox: ->
    NIO.Utils.openInWebView "app#boxes/new", 1200, 750
