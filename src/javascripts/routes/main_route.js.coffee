NIO.MainRoute = Ember.Route.extend
  activate: ->
    if appWindow = chrome.app.window.current()
      appWindow.resizeTo 950, 650 

  beforeModel: ->
    jQuery.when NIO.Box.fetch(), 
                NIO.User.fetch(),
                NIO.Region.fetch(), 
                NIO.BoxTemplate.fetch()

  renderTemplate: ->
    this.render()

    this.render('user_details', {
      into: 'main'
      outlet: 'topbar'
      controller: this.controllerFor('user')
    })

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

    currentUser = NIO.User.first()
    this.controllerFor('user').set 'model', currentUser
    NIO.set 'currentUser', currentUser

  events:
    selectBox: (id) ->
      box = NIO.Box.find id
      controller = this.controllerFor('boxDetails')
      controller.set 'content', box
