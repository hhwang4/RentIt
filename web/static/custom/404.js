'use strict';

angular.module('myApp.404', ['ngRoute'])

    .config(['$routeProvider', function ($routeProvider) {
        $routeProvider.when('/404', {
            templateUrl: 'static/custom/404.html',
            controller: '404Ctrl'
        });
    }])

    .controller('404Ctrl', ['$scope',
        function ($scope) {

        }]);
