'use strict';

angular.module('myApp.make_reservation', ['ngRoute', 'ngAnimate', ])
.config(['$routeProvider', function($routeProvider) {
  $routeProvider.when('/make_reservation', {
    templateUrl: 'static/reservation/make_reservation.html',
    controller: 'MakeReservationCtrl'
  });
}])
.controller('MakeReservationCtrl', ['$scope', '$http', 'localStorageService', '$uibModal', function($scope, $http, localStorageService, $uibModal) {
  $scope.tools = [];
  $scope.toolsAdded = [];
  $scope.hasSearched = true;
  $scope.showModal = false;
  $scope.end_date;
  $scope.start_date;

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

  $scope.addTool = function(index) {
    var tool = $scope.tools[index];
    if ($scope.toolsAdded.indexOf(tool) === -1) {
      $scope.toolsAdded.push(tool);
      tool.added = true; 
    } else {
      $scope.removeTool($scope.toolsAdded.indexOf(tool));
    }
  }

  $scope.removeTool = function(index) {
    var tool = $scope.toolsAdded[index];
    tool.added = false;
    $scope.toolsAdded.splice(index, 1);
  }

  $scope.calculateTotal = function() {
    $scope.showModal = true;
  }

	$scope.open = function(size, parentSelector) {
    var parentElem = parentSelector ? 
      angular.element($document[0].querySelector('.modal' + parentSelector)) : undefined;
    var modalInstance = $uibModal.open({
      animation: false,
      ariaLabelledBy: 'modal-title',
      ariaDescribedBy: 'modal-body',
      templateUrl: 'static/reservation/confirmationModal.html',
			controller: function($uibModalInstance, $scope, toolsAdded, start_date, end_date, customer_username) {
        $scope.title = "Reservation Summary" 
        $scope.isSummary = true;
        $scope.toolsAdded = toolsAdded;
        $scope.start_date = start_date;
        $scope.end_date = end_date;
        $scope.total_deposit_price = $scope.toolsAdded.reduce(function(total, tool) {
          return total + parseFloat(tool.deposit_price);
        }, 0);
        $scope.total_rental_price = $scope.toolsAdded.reduce(function(total, tool) {
          return total + parseFloat(tool.rental_price);
        }, 0);
        $scope.submit = function () {
          var data = {
            customer_username: customer_username,
            tools: $scope.toolsAdded,
            start_date: $scope.start_date,
            end_date: $scope.end_date
          };

          var config = { header: { 'Content-Type': 'application/json' } };
          $http.post('/reservations', data, config)
            .success(function(response) {
              var data = response.data;
              $scope.isSummary = false;
              $scope.reservation_id = data['reservation_id'];
            })
          .error(function(response) {
            var data = response.data || {};
            $uibModalInstance.close({status: 'fail', tool_ids: data['tool_ids']});
          });
        };
        $scope.cancel = function () {
          $uibModalInstance.dismiss({status: 'cancel'});
        };
        $scope.reset = function () {
          $uibModalInstance.close({status: 'reset'});
        };
      },
      resolve: {
        toolsAdded: function () {
          return $scope.toolsAdded;
        },
        start_date: function() {
          return $scope.start_date;
        },
        end_date: function() {
          return $scope.end_date;
        },
        customer_username: function() {
          return 'thebatman';
        }
      },
      size: size,
    });
    modalInstance.result.then(function (response) {
      // Check to see if the make reservation table should be reset
      if (response['status'] === "success" || response['status'] === "reset") {
        $scope.toolsAdded.forEach(function(tool) {
          tool.added = false;
        });
        $scope.toolsAdded = [];
      } else if (response['status'] === "fail") {
        var tool_ids = response['tool_ids'];
        $scope.toolsAdded = $scope.toolsAdded.filter(function(tool) {
          // Remove tools that cannot be reserved from tool list
          if (tool_ids.indexOf(tool.id) !== -1) {
            tool.added = false;
            return false;
          } else {
            return true;
          }
        });
      }
    }, function () {
    });
  };	
}]);

