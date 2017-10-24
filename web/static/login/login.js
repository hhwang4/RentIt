'use strict';

angular.module('myApp.login', ['ngRoute'])

    .config(['$routeProvider', function ($routeProvider) {
        $routeProvider.when('/login', {
            templateUrl: 'static/login/login.html',
            controller: 'LoginCtrl'
        });
    }])

    .controller('LoginCtrl', ['$scope', '$http', 'localStorageService', function ($scope, $http, localStorageService) {
        $scope.view = 'This is a scope variable1';

        var vm = this;
        vm.username = null;
        vm.password = null;
        vm.loginType = 'customer';

        vm.canLogin = function() {
          return vm.username != null &&  vm.password != null;
        };

        vm.login = function () {

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
                });
        };


    }]);
