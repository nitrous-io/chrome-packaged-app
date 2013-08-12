AIO.IndexRoute = Ember.Route.extend
  activate: ->
    AIO.Session.getToken (error) =>
      if error
        this.transitionTo 'sign-in'
      else
        this.transitionTo 'main'
