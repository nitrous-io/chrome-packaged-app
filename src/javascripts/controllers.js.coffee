NIO.ApplicationController = Ember.Controller.extend {}

NIO.IndexController = Ember.Controller.extend
  connecting: null

  connect: ->
    @set 'connecting', true

    NIO.TokenFetcher.getToken true, (error, access_token) =>
      @set 'connecting', false

      if error
        # TODO: show a flash message
        console.log('Login Failed')
      else
        this.transitionToRoute 'main'

NIO.BoxListController = Ember.ArrayController.extend {
  newBox: ->
    NIO.Utils.openInWebView "app#boxes/new", 1200, 750

  refreshBoxes: ->
    NIO.Box.fetch(true)
    .done ->
      # TODO: Show a flash message to user.
      console.log 'boxes updated'
}

NIO.BoxDetailsController = Ember.ObjectController.extend {
  openIde: ->
    boxId = @get 'content.id'
    NIO.Utils.openInWebView "app#boxes/#{boxId}/ide", 1200, 750

  openSettings: ->
    boxId = @get 'content.id'
    NIO.Utils.openInWebView "app#boxes/#{boxId}/edit", 1200, 750
}

NIO.UserController = Ember.ObjectController.extend {
  logout: ->
    user = @get 'content' 
    user.logout()
    this.transitionToRoute 'index'
}
