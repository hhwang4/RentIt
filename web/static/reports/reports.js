'use strict';

angular.module('myApp.reports', ['ngRoute'])

    .config(['$routeProvider', function ($routeProvider) {
        $routeProvider.when('/reports', {
            templateUrl: 'static/reports/reports.html',
            controller: 'ReportsCtrl as vm',
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

    .controller('ReportsCtrl', ['$scope', '$http', 'localStorageService', '$location',
        function ($scope, $http, localStorageService, $location) {
            $scope.view = 'This is a scope variable1';


            var vm = this;
            vm.test = 'lol'
            vm.savedCreds = localStorageService.get('authorizationData');


            vm.links = [
                {name: 'Clerk Report', url: '/#!/reports/clerk'},
                {name: 'Customer Report', url: '/#!/reports/customer'},
                {name: 'Tool Inventory Report', url: '/#!/reports/tool'}
            ]




            vm.hasError = function () {
                return vm.error != null;
            }

        }]);
