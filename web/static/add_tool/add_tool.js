'use strict';

angular.module('myApp.addtool', ['ngRoute'])

    .config(['$routeProvider', function ($routeProvider) {
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



      $scope.powertoolassessories = function () {
        return ['Drill Bits', 'Soft Case', 'Hard Case', 'D/C Batteries', 'D/C Battery Charge', 'Safety Hat',
                'Safety Pants', 'Safety Goggles', 'Safety Vest', 'Hose', 'Gas Tank'];
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
        if($scope.powersource && $scope.category){
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
       if($scope.powersource && $scope.category && $scope.subtype) {
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
        var data = {
            "category": $scope.category,
            "powerAccessories": $scope.poweraccessories,
            "accessoryDescription": $scope.accessory_description,
            "sub_type": $scope.subtype,
            "sub_option": $scope.suboption,
            "purchasePrice": $scope.purchaseprice,
            "manufacturer": $scope.manufacturer,
            "power_source": $scope.powersource,
            "material": $scope.material,
            "weight": $scope.weight,
            "width": $scope.width,
            "length": $scope.length,
            "handle_material": $scope.garden_handlematerial,
            "amp_rating": $scope.power_amprating,
            "min_rpm_rating": $scope.power_minrpm,
            "max_rpm_rating": $scope.power_maxrpm,
            "step_count": $scope.ladder_stepcount,
            "weight_capacity": $scope.ladder_weightcapacity,
            "screw_size": $scope.screwdriver_drivesize,
            "socket_size": $scope.socket_drivesize,
            "socket_sae_size": $scope.socket_saesize,
            "rachet_drive_size": $scope.rachet_drivesize,
            "wrench_drive_size": $scope.wrench_drivesize,
            "pliers_adjustable": $scope.pliers_adjustable,
            "gun_gauge_rating": $scope.handgun_gaugerating,
            "gun_capacity": $scope.handgun_capacity,
            "hammer_anti_vibration": $scope.hammer_antivibration,
            "pruner_blade_material": $scope.pruner_bladematerial,
            "pruner_blade_length": $scope.pruner_bladelength,
            "striking_head_weight": $scope.striking_headweight,
            "digger_blade_width": $scope.digger_bladewidth,
            "digger_blade_length": $scope.digger_bladelength,
            "rakes_tine_count": $scope.rakes_tinecount,
            "wheelbarrow_bin_material": $scope.wheelbarrow_binmaterial,
            "wheelbarrow_wheel_count": $scope.wheelbarrow_wheelcount,
            "wheelbarrow_bin_volume": $scope.wheelbarrow_binmvolume,
            "drill_adjustable_clutch": $scope.drill_adjustableclutch,
            "drill_min_torque_rating": $scope.drill_mintorque,
            "drill_max_torque_rating": $scope.drill_maxtorque,
            "saw_blade_size": $scope.saw_bladesize,
            "sander_dust_bag": $scope.sander_dustbag,
            "ac_tank_size": $scope.aircompressor_tanksize,
            "ac_pressure_rating": $scope.aircompressor_pressurerating,
            "mixer_motor_rating": $scope.mixer_motorrating,
            "mixer_drum_size": $scope.mixer_drumsize,
            "generator_power_rating": $scope.generator_powerrating,
            "straight_rubber_feet": $scope.straight_rubberfeet,
            "step_pail_shelf": $scope.step_pailshelf
        };

        console.log("Data", data);

        $http.post('/addtool', data, {headers: {'Content-Type': 'application/json'}})
            .success(function (response) {
              $location.path('/addtool');
            })
            .error(function (err, status) {
                console.log('Error', err, status);
            });
        };

    }]);
