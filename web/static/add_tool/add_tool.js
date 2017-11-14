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

      $scope.category = '';
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

      $scope.subtype = '';
      $scope.suboptions = function (subtype) {
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


    }]);
