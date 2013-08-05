NIO.BoxDetailsController = Ember.ObjectController.extend
  openIde: ->
    boxId = @get 'content.id'
    NIO.Utils.openInWebView "app#boxes/#{boxId}/ide", 1200, 750

  openSettings: ->
    boxId = @get 'content.id'
    NIO.Utils.openInWebView "app#boxes/#{boxId}/edit", 1200, 750

  invoke: (action) ->
    box = @get 'content'
    box.invoke action
