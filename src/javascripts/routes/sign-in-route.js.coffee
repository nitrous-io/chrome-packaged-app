AIO.SignInRoute = Em.Route.extend
  model: ->
    AIO.AccessToken.create clientId: AIO.get('clientId'), clientSecret: AIO.get('clientSecret')

  events:
    signedIn: ->
      @transitionTo 'index'
