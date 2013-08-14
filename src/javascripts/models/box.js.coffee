#= require ./base-model

AIO.Box = klass = AIO.BaseModel.extend
  name: Em.attr()
  state: Em.attr()

  host: Em.attr()
  port: Em.attr()

  memory: Em.attr()
  storage: Em.attr()
  boxServerUri: Em.attr()
  backendAvailable: Em.attr()

  controllable: (->
    @get('state') in ['running', 'stopped']
  ).property 'state'

  running: (->
    @get('state') == 'running'
  ).property 'state'

  stopped: (->
    @get('state') == 'stopped'
  ).property 'state'

  prettyState: (->
    if state = @get 'state'
      if state == 'failed'
        state = 'provisioning_failed'
      if state.match /ed$/
        state = state + '!'
      else if state.match /ing$/
        state = state + '...'

      state = state.split('_').map((t) -> t.capitalize()).join(' ')
  ).property 'state'

klass.reopenClass
  rootKey: 'box'
  collectionKey: 'boxes'
  storageKey: 'boxes'
  url: "#{AIO.get 'host'}/api/v0/boxes"
