# For now log all messages
Pusher.log = (message) -> console.log message

AIO.Pusher = klass = Em.Object.extend
  pusherKey: null
  pusherEndpoint: null
  pusher: null
  channel: null
  subscribed: false

  channelName: (->
    if currentUserId = AIO.get 'currentUser.id'
      "private-user-#{currentUserId}"
  ).property 'AIO.currentUser.id'

  autoConnect: (->
    pusherKey = @get 'pusherKey'
    pusherEndpoint = @get 'pusherEndpoint'
    channelName = @get 'channelName'
    token = AIO.get 'accessToken.token'

    subscribed = @get 'subscribed'

    if pusherKey && pusherEndpoint && channelName && token
      # subscribe
      unless subscribed
        @set 'subscribed', true

        pusher = new Pusher pusherKey,
          encrypted: true
          authEndpoint: pusherEndpoint
          auth:
            headers:
              Authorization: "Bearer #{token}"

        @set 'pusher', pusher
        @set 'channel', channel = pusher.subscribe(channelName)

        channel.bind 'aio:box_updated', (json) =>
          if box = json.box
            AIO.Box.findById(box.id).load(box.id, box)

        channel.bind 'aio:n2o_updated', (json) ->
          currentUser = AIO.get('currentUser')
          n2o = json.n2o
          if currentUser && n2o
            currentUser.set 'maxN2O', n2o.max
            currentUser.set 'usedN2O', n2o.used
    else
      # unsubscribe
      if pusher = @get 'pusher'
        if channel = @get 'channel'
          pusher.unsubscribe(channel.name)
        @set 'channel', null
        pusher.disconnect()
        @set 'pusher', null
      @set 'subscribed', false
  ).observes 'pusherKey', 'pusherEndpoint', 'channelName', 'accessToken.token'

sharedPusherInstance = null

klass.reopenClass
  sharedInstance: ->
    sharedPusherInstance ?= AIO.Pusher.create.apply AIO.Pusher, arguments
    console.log sharedPusherInstance
    sharedPusherInstance
