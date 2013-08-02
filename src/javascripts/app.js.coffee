#= require ./libs/jquery-1.9.1
#= require ./libs/handlebars-1.0.12
#= require ./libs/ember-1.0.0-rc.6.1
#= require_self
#= require routes
#= require models
#= require controllers
#= require_tree ./templates

#= require token_fetcher

window.NIO = Ember.Application.create()

NIO.reopen
  host: 'https://www.n2odev.com:5000'

NIO.IndexRoute = Ember.Route.extend
  activate: ->
    if NIO.TokenFetcher.hasToken()
      this.transitionToRoute('main')

NIO.MainRoute = Ember.Route.extend
  beforeModel: ->
    # returns a promise
    NIO.Box.fetch()

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

  setupControllers: ->
    this.controllerFor('boxList').set 'model', NIO.Box.findAll()
    this.controllerFor('boxDetails').set 'model', NIO.Box.first()

  events: {
    selectBox: (id) ->
      box = NIO.Box.find id
      controller = this.controllerFor('boxDetails')
      controller.set 'content', box
  }
