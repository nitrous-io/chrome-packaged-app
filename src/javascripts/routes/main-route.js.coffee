AIO.MainRoute = Ember.Route.extend
  beforeModel: ->
    jQuery.when AIO.Box.fetch(),
                AIO.User.fetch(),
                AIO.Region.fetch(),
                AIO.BoxTemplate.fetch()

  renderTemplate: ->
    this.render()

    this.render('sidebar', {
      into: 'main'
      outlet: 'sidebar'
    })

  setupController: (controller) ->
    controller.set 'model', AIO.Box.findAll()

    currentUser = AIO.User.first()
    AIO.set 'currentUser', currentUser

    this.controllerFor('pusher').initialize AIO.get('pusherKey'), AIO.get('pusherEndpoint')

  events:
    open: (view, box) ->
      if box
        boxId = box.get 'id'

      views = {
        ide: "app#boxes/#{boxId}/ide"
        settings: "app#boxes/#{boxId}/edit"
        terminal: "app#boxes/#{boxId}/terminal"
        invites: "app#invites"
        n2o_bonus: "app#n2o/bonus"
        boxes: "app#boxes"
        public_keys: "app#public_keys"
        account_settings: "users/edit"
        applications: "oauth/authorized_applications"
        new_box: "app#boxes/new"
      }

      AIO.Utils.openInWebView views[view]

    signout: ->
      AIO.User.signout()
      this.transitionTo 'index'

    doAction: (box, action) ->
      box.doAction action

    retryLastRequest: ->
      if lastRequest = AIO.get 'lastRequest'
        AIO.Utils.makeRequest.apply null, lastRequest
        AIO.set 'requestFailed', false

    refreshBoxes: ->
      AIO.Box.fetch(true)
      .done =>
        # TODO: The way box refreshes are currently handled is hackish.
        # There should be proper bindings to auto-update
        this.controller.set 'model', AIO.Box.findAll()
