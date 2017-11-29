'use strict';

function Clerk(d) {
    this.firstName = d[0];
    this.middleName = d[1];
    this.lastName = d[2];
    this.email = d[3];
    this.hireDate = moment(d[4]).format('MM/DD/YY');
    this.id = d[5];
    this.numPickups = d[6];
    this.numDropoffs = d[7];
    this.combinedTotal = d[8];
};

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
            // Sorting
            $scope.propertyName = 'combinedTotal'; // "ordered by the total number of pick-ups and drop-offs"
            $scope.reverse = false;
            $scope.sortBy = function(propertyName) {
                $scope.reverse = ($scope.propertyName === propertyName) ? !$scope.reverse : false;
                $scope.propertyName = propertyName;
            };

            var vm = this;
            vm.test = 'lol'
            vm.savedCreds = localStorageService.get('authorizationData');
            vm.year = moment().format('YYYY');
            vm.month = moment().format('MM');

            vm.clerks = [];

            vm.hasError = function () {
                return vm.error != null;
            }

            vm.fetchClerkReport = function() {
                $http({
                    method: 'GET',
                    url: '/reports/clerk/' + vm.year + '/' + vm.month
                }).then(function successCallback(response) {
                    console.log(response.data);
                    vm.clerks = response.data.data.map(function (f) {
                        return new Clerk(f);
                    });

                }, function errorCallback(response) {
                    vm.error = response.message;
                });
            };

            vm.fetchClerkReport();

        }]);
