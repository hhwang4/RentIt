'use strict';

angular.module('myApp.logout', ['ngRoute'])

    .config(['$routeProvider', function ($routeProvider) {
        $routeProvider.when('/logout', {
            templateUrl: 'static/login/logout.html',
            controller: 'LogoutCtrl'
        });
    }])

    .controller('LogoutCtrl', ['$scope', '$rootScope', '$http', 'localStorageService', '$location',
        function ($scope,$rootScope,  $http, localStorageService, $location) {
        localStorageService.remove('authorizationData');
        $rootScope.links = [];
        $location.path('/login');

    }]);
