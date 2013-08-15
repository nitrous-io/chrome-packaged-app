AIO.N2OGaugeView = Em.View.extend
  templateName: 'n2o-gauge'
  classNames: ['n2o']

  freeN2OBinding: Em.Binding.oneWay 'AIO.currentUser.freeN2O'
  maxN2OBinding:  Em.Binding.oneWay 'AIO.currentUser.maxN2O'

  barWidthStyle: (->
    freeN2O = @get('freeN2O') ? 0
    maxN2O  = @get('maxN2O')  ? 1
    "width: #{freeN2O / maxN2O * 100}%"
  ).property 'freeN2O', 'maxN2O'

  click: ->
    @get('controller').openPage 'n2oBonus'
