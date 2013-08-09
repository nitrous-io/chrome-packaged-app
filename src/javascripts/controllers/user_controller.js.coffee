AIO.UserController = Ember.ObjectController.extend
  logout: ->
    user = @get 'content'￿
    user.logout()
    this.transitionToRoute 'index'
