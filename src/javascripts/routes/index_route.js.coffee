NIO.IndexRoute = Ember.Route.extend
  activate: ->
    if appWindow = chrome.app.window.current()
      appWindow.resizeTo 325, 385

    if NIO.TokenFetcher.hasToken()
      this.transitionTo 'main'
