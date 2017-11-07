'use strict';

angular.module('myApp.clerkReport', ['ngRoute'])

    .config(['$routeProvider', function ($routeProvider) {
        $routeProvider.when('/reports/clerk', {
            templateUrl: 'static/reports/clerkReport.html',
            controller: 'ClerkReport as vm',
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

    .controller('ClerkReport', ['$scope', '$http', 'localStorageService', '$location',
        function ($scope, $http, localStorageService, $location) {
            $scope.view = 'This is a scope variable1';


            var vm = this;
            vm.test = 'lol'
            vm.savedCreds = localStorageService.get('authorizationData');


            vm.hasError = function () {
                return vm.error != null;
            }

        }]);
