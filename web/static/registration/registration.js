'use strict';

angular.module('myApp.register', ['ngRoute'])

    .config(['$routeProvider', function ($routeProvider) {
        $routeProvider.when('/register', {
            templateUrl: 'static/registration/registration.html',
            controller: 'RegisterCtrl'
        });
    }])

    .controller('RegisterCtrl', ['$scope', '$http', 'localStorageService',
        function ($scope, $http, localStorageService) {
            $scope.view = 'This is a scope variable1';

            var vm = this;
            vm.months = [
                {id: 1, name: "January"},
                {id: 2, name: "February"},
                {id: 3, name: "March"},
                {id: 4, name: "April"},
                {id: 5, name: "May"},
                {id: 6, name: "June"},
                {id: 7, name: "July"},
                {id: 8, name: "August"},
                {id: 9, name: "September"},
                {id: 10, name: "October"},
                {id: 11, name: "November"},
                {id: 12, name: "December"}
            ];

            vm.years = Array.apply(null, {length: 20}).map(function (value, index) {
                return index + 2017;
            });


            vm.username = null;
            vm.password = null;
            vm.loginType = 'customer';
            vm.error = null;

            vm.hasError = function () {
                return vm.error != null;
            }

            vm.canLogin = function () {
                return vm.username != null && vm.password != null;
            };

            vm.login = function () {
                vm.error = null;
                $http.post('/login', {
                    "username": vm.username,
                    "password": vm.password,
                    "type": vm.loginType
                }, {headers: {'Content-Type': 'application/json'}})
                    .success(function (response) {
                        localStorageService.set('authorizationData', {userName: response});
                        console.log('It worked');
                        console.log(response);
                    })
                    .error(function (err, status) {
                        console.log('Error', err, status);
                        if (status == 404) {
                            console.log('FOUND 404');
                        }
                        vm.error = err.message
                    });
            };

            vm.logout = function () {
                localStorageService.remove('authorizationData');
            };


        }]);
