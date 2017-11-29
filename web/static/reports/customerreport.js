'use strict';
function Customer(d) {
    this.id = d[0];
    this.firstName = d[1];
    this.middleName = d[2];
    this.lastName = d[3];
    this.email = d[4];
    this.userName = d[5];
    this.phone = d[6];
    this.totalReservations = d[7];
    this.totalRented = parseFloat(d[8]);
};
angular.module('myApp.customerReport', ['ngRoute'])

    .config(['$routeProvider', function ($routeProvider) {
        $routeProvider.when('/reports/customer', {
            templateUrl: 'static/reports/customerReport.html',
            controller: 'CustomerReport as vm',
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

    .controller('CustomerReport', ['$scope', '$http', 'localStorageService', '$location',
        function ($scope, $http, localStorageService, $location) {
            // Sorting
            $scope.propertyName = ['totalRented', 'lastName']; // "ordered first by number of tools rented, then last name of the customer"
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

            vm.customers = [];

            vm.hasError = function () {
                return vm.error != null;
            }

            vm.fetchCustomerReport = function () {
                $http({
                    method: 'GET',
                    url: '/reports/customer/' + vm.year + '/' + vm.month
                }).then(function successCallback(response) {
                    console.log(response.data);
                    vm.customers = response.data.data.map(function (f) {
                        return new Customer(f);
                    });

                }, function errorCallback(response) {
                    vm.error = response.message;
                });
            };

            vm.fetchCustomerReport();

        }]);
