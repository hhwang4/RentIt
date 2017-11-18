'use strict';

angular.module('myApp.pickupReservation', ['ngRoute', 'ngAnimate'])
  .config(['$routeProvider', function($routeProvider) {
    $routeProvider.when('/pickup_reservation', {
      templateUrl: 'static/reservation/pickup_reservation.html',
      controller: 'PickupReservationCtrl',
      resolve: {
        accessToken: ['localStorageService', '$location', function ($localStorage, $location) {
          if ($localStorage.get('authorizationData'))
            return $localStorage.get('authorizationData');
          else {
            $location.path('/login');
            return;
          }
        }]
      }
    });
  }])
  .controller('PickupReservationCtrl', ['$scope', '$http', '$sce', 'localStorageService', '$location', '$uibModal', function($scope, $http, $sce, $localStorage, $location, $uibModal) {
    var user_info =  $localStorage.get('authorizationData') || {};
    $scope.reservations = [];
    $scope.reservation_id = null;
    $scope.clerk_full_name = user_info.full_name; // TODO: Add user full_name to cache
    $scope.clerk_username = user_info.username;
    $scope.htmlPopover = function(index) {
      var reservation = $scope.reservations[index];
      return ('<div class="container reservation-details"><h6><b>Reservation ID: #</b>' + reservation.id +'</h6>'
        + '<br /><b>Customer Name: </b>' + reservation.customer_name
        + '<br /><b>Total Deposit: $</b>' + reservation.total_deposit_price
        + '<br /><b>Total Rental Price: $</b>' + reservation.total_rental_price
        + '</div>')
    };
    $scope.disable_pickup_button = function() {
      var invalid = true;
      if ($scope.reservation_id) {
        invalid = $scope.reservations.findIndex(function (r) {
          return r.id === $scope.reservation_id;
        }) === -1;
      }
      return invalid;
    };

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
              'end_date': reservation.end_date,
              'total_deposit_price': reservation.total_deposit_price,
              'total_rental_price': reservation.total_rental_price
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
        controller: function($uibModalInstance, $scope, reservation_id, clerk_username, clerk_full_name) {
          $scope.reservation_id = reservation_id;
          $scope.clerk_username = clerk_username;
          $scope.clerk_full_name = clerk_full_name ;
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

          // Availability popover
          $scope.dynamicPopover = {
            templateUrl: 'static/tool/tool_full_description.html',
            tool: {},
            error: false,
            error_message: "An error has occurred retrieving your data. Please try again later."
          };
          $scope.getTool = function(index) {
            const currentTool = $scope.tools[index];
            $http.get('/tools/' + currentTool.id)
              .success(function(response) {
                const tool = ((response.data || {}).details || [])[0] || {};
                $scope.dynamicPopover.tool.id = tool.id;
                $scope.dynamicPopover.tool.type = tool.tool_type;
                $scope.dynamicPopover.tool.short_description = tool.short_description;
                $scope.dynamicPopover.tool.full_description = tool.full_description;
                $scope.dynamicPopover.tool.deposit_price = tool.deposit_price;
                $scope.dynamicPopover.tool.rental_price = tool.rental_price;
                $scope.dynamicPopover.tool.accessories = tool.accessories;
              })
              .error(function(response) {
                $scope.dynamicPopover.error = true;
                console.log(response.message);
              });
          };

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
          $scope.close = function () {
            $uibModalInstance.close({status: 'close'});
            $location.path('/dashboard');
          };

        },
        resolve: {
          reservation_id: function () {
            return $scope.reservation_id;
          },
          clerk_username: function() {
            return $scope.clerk_username;
          },
          clerk_full_name: function() {
           return $scope.clerk_full_name;
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

