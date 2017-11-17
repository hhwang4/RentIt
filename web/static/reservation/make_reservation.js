'use strict';

angular.module('myApp.makeReservation', ['ngRoute', 'ngAnimate'])
  .config(['$routeProvider', function($routeProvider) {
    $routeProvider.when('/make_reservation', {
      templateUrl: 'static/reservation/make_reservation.html',
      controller: 'MakeReservationCtrl',
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
  .controller('MakeReservationCtrl', ['$scope', '$http', 'localStorageService', '$uibModal', function($scope, $http, $localStorage, $uibModal) {
    // User
    var user_info = $localStorage.get('authorizationData') || {};
    $scope.customer_full_name = user_info.full_name; // TODO: Add user full_name to cache
    $scope.customer_username = user_info.username;

    // Reservation tools
    $scope.tools = [];
    $scope.toolsAdded = [];
    $scope.hasSearched = false;

    // Calendar popup
    $scope.dateOptions = {
      formatYear: 'yy',
      maxDate: new Date(2020, 5, 22),
      minDate: new Date(),
      startingDay: 1
    };
    $scope.open1 = function() {
      $scope.popup1.opened = true;
    };
    $scope.popup1 = {
      opened: false
    };
    $scope.open2 = function() {
      $scope.popup2.opened = true;
    };
    $scope.popup2 = {
      opened: false
    };

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


    // Search
    $scope.end_date = null;
    $scope.start_date = null;
    $scope.type = null;
    $scope.keyword = '';
    $scope.power_source = null;
    $scope.sub_type = null;
    $scope.tool_search = function() {
      $scope.hasSearched = true;
      var params = {
        start_date: moment($scope.start_date).format('YYYY-MM-DD'),
        end_date: moment($scope.end_date).format('YYYY-MM-DD'),
        keyword: $scope.keyword,
        search_type: 'reservation',
        type: $scope.type,
        power_source: $scope.power_source,
        sub_type: $scope.sub_type
      };
      $http({ method: 'GET', url: '/tools', params: params })
        .success(function(response) {
          var data = (response.data || {}).tools || [];
          $scope.tools = data.map(function(tool) {
            return ({
              id: tool.id,
              description: tool.description,
              rental_price: tool.rental_price,
              deposit_price: tool.deposit_price,
              added: false
            });
          });
        })
        .error(function(response) {
          // If tools don't load, load default list (temporary)
          // TODO: Handle failed search
        });
    };

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

    $scope.open = function(size, parentSelector) {
      var parentElem = parentSelector ?
        angular.element($document[0].querySelector('.modal' + parentSelector)) : undefined;
      var modalInstance = $uibModal.open({
        animation: false,
        ariaLabelledBy: 'modal-title',
        ariaDescribedBy: 'modal-body',
        templateUrl: 'static/reservation/confirmationModal.html',
        controller: function($uibModalInstance, $scope, toolsAdded, start_date, end_date, customer_username) {
          $scope.title = "Reservation Summary";
          $scope.isSummary = true;
          $scope.toolsAdded = toolsAdded;
          $scope.start_date = moment(start_date).format('YYYY-MM-DD');
          $scope.end_date = moment(end_date).format('YYYY-MM-DD');
          $scope.number_of_days_rented = moment($scope.end_date).diff(moment($scope.start_date), 'days');

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
            return $scope.customer_username
          }
        },
        size: size
      });
      modalInstance.result.then(function (response) {
        // Check to see if the make reservation table should be reset
        if (response['status'] === "success" || response['status'] === "reset") {
          $scope.toolsAdded.forEach(function(tool) {
            tool.added = false;
          });
          $scope.toolsAdded = [];
        } else if (response['status'] === "fail") {
          var tool_ids = response['tool_ids'] || [];
          $scope.toolsAdded = $scope.toolsAdded.filter(function(tool) {
            // Remove tools that cannot be reserved from tool list
            // TODO: Display message indicating tools are removed
            if (tool_ids.indexOf(tool.id) !== -1) {
              tool.added = false;
              return false;
            } else {
              return true;
            }
          });
        }
      }, function () {
        // TODO: Handle error case
      });
    };
  }]);

