AIO.MainController = Em.ArrayController.extend
  # model: Box

  sortProperties: ['id']

  contentDidChange: (->
    AIO.Box.saveToStorage()
  ).observes 'content.@each'

