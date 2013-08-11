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

    openInvites: ->
      AIO.Utils.openInWebView "app#invites"

    openN2oBonus: ->
      AIO.Utils.openInWebView "app#n2o/bonus"

    openBoxes: ->
      AIO.Utils.openInWebView "app#boxes"

    openPublicKeys: ->
      AIO.Utils.openInWebView "app#public_keys"

    openAccountSettings: ->
      AIO.Utils.openInWebView "users/edit"

    openApplications: ->
      AIO.Utils.openInWebView "oauth/authorized_applications"

    openNewBox: ->
      AIO.Utils.openInWebView "app#boxes/new"

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
