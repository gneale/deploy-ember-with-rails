import Ember from 'ember';
import config from './config/environment';

var Router = Ember.Router.extend({
  location: config.locationType
});

Router.map(function() {
  this.route('ember-app', { path: '/' });
  this.route('pizza', { path: 'pizza' });
  this.route('cats', { path: 'cats' });
});

export default Router;
