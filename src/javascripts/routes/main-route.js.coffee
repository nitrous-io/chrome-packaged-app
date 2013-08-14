AIO.MainRoute = Em.Route.extend
  beforeModel: ->
    if !AIO.get('accessToken')
      @transitionTo 'sign-in'

  setupController: (controller) ->
    @_super.apply this, arguments

    controller.set 'pusher', AIO.Pusher.sharedInstance pusherKey: AIO.get('pusherKey'), pusherEndpoint: AIO.get('pusherEndpoint')

    AIO.set 'currentUser', AIO.CurrentUser.loadFromStorage ->
      AIO.CurrentUser.reload()

  model: ->
    AIO.Box.loadFromStorage ->
      AIO.Box.find().reload()

  events:
    signedOut: ->
      @transitionTo 'sign-in'
