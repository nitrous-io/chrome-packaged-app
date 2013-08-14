AIO.MainController = Em.ArrayController.extend
  # model: Box

  sortProperties: ['id']

  contentDidChange: (->
    AIO.Box.saveToStorage()
  ).observes 'content.@each'

  # GET /api/v0/user will return the current user
  # take the first item of the array given by ember-model's find()
  _users: null
  _usersDidChange: (->
    if user = @get '_users.content.0'
      AIO.set 'currentUser', user
      AIO.CurrentUser.saveToStorage user
  ).observes '_users.content.@each'
