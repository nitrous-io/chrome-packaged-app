#= require ./chrome_model

NIO.Box = NIO.ChromeModel.extend
  backend_available     : null
  box_server_uri        : null
  box_template_id       : null
  container_name        : null
  host                  : null
  memory                : null
  owner_id              : null
  port                  : null
  region_id             : null
  name                  : null
  state                 : null
  storeage              : null

  running: (->
    @get('state') == 'running'
  ).property 'state'

  stopped: (->
    @get('state') == 'stopped'
  ).property 'state'
  
  region: (->
    NIO.Region.find @get('region_id') 
  ).property 'region_id'

  boxTemplate: (->
    NIO.BoxTemplate.find @get('box_template_id') 
  ).property 'box_template_id'

  stateForDisplay: (->
    switch state = @get 'state'
      when 'failed'
        'provisioning failed'
      when 'changing_specs'
        'changing specs'
      else
        state
  ).property 'state'

  invoke: (action) ->
    if action in [ 'start', 'stop', 'restart' ]
      this.makeRequest action
    else
      console.log "Unsupported action - #{action}"

  makeRequest: (action) ->
    id = @get 'id'
    NIO.Utils.makeRequest('PUT', "/boxes/#{id}/#{action}")
    .done (data) =>
      this.setProperties data.box
    .fail (xhr, status, error) =>
      console.log error

NIO.Box.reopenClass
  store: []
  resourceCollection: 'boxes'
