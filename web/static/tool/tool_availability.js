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
    // Sorting
    $scope.propertyName = 'id';
    $scope.reverse = false;
    $scope.sortBy = function(propertyName) {
      $scope.reverse = ($scope.propertyName === propertyName) ? !$scope.reverse : false;
      $scope.propertyName = propertyName;
    };

    // User
    var user_info = $localStorage.get('authorizationData') || {};
    $scope.customer_full_name = user_info.full_name; // TODO: Add user full_name to cache
    $scope.customer_username = user_info.username;

    // Reservation tools
    $scope.resetTools = function() {
      $scope.tools = [];
      $scope.hasSearched = false;
    };
    $scope.resetTools();

    // Calendar popup
    $scope.dateOptions1 = {
      formatYear: 'yy',
      maxDate: new Date(2020, 5, 22),
      minDate: new Date(),
      startingDay: 1
    };
    $scope.dateOptions2 = {
      formatYear: 'yy',
      maxDate: new Date(2020, 5, 22),
      minDate: $scope.start_date,
      startingDay: 1
    };
    $scope.checkDate = function() {
      $scope.resetTools();
      $scope.dateOptions2.minDate = $scope.start_date;
      if (moment($scope.end_date).diff(moment($scope.start_date)) < 0) {
        $scope.end_date = null;
      }
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
    $scope.getTool = function(id) {
      const currentTool = $scope.tools.find(function(tool) {
        return tool.id === id;
      });
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
    $scope.end_date = new Date();
    $scope.start_date = new Date();
    $scope.category = 'all';
    $scope.keyword = '';
    $scope.power_source = null;
    $scope.sub_type = null;
    $scope.categories = [];
    $scope.power_sources = [];
    $scope.sub_types = [];

    $scope.getCategories = function() {
      $http({
        method: 'GET',
        url: '/categories'
      }).then(function successCallback(response) {
        console.log(response.data);
        $scope.categories = response.data.data.data;
        //$scope.category = $scope.categories[0];
      }, function errorCallback(response) {
        $scope.error = response.message;
      });
    };

    $scope.getPowerSources = function() {
      if ($scope.category === 'all') {
        $scope.power_sources = [];
        $scope.sub_types = [];
      } else {
        $scope.power_source = null;
        $scope.sub_type = null;
        const category = $scope.categories.find(function(category) {
          return category.name == $scope.category;
        });
        $http({
          method: 'GET',
          url: '/powersources/' + category.id
        }).then(function successCallback(response) {
          console.log(response.data);
          $scope.power_sources = response.data.data.data;
          $scope.power_source = $scope.power_sources[0];
          $scope.getSubtypes();
        }, function errorCallback(response) {
          $scope.error = response.message;
        });
      }
    };

    $scope.getSubtypes = function() {
      $scope.sub_type = null;
      if ($scope.power_source && $scope.category) {
        const category = $scope.categories.find(function(category) {
          return category.name == $scope.category;
        });
        $http({
          method: 'GET',
          url: '/subtypes/' + category.id + '/' + $scope.power_source.id
        }).then(function successCallback(response) {
          console.log(response.data);
          $scope.sub_types = response.data.data.data;
          $scope.sub_type = $scope.sub_types[0];
        }, function errorCallback(response) {
          $scope.error = response.message;
        });
      }

    };

    $scope.getCategories();

    $scope.tool_search = function() {
      $scope.hasSearched = true;
      var params = {
        start_date: moment($scope.start_date).format('YYYY-MM-DD'),
        end_date: moment($scope.end_date).format('YYYY-MM-DD'),
        keyword: $scope.keyword,
        search_type: 'tool_availability',
        type: $scope.category,
        power_source: ($scope.power_source || {}).name,
        sub_type: ($scope.sub_type || {}).name
      };
      $http({ method: 'GET', url: '/tools', params: params })
        .success(function(response) {
          var data = (response.data || {}).tools || [];
          $scope.tools = data.map(function(tool) {
            return ({
              id: tool.id,
              description: tool.description,
              rental_price: tool.rental_price,
              deposit_price: parseFloat(tool.deposit_price),
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

