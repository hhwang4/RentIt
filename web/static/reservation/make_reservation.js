'use strict';

angular.module('myApp.make_reservation', ['ngRoute'])
.config(['$routeProvider', function($routeProvider) {
  $routeProvider.when('/make_reservation', {
    templateUrl: 'static/reservation/make_reservation.html',
    controller: 'MakeReservationCtrl'
  });
}])
.controller('MakeReservationCtrl', ['$scope', '$http', function($scope, $http) {
  $scope.tools = [];
  $scope.hasSearched = true;
  $http({
    method: 'GET',
    url: '/tools'
  })
  .then(function(response) {
    $scope.tools = response.data.map(function(tool) {
      return ({
        id: tool.id,
        description: tool.description,
        rental_price: tool.rental_price,
        deposit_price: tool.deposit_price,
        added: false
      });
    });
  },
  function(response) {
    $scope.tools = 
      [{
        id: 1,
        description: 'Description',
        rental_price: 45.00,
        deposit_price: 34.00,
        added: false
      },
      {
        id: 2,
        description: 'Description2',
        rental_price: 35.00,
        deposit_price: 24.00,
        added: false
      }];
  });
}]);

