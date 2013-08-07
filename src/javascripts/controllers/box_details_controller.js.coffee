AIO.BoxDetailsController = Ember.ObjectController.extend
  openIde: ->
    boxId = @get 'content.id'
    AIO.Utils.openInWebView "app#boxes/#{boxId}/ide", 1200, 750

  openSettings: ->
    boxId = @get 'content.id'
    AIO.Utils.openInWebView "app#boxes/#{boxId}/edit", 1200, 750

  doAction: (action) ->
    box = @get 'content'
    box.doAction action
