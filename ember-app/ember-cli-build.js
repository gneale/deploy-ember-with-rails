/* global require, module */
var EmberApp = require('ember-cli/lib/broccoli/ember-app');

module.exports = function(defaults) {
  var app = new EmberApp(defaults, {
    fingerprint: {
      extensions: ['png']
    },
    storeConfigInMeta: false
  });

  return app.toTree();
};
