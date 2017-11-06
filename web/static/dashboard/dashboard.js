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

    .controller('DashboardCtrl', ['$scope', '$http', 'localStorageService', '$location',
        function ($scope, $http, localStorageService, $location) {
            $scope.view = 'This is a scope variable1';

            var savedCreds = localStorageService.get('authorizationData');
            var vm = this;
            vm.username = savedCreds.username;
            vm.loginType = savedCreds.type;
            vm.error = null;

//         -Customer Registration (mike)
// -Login (mike)
// -View Profile (mike)
// -Make reservation (david)
// -Check Tool Availability (yasmine)
// From the "Clerk Main Menu" (figure 11)
// -Picking up reservations (david)
// -Dropping off reservations (david)
// -Add New Tool (haohao)
// -Generate Reports (mike)

            vm.links = [
                {name: 'View Profile', url: '/#!/profile'},
                {name: 'Make reservation', url: '/#!/make_reservation'},
                {name: 'Check tool Availability', url: '/#!/toolavil'},
                {name: 'Logout', url: '/#!/logout'},
            ]


            vm.hasError = function () {
                return vm.error != null;
            }

        }]);
