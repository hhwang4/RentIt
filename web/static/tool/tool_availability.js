'use strict';

angular.module('myApp.toolAvailability', ['ngRoute', 'ngAnimate'])
  .config(['$routeProvider', function($routeProvider) {
    $routeProvider.when('/tool_availability', {
      templateUrl: 'static/tool/tool_availability.html',
      controller: 'ToolAvailabilityCtrl',
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
  .controller('ToolAvailabilityCtrl', ['$scope', '$http', 'localStorageService', '$uibModal', function($scope, $http, $localStorage, $uibModal) {
    // User
    var user_info = $localStorage.get('authorizationData') || {};
    $scope.customer_full_name = user_info.full_name; // TODO: Add user full_name to cache
    $scope.customer_username = user_info.username;

    // Reservation tools
    $scope.tools = [];
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
        search_type: 'tool_availability',
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
  }]);

