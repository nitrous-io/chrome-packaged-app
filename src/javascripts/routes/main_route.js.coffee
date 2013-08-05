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
    
    refreshBoxes: ->
      NIO.Box.fetch(true)
      .done =>
        # TODO: The way box refreshes are currently handled is hackish.
        # There should be proper bindings to auto-update
        this.controllerFor('boxList').set 'model', NIO.Box.findAll()
        
        boxDetails = this.controllerFor('boxDetails')
        currentBoxId = boxDetails.get 'content.id'
        boxDetails.set 'model', NIO.Box.find currentBoxId

        # TODO: Show a flash message to user.
        console.log 'boxes updated'

