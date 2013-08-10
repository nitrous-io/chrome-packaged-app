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
    })

    this.render('box_details', {
      into: 'main'
      outlet: 'details'
    });

  setupController: (controller) ->
    controller.set 'model', AIO.Box.findAll()

    currentUser = AIO.User.first()
    this.controllerFor('user').set 'model', currentUser
    AIO.set 'currentUser', currentUser

    this.controllerFor('pusher').initialize AIO.get('pusherKey'), AIO.get('pusherEndpoint')

  events:
    openIde: (box) ->
      if box
        boxId = box.get 'id'
        AIO.Utils.openInWebView "app#boxes/#{boxId}/ide"

    openSettings: (box) ->
      if box
        boxId = box.get 'id'
        AIO.Utils.openInWebView "app#boxes/#{boxId}/edit"

    openTerminal: (box) ->
      if box
        boxId = box.get 'id'
        AIO.Utils.openInWebView "app#boxes/#{boxId}/terminal"

    doAction: (box, action) ->
      box.doAction action

    refreshBoxes: ->
      AIO.Box.fetch(true)
      .done =>
        console.log 'here'
        # TODO: The way box refreshes are currently handled is hackish.
        # There should be proper bindings to auto-update
        this.controllerFor('boxList').set 'model', AIO.Box.findAll()

        boxDetails = this.controllerFor('boxDetails')
        currentBoxId = boxDetails.get 'content.id'
        boxDetails.set 'model', AIO.Box.find currentBoxId

        # TODO: Show a flash message to user.
        console.log 'boxes updated'
