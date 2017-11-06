'use strict';

// Declare app level module which depends on views, and components
angular.module('myApp', [
  'ngRoute',
  'LocalStorageModule',
  'ui.bootstrap',
  'ngAnimate', 
  'myApp.view1',
  'myApp.view2',
  'myApp.login',
<<<<<<< HEAD
  'myApp.register',
=======
  'myApp.make_reservation',
>>>>>>> a2c41e902280fad6ead1430a9acefc0651b0c5bc
  'myApp.version'
]).
config(['$locationProvider', '$routeProvider', function($locationProvider, $routeProvider) {
  $locationProvider.hashPrefix('!');

  $routeProvider.otherwise({redirectTo: '/login'});
}]);
