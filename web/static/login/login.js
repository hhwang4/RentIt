'use strict';

angular.module('myApp.login', ['ngRoute'])

.config(['$routeProvider', function($routeProvider) {
  $routeProvider.when('/login', {
    templateUrl: 'static/login/login.html',
    controller: 'LoginCtrl'
  });
}])

.controller('LoginCtrl', ['$scope', '$http', 'localStorageService', function($scope, $http, localStorageService) {
  $scope.view = 'This is a scope variable1';

  $http.post('/customer/login', {"username": "thebatman", "password": "robin"}, { headers: { 'Content-Type': 'application/json' } })
  .success(function (response) {
                    localStorageService.set('authorizationData', { userName: response});
                    console.log('It worked');
                })
                .error(function (err, status) {
                    console.log('Error', err, status);
                });
}]);
