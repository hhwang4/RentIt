'use strict';

angular.module('myApp.dashboard', ['ngRoute'])

    .config(['$routeProvider', function ($routeProvider) {
        $routeProvider.when('/dashboard', {
            templateUrl: 'static/dashboard/dashboard.html',
            controller: 'DashboardCtrl',
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

    .controller('DashboardCtrl', ['$scope', '$rootScope', '$http', 'localStorageService', '$location',
        function ($scope, $rootScope, $http, localStorageService, $location) {
            $scope.view = 'This is a scope variable1';

            var savedCreds = localStorageService.get('authorizationData');
            var vm = this;
            vm.username = savedCreds.username;
            vm.loginType = savedCreds.type;
            vm.error = null;


            vm.links = [
                {name: 'View Profile', url: '/#!/profile/'+vm.username},
                {name: 'Make reservation', url: '/#!/make_reservation'},
                {name: 'Check tool Availability', url: '/#!/tool_availability'},
                {name: 'Logout', url: '/#!/logout'},
            ];

            if(vm.loginType == 'clerk') {
                vm.links = [
                {name: 'Pick up Reservations', url: '/#!/pickup_reservation'},
                {name: 'Drop off Reservations', url: '/#!/dropoff_reservation'},
                {name: 'Add new tool', url: '/#!/add_tool'},
                {name: 'Generate Reports', url: '/#!/reports'},
                {name: 'Logout', url: '/#!/logout'}
            ];
            }

            if(vm.loginType == 'clerk') {
                        $rootScope.links = [
                        {name: 'Dashboard', url: '/#!/dashboard'},
                        {name: 'Pick up Reservations', url: '/#!/pickup_reservation'},
                        {name: 'Drop off Reservations', url: '/#!/dropoff_reservation'},
                        {name: 'Add new tool', url: '/#!/add_tool'},
                        {name: 'Generate Reports', url: '/#!/reports'},
                        {name: 'Logout', url: '/#!/logout'}
                        ];
                    }
                    else {
                        $rootScope.links = [
                            {name: 'Dashboard', url: '/#!/dashboard'},
                            {name: 'View Profile', url: '/#!/profile/'+ vm.username},
                            {name: 'Make reservation', url: '/#!/make_reservation'},
                            {name: 'Check tool Availability', url: '/#!/tool_availability'},
                            {name: 'Logout', url: '/#!/logout'},
                        ];
                    }


            vm.hasError = function () {
                return vm.error != null;
            }

        }]);
