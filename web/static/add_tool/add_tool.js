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
      $scope.subtypes = function(category) {
        if ($scope.category == 'handTool') {
          return ['Screwdriver', 'Socket', 'Ratchet', 'Wrench', 'Pliers', 'Gun', 'Hammer']
        } else if ($scope.category == 'gardenTool') {
          return ['Digger','Pruner','Rakes', 'Wheelbarrows', 'Striking']
        } else if ($scope.category == 'ladderTool') {
          return ['Straight', 'Step']
        } else {
          return ['Drill', 'Saw', 'Sander','AirCompressor', 'Mixer', 'Generator']
        }
      };

      $scope.suboptions = function () {
        if ($scope.subtype == 'Screwdriver') {
          return ['philips(cross)', 'hex', 'torx', 'slotted(flat)']
        } else if ($scope.subtype == 'Socket') {
          return ['deep','standard']
        }else if ($scope.subtype == 'Ratchet') {
          return ['adjustable','fixed']
        } else if ($scope.subtype == 'Wrench') {
          return ['crescent','torque', 'pipe']
        }else if ($scope.subtype == 'Pliers') {
          return ['needle nose','cutting', 'crimper']
        }else if ($scope.subtype == 'Socket') {
          return ['nail','staple']
        }else if ($scope.subtype == 'Gun') {
          return ['nail','staple']
        }else if ($scope.subtype == 'Hammer') {
          return ['claw','sledge', 'framing']
        }else if ($scope.subtype == 'Digger') {
          return ['pointed shovel','flat shovel', 'scoop shovel', 'edger']
        }else if ($scope.subtype == 'Pruner') {
          return ['sheer','loppers', 'hedge']
        }else if ($scope.subtype == 'Rakes') {
          return ['leaf','landscaping', 'rock']
        }else if ($scope.subtype == 'Wheelbarrows') {
          return ['1-wheel','2-wheel']
        }else if ($scope.subtype == 'Striking') {
          return ['bar pry','rubber mallet', 'tamper', 'pick axe', 'single bit axe']
        }else if ($scope.subtype == 'Straight') {
          return ['rigid','telescoping']
        }else if ($scope.subtype == 'Step') {
          return ['folding','multi-position']
        }else if ($scope.subtype == 'Drill') {
          return ['driver','hammer']
        }else if ($scope.subtype == 'Saw') {
          return ['circular','reciprocating', 'jig']
        }else if ($scope.subtype == 'Sander') {
          return ['finish','sheet', 'belt', 'random orbital']
        }else if ($scope.subtype == 'AirCompressor') {
          return ['reciprocating']
        }else if ($scope.subtype == 'Mixer') {
          return ['concrete']
        }else {
          return ['electric']
        }
      };

      $scope.powertoolassessories = function () {
        return ['Drill Bits', 'Soft Case', 'Hard Case', 'D/C Batteries', 'D/C Battery Charge', 'Safety Hat',
                'Safety Pants', 'Safety Goggles', 'Safety Vest', 'Hose', 'Gas Tank'];
      };


      $scope.powersources = function () {
          if ($scope.category == 'handTool' || $scope.category == 'gardenTool' || $scope.category == 'ladderTool') {
            return ['Manual'];
          }else if (($scope.category == 'powerTool' && $scope.subtype == 'Drill')
                    || ($scope.category == 'powerTool' && $scope.subtype == 'Saw')
                    || ($scope.category == 'powerTool' && $scope.subtype == 'Sander')) {
            return ['A/C', 'D/C']
          } else if (($scope.category == 'powerTool' && $scope.subtype == 'AirCompressor')
                    || ($scope.category == 'powerTool' && $scope.subtype == 'Mixer')) {
            return ['A/C', 'Gas']
          } else if ($scope.category == 'powerTool' && $scope.subtype == 'Generator') {
            return ['Gas']
          }
      };



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
