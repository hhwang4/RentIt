'use strict';

// Declare app level module which depends on views, and components
angular.module('myApp', [
  'ngRoute',
  'ngSanitize',
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
  'myApp.reports',
  'myApp.clerkReport',
  'myApp.customerReport',
  'myApp.toolReport',
  'myApp.makeReservation',
  'myApp.toolAvailability',
  'myApp.pickupReservation',
  'myApp.dropoffReservation',
  'myApp.register',
  'myApp.dashboard',
  'myApp.version',
  'myApp.addtool'
])
  .config(['$locationProvider', '$routeProvider', function($locationProvider, $routeProvider) {
  $locationProvider.hashPrefix('!');

  $routeProvider.otherwise({redirectTo: '/login'});
}])
  .filter('capitalize', function() {
    // source: https://stackoverflow.com/questions/30207272/capitalize-the-first-letter-of-string-in-angularjs
    return function(input) {
      return (!!input) ? input.charAt(0).toUpperCase() + input.substr(1).toLowerCase() : '';
    }
  });
