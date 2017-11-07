'use strict';

angular.module('myApp.toolReport', ['ngRoute'])

    .config(['$routeProvider', function ($routeProvider) {
        $routeProvider.when('/reports/tool', {
            templateUrl: 'static/reports/toolReport.html',
            controller: 'ToolReport as vm',
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

    .controller('ToolReport', ['$scope', '$http', 'localStorageService', '$location',
        function ($scope, $http, localStorageService, $location) {
            $scope.view = 'This is a scope variable1';


            var vm = this;
            vm.test = 'lol'
            vm.savedCreds = localStorageService.get('authorizationData');


            vm.hasError = function () {
                return vm.error != null;
            }

        }]);
