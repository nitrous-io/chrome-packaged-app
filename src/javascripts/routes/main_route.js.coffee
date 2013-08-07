AIO.MainRoute = Ember.Route.extend
  beforeModel: ->
    jQuery.when AIO.Box.fetch(), 
                AIO.User.fetch(),
                AIO.Region.fetch(), 
                AIO.BoxTemplate.fetch()

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
    this.controllerFor('boxList').set 'model', AIO.Box.findAll()
    this.controllerFor('boxDetails').set 'model', AIO.Box.first()

    currentUser = AIO.User.first()
    this.controllerFor('user').set 'model', currentUser
    AIO.set 'currentUser', currentUser

    this.controllerFor('pusher').initialize AIO.get('pusherKey'), AIO.get('pusherEndpoint')

  events:
    selectBox: (id) ->
      box = AIO.Box.find id
      controller = this.controllerFor('boxDetails')
      controller.set 'content', box
    
    refreshBoxes: ->
      AIO.Box.fetch(true)
      .done =>
        # TODO: The way box refreshes are currently handled is hackish.
        # There should be proper bindings to auto-update
        this.controllerFor('boxList').set 'model', AIO.Box.findAll()
        
        boxDetails = this.controllerFor('boxDetails')
        currentBoxId = boxDetails.get 'content.id'
        boxDetails.set 'model', AIO.Box.find currentBoxId

        # TODO: Show a flash message to user.
        console.log 'boxes updated'

