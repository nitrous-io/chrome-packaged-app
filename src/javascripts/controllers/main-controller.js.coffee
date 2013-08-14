AIO.MainController = Em.ObjectController.extend
  # GET /api/v0/user will return the current user
  # take the first item of the array given by ember-model's find()
  _users: null
  _usersDidChange: (->
    if user = @get '_users.content.0'
      AIO.set 'currentUser', user
      AIO.CurrentUser.saveToStorage user
  ).observes '_users.content'
