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
    this.totalRented = d[8];
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
            $scope.view = 'This is a scope variable1';


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
