#= require chrome_model

NIO.Box = NIO.ChromeModel.extend
  id                    : null

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
    this.get('state') == 'running'
  ).property 'state'

  stopped: (->
    this.get('state') == 'stopped'
  ).property 'state'

NIO.Box.reopenClass
  resourceCollection: 'boxes'
