NIO.IndexRoute = Ember.Route.extend
  activate: ->
    if NIO.TokenFetcher.hasToken()
      this.transitionTo 'main'
