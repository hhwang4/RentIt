'use strict';

angular.module('myApp.login', ['ngRoute'])
    .config(['$routeProvider', function ($routeProvider) {
        $routeProvider.when('/login', {
            templateUrl: 'static/login/login.html',
            controller: 'LoginCtrl'
        });
    }])

    .controller('LoginCtrl', ['$scope', '$rootScope', '$http', 'localStorageService', '$location',
        function ($scope, $rootScope, $http, localStorageService, $location) {
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
            vm.logout();
            $http.post('/login', {
                "username": vm.username,
                "password": vm.password,
                "type": vm.loginType
            }, {headers: {'Content-Type': 'application/json'}})
                .success(function (response) {
                    localStorageService.set('authorizationData', response);
                    $location.path('/dashboard');
                })
                .error(function (err, status) {
                    console.log('Error', err, status);
                    if(status == 404 && err.type == 'customer') {
                        console.log('FOUND 404');
                        alert(err.message + '. ' + 'Please register as a new customer!');
                        $location.path('/register')
                    }
                    vm.error = err.message
                });
        };

        vm.logout = function () {
            localStorageService.remove('authorizationData');
        };


    }]);
