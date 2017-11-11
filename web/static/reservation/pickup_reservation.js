'use strict';

angular.module('myApp.pickupReservation', ['ngRoute', 'ngAnimate', ])
  .config(['$routeProvider', function($routeProvider) {
    $routeProvider.when('/pickup_reservation', {
      templateUrl: 'static/reservation/pickup_reservation.html',
      controller: 'PickupReservationCtrl',
      resolve: {
        accessToken: ['localStorageService', '$location', function ($localStorage, $location) {
          if ($localStorage.get('authorizationData'))
            return $localStorage.get('authorizationData')
          else {
            $location.path('/login');
            return;
          }
        }]
      }
    });
  }])
  .controller('PickupReservationCtrl', ['$scope', '$http', 'localStorageService', '$uibModal', function($scope, $http, localStorageService, $uibModal) {
    $scope.reservations = [];
    $scope.reservation_id = null;
    $http({
      method: 'GET',
      url: '/pickup_reservations'
    })
      .then(function(response) {
          var data = (response.data || {}).data;
          var reservations = data.reservations || [];
          $scope.reservations = reservations.map(function(reservation) {
            return ({
              'id': reservation.reservation_id,
              'customer_username': reservation.customer_username,
              'customer_name': reservation.customer_name,
              'customer_id': reservation.customer_id,
              'start_date': reservation.start_date,
              'end_date': reservation.end_date
            });
          });
        },
        function(response) {
          // If tools don't load, load default list (temporary)
          $scope.reservations =
            [{
              'id': 1,
              'customer_username': 'johnson',
              'customer_name': 'Wayne Johnson',
              'customer_id': 23,
              'start_date': '05/19/2017',
              'end_date': '06/18/2017'
            },
              {
                'id': 2,
                'customer_username': 'thomas',
                'customer_name': 'Taylor Thomas',
                'customer_id': 24,
                'start_date': '05/09/2017',
                'end_date': '06/8/2017'
              }];
        });

    $scope.open = function(size, parentSelector) {
      var modalInstance = $uibModal.open({
        animation: false,
        ariaLabelledBy: 'modal-title',
        ariaDescribedBy: 'modal-body',
        templateUrl: 'static/reservation/confirmation_pickup_reservation.html',
        controller: function($uibModalInstance, $scope, reservation_id, clerk_username) {
          $scope.reservation_id = reservation_id;
          $scope.clerk_username = clerk_username;
          $scope.card_option = 'existing';
          $scope.vm = {};
          $scope.vm.months = [
            {id: 1, name: "January"},
            {id: 2, name: "February"},
            {id: 3, name: "March"},
            {id: 4, name: "April"},
            {id: 5, name: "May"},
            {id: 6, name: "June"},
            {id: 7, name: "July"},
            {id: 8, name: "August"},
            {id: 9, name: "September"},
            {id: 10, name: "October"},
            {id: 11, name: "November"},
            {id: 12, name: "December"}
          ];

          $scope.vm.years = Array.apply(null, {length: 20}).map(function (value, index) {
            return index + 2017;
          });

          $scope.vm.cardName = null;
          $scope.vm.cardNumber = null;
          $scope.vm.expirationMonth = {id: 1};
          $scope.vm.expirationYear = 2017;
          $scope.vm.cvc = null;



          // Retrieve data for selected reservation
          $http.get("pickup_reservations/" + $scope.reservation_id)
            .success(function(response) {
              var data = response.data || {};
              var details = data.details || {};
              $scope.customer_full_name = details.customer_full_name;
              $scope.customer_username = details.customer_username;
              $scope.total_rental_price = details.total_rental_price;
              $scope.total_deposit_price = details.total_deposit_price;
              $scope.start_date = details.start_date;
              $scope.end_date = details.end_date;
            })
            .error(function(response) {
              // TODO: Could not find record
            });
          $scope.title = "Pickup Reservation";
          $scope.isSummary = true;
          $scope.tools = [];
          $scope.submit = function () {
            var data = {
              clerk_username: $scope.clerk_username
            };

            var config = { header: { 'Content-Type': 'application/json' } };
            $http.post('/pickup_reservations/' + $scope.reservation_id , data, config)
              .success(function(response) {
                var data = response.data;
                $scope.isSummary = false;
                // Add tools in reservation to reservation list
                $scope.tools = data.tools.map(function(tool) {
                  return ({
                    id: tool.id,
                    description: tool.description,
                    deposit_price: tool.deposit_price,
                    rental_price: tool.rental_price
                  })
                });
              })
              .error(function(response) {
                $uibModalInstance.close({status: 'fail'});
              });
            if ($scope.card_option === 'new') {
              data = {
                "cardName": $scope.vm.cardName,
                "cardNumber": $scope.vm.cardNumber,
                "expirationMonth": $scope.vm.expirationMonth.id,
                "expirationYear": $scope.vm.expirationYear,
                "cvc": $scope.vm.cvc
              };
              $http.post("/customer/" + $scope.customer_username + "/credit_cards", data, {headers: {'Content-Type': 'application/json'}})
                .success(function(res) {

              })
                .error(function (err, status) {
                  console.log('Error', err, status);
                  $scope.error = err.message
                });
            }
          };
          $scope.cancel = function () {
            $uibModalInstance.dismiss({status: 'cancel'});
          };
          $scope.reset = function () {
            $uibModalInstance.close({status: 'reset'});
          };
        },
        resolve: {
          reservation_id: function () {
            return $scope.reservation_id;
          },
          clerk_username: function() {
            return 'admin@gatech.edu'; // TODO: Get user from localStorage
          }
        },
        size: size
      });
      modalInstance.result.then(function (response) {
        // TODO: Result of modal
      }, function () {
        // TODO: Handle error case
      });
    };
  }]);

