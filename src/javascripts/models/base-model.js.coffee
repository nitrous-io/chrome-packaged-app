AIO.BaseModel = klass = Em.Model.extend
  id: Em.attr()

klass.reopenClass
  adapter: Em.RESTAdapter.create()
  camelizeKeys: true
