'use strict';

angular.module('myApp.login', ['ngRoute'])

    .config(['$routeProvider', function ($routeProvider) {
        $routeProvider.when('/login', {
            templateUrl: 'static/login/login.html',
            controller: 'LoginCtrl'
        });
    }])

    .controller('LoginCtrl', ['$scope', '$http', 'localStorageService',
        function ($scope, $http, localStorageService) {
        $scope.view = 'This is a scope variable1';

        var vm = this;
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
            $http.post('/customer/login', {
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
                    vm.error = err.message
                });
        };

        vm.logout = function () {
            localStorageService.remove('authorizationData');
        };


    }]);
