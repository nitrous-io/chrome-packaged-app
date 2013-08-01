NIO.Box = Ember.Object.extend({
  name: null,
  state: null,

  running: (function() {
    return this.get('state') === 'running'
  }).property('state')

});
