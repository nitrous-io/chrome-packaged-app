#= require prefetch

NIO.IndexRoute = Ember.Route.extend
  activate: ->
    if NIO.TokenFetcher.hasToken()
      this.transitionToRoute('main')

NIO.MainRoute = Ember.Route.extend
  activate: ->
    if appWindow = chrome.app.window.current()
      appWindow.resizeTo 950, 650 

  beforeModel: ->
    NIO.Prefetch [ NIO.Box, NIO.Region, NIO.BoxTemplate ]

  model: ->
    NIO.Box.findAll()

  renderTemplate: ->
    this.render()

    this.render('box_list', {
      into: 'main'
      outlet: 'sidebar'
      controller: this.controllerFor('boxList')
    })

    this.render('box_details', {
      into: 'main'
      outlet: 'details'
      controller: this.controllerFor('boxDetails')
    });

  setupController: ->
    this.controllerFor('boxList').set 'model', NIO.Box.findAll()
    this.controllerFor('boxDetails').set 'model', NIO.Box.first()

  events:
    selectBox: (id) ->
      box = NIO.Box.find id
      controller = this.controllerFor('boxDetails')
      controller.set 'content', box
