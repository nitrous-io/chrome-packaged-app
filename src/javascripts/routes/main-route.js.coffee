AIO.MainRoute = Em.Route.extend
  beforeModel: ->
    if !AIO.get('accessToken')
      @transitionTo 'sign-in'

  setupController: (controller) ->
    @_super.apply this, arguments

    controller.set '_users', AIO.CurrentUser.loadFromStorage ->
      AIO.CurrentUser.find().reload()

  model: ->
    AIO.Box.loadFromStorage ->
      AIO.Box.find().reload()

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
