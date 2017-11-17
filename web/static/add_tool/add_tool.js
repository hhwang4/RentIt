'use strict';

angular.module('myApp.addtool', ['ngRoute'])

  .config(['$routeProvider', function($routeProvider) {
    $routeProvider.when('/add_tool', {
      templateUrl: 'static/add_tool/add_tool.html',
      controller: 'AddToolCtrl'
    });
  }])

  .controller('AddToolCtrl', ['$scope', '$http', 'localStorageService', '$uibModal',
    function($scope, $http, localStorageService, $uibModal) {
      //var vm = this;
      $scope.category = null;
      $scope.powersource = null;
      $scope.categories = [];
      $scope.powersources = [];
      $scope.subtype = null;
      $scope.suboption = null;
      $scope.subtypes = [];
      $scope.suboptions = [];
      $scope.error = null;

      $scope.toolobject = {};

      $scope.purchaseprice;
      $scope.manufacturer;
      $scope.material;
      $scope.weight;
      $scope.width;
      $scope.length;
      $scope.toolobject.garden_handlematerial;
      $scope.toolobject.power_amprating;
      $scope.toolobject.power_minrpm;
      $scope.toolobject.power_maxrpm;
      $scope.toolobject.ladder_stepcount;
      $scope.toolobject.ladder_weightcapacity;
      $scope.toolobject.screwdriver_drivesize;
      $scope.toolobject.socket_drivesize;
      $scope.toolobject.socket_saesize;
      $scope.toolobject.rachet_drivesize;
      $scope.toolobject.wrench_drivesize;
      $scope.toolobject.pliers_adjustable;
      $scope.toolobject.handgun_gaugerating;
      $scope.toolobject.handgun_capacity;
      $scope.toolobject.hammer_antivibration;
      $scope.toolobject.pruner_bladematerial;
      $scope.toolobject.pruner_bladelength;
      $scope.toolobject.striking_headweight;
      $scope.toolobject.digger_bladewidth;
      $scope.toolobject.digger_bladelength;
      $scope.toolobject.rakes_tinecount;
      $scope.toolobject.wheelbarrow_binmaterial;
      $scope.toolobject.wheelbarrow_wheelcount;
      $scope.toolobject.wheelbarrow_binmvolume;
      $scope.toolobject.drill_adjustableclutch;
      $scope.toolobject.drill_mintorque;
      $scope.toolobject.drill_maxtorque;
      $scope.toolobject.saw_bladesize;
      $scope.toolobject.sander_dustbag;
      $scope.toolobject.aircompressor_tanksize;
      $scope.toolobject.aircompressor_pressurerating;
      $scope.toolobject.mixer_motorrating;
      $scope.toolobject.mixer_drumsize;
      $scope.toolobject.generator_powerrating;
      $scope.toolobject.straight_rubberfeet;
      $scope.toolobject.step_pailshelf;
      $scope.toolobject.get_voltrating;

      $scope.accessories = [];

      $scope.add_accessory = function() {
        $scope.accessories.push({
          desc: '',
          quantity: ''
        });
      };

      $scope.fractions = [{
          name: "0",
          value: 0
        },
        {
          name: "1/8",
          value: 0.125
        },
        {
          name: "1/4",
          value: 0.25
        },
        {
          name: "3/8",
          value: 0.375
        },
        {
          name: "1/2",
          value: 0.5
        },
        {
          name: "5/8",
          value: 0.625
        },
        {
          name: "3/4",
          value: 0.75
        },
      ];

      $scope.accessory_description = function() {
        return ['Drill Bits', 'Soft Case', 'Hard Case', 'D/C Batteries', 'D/C Battery Charge', 'Safety Hat',
          'Safety Pants', 'Safety Goggles', 'Safety Vest', 'Hose', 'Gas Tank'
        ];
      };

      $scope.get_voltrating = function() {
        return ['110', '120', '220', '240'];
      };

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
        $scope.powersource = null;
        $scope.subtype = null;
        $scope.suboption = null;
        $http({
          method: 'GET',
          url: '/powersources/' + $scope.category.id
        }).then(function successCallback(response) {
          console.log(response.data);
          $scope.powersources = response.data.data.data;
          //$scope.powersource = $scope.powersources[0];
        }, function errorCallback(response) {
          $scope.error = response.message;
        });
      };

      $scope.getSubtypes = function() {
        $scope.subtype = null;
        $scope.suboption = null;
        if ($scope.powersource && $scope.category) {
          $http({
            method: 'GET',
            url: '/subtypes/' + $scope.category.id + '/' + $scope.powersource.id
          }).then(function successCallback(response) {
            console.log(response.data);
            $scope.subtypes = response.data.data.data;
            //$scope.subtype = $scope.subtypes[0];
          }, function errorCallback(response) {
            $scope.error = response.message;
          });
        }

      };

      $scope.getSuboptions = function() {
        if ($scope.powersource && $scope.category && $scope.subtype) {
          $http({
            method: 'GET',
            url: '/suboptions/' + $scope.category.id + '/' + $scope.powersource.id + '/' + $scope.subtype.id
          }).then(function successCallback(response) {
            console.log(response.data);
            $scope.suboptions = response.data.data.data;
            //$scope.suboption = $scope.suboptions[0];
          }, function errorCallback(response) {
            $scope.error = response.message;
          });
        }
      };

      $scope.getCategories();

      $scope.addtools = function() {
        $scope.error = null;

        var width = parseFloat($scope.width) + $scope.widthfraction;
        if ($scope.widthunit === "ft") {
          width *= 12;
        }

        var length = parseFloat($scope.length) + $scope.lengthfraction;
        if ($scope.lengthunit === "ft") {
          length *= 12;
        }

        var data = {
          "category": $scope.category,
          "accessories": $scope.accessories,
          "sub_type": $scope.subtype,
          "sub_option": $scope.suboption,
          "original_price": $scope.purchaseprice,
          "manufacturer": $scope.manufacturer,
          "power_source": $scope.powersource,
          "material": $scope.material,
          "weight": $scope.weight,
          "width": width,
          "length": length,
          "handle_material": $scope.toolobject.garden_handlematerial,
          "amp_rating": $scope.toolobject.power_amprating,
          "min_rpm_rating": $scope.toolobject.power_minrpm,
          "max_rpm_rating": $scope.toolobject.power_maxrpm,
          "step_count": $scope.toolobject.ladder_stepcount,
          "weight_capacity": $scope.toolobject.ladder_weightcapacity,
          "screw_size": $scope.toolobject.screwdriver_drivesize,
          "socket_drive_size": $scope.toolobject.socket_drivesize,
          "socket_sae_size": $scope.toolobject.socket_saesize,
          "rachet_drive_size": $scope.toolobject.rachet_drivesize,
          "wrench_drive_size": $scope.toolobject.wrench_drivesize,
          "pliers_adjustable": $scope.toolobject.pliers_adjustable,
          "gun_gauge_rating": $scope.toolobject.handgun_gaugerating,
          "gun_capacity": $scope.toolobject.handgun_capacity,
          "hammer_anti_vibration": $scope.toolobject.hammer_antivibration,
          "pruner_blade_material": $scope.toolobject.pruner_bladematerial,
          "pruner_blade_length": $scope.toolobject.pruner_bladelength,
          "striking_head_weight": $scope.toolobject.striking_headweight,
          "digger_blade_width": $scope.toolobject.digger_bladewidth,
          "digger_blade_length": $scope.toolobject.digger_bladelength,
          "rakes_tine_count": $scope.toolobject.rakes_tinecount,
          "wheelbarrow_bin_material": $scope.toolobject.wheelbarrow_binmaterial,
          "wheelbarrow_wheel_count": $scope.toolobject.wheelbarrow_wheelcount,
          "wheelbarrow_bin_volume": $scope.toolobject.wheelbarrow_binmvolume,
          "power_volt_rating": $scope.toolobject.power_voltrating,
          "power_amp_rating": $scope.toolobject.power_amprating,
          "power_min_rpm_rating": $scope.toolobject.power_minrpm,
          "power_max_rpm_rating": $scope.toolobject.power_maxrpm,
          "drill_adjustable_clutch": $scope.toolobject.drill_adjustableclutch,
          "drill_min_torque_rating": $scope.toolobject.drill_mintorque,
          "drill_max_torque_rating": $scope.toolobject.drill_maxtorque,
          "saw_blade_size": $scope.toolobject.saw_bladesize,
          "sander_dust_bag": $scope.toolobject.sander_dustbag,
          "ac_tank_size": $scope.toolobject.aircompressor_tanksize,
          "ac_pressure_rating": $scope.toolobject.aircompressor_pressurerating,
          "mixer_motor_rating": $scope.toolobject.mixer_motorrating,
          "mixer_drum_size": $scope.toolobject.mixer_drumsize,
          "generator_power_rating": $scope.toolobject.generator_powerrating,
          "straight_rubber_feet": $scope.toolobject.straight_rubberfeet,
          "step_pail_shelf": $scope.toolobject.step_pailshelf
        };


        console.log("Data", data);

        $http.post('/addtool', data, {
            headers: {
              'Content-Type': 'application/json'
            }
          })
          .success(function(response) {
            //$location.path('/addtool');
            alert('Tool was successfully Added!');
          })
          .error(function(err, status) {
            console.log('Error', err, status);
          });
      };

    }
  ]);
