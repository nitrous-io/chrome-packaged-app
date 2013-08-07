AIO.BoxListController = Ember.ArrayController.extend
  newBox: ->
    AIO.Utils.openInWebView "app#boxes/new", 1200, 750
