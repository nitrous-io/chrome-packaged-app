AIO.MainRoute = Em.Route.extend
  beforeModel: ->
    if !AIO.get('accessToken')
      @transitionTo 'sign-in'

  setupController: (controller) ->
    @_super.apply this, arguments

    AIO.set 'currentUser', AIO.CurrentUser.loadFromStorage ->
      AIO.CurrentUser.reload()

  model: ->
    AIO.Box.loadFromStorage ->
      AIO.Box.find().reload()

