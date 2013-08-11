AIO.N2oGaugeView = Ember.View.extend
  templateName: 'views/n2o_gauge'
  classNames: ['n2o']

  freeN2OBinding: Em.Binding.oneWay 'AIO.currentUser.free_n2o'
  maxN2OBinding: Em.Binding.oneWay 'AIO.currentUser.max_n2o'

  barWidthStyle: (->
    freeN2O = @get('freeN2O') ? 0
    maxN2O  = @get('maxN2O')  ? 0
    "width: #{freeN2O / maxN2O * 100}%"
  ).property 'freeN2O', 'maxN2O'

  click: ->
    @get('controller').send "open 'n2o_bonus'"
