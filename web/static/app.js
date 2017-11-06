'use strict';

// Declare app level module which depends on views, and components
angular.module('myApp', [
  'ngRoute',
  'LocalStorageModule',
  'ngMessages',
  'ngPassword',
  'ui.bootstrap',
  'ngAnimate',
  'myApp.view1',
  'myApp.view2',
  'myApp.login',
  'myApp.logout',
  'myApp.profile',
  'myApp.make_reservation',
  'myApp.register',
  'myApp.dashboard',
  'myApp.version'
]).
config(['$locationProvider', '$routeProvider', function($locationProvider, $routeProvider) {
  $locationProvider.hashPrefix('!');

  $routeProvider.otherwise({redirectTo: '/login'});
}]);
