'use strict';

function Tool(d) {
    this.id = d[0];
    this.description = d[1];
    this.available = d[2];
    this.rented = d[3];
    this.inrepair = d[4];
    this.forsale = d[5];
    this.sold = d[6];

    this.soldDate = moment(d[7]).format('MM/DD/YY');
    this.forSaleDate = moment(d[8]).format('MM/DD/YY');
    this.inrepairDate = moment(d[9]).format('MM/DD/YY');
    this.rentedDate = moment(d[10]).format('MM/DD/YY');
    this.rentalProfit = d[11];
    this.totalCost = d[12];
    this.totalProfit = d[13];
    this.category = d[14];

    if (this.available === 1) {
        this.status = 'Available';
        this.date = null;
    }

    if (this.rented === 1) {
        this.status = 'Rented';
        this.date = this.rentedDate;
    }

    if (this.inrepair === 1) {
        this.status = 'In Repair';
        this.date = this.inrepairDate;
    }

    if (this.forsale === 1) {
        this.status = 'For Sale';
        this.date = this.forSaleDate;
    }

    if (this.sold === 1) {
        this.status = 'Sold';
        this.date = this.soldDate;
    }
};

angular.module('myApp.toolReport', ['ngRoute'])
    .config(['$routeProvider', function ($routeProvider) {
        $routeProvider.when('/reports/tool', {
            templateUrl: 'static/reports/toolReport.html',
            controller: 'ToolReport as vm',
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

    .controller('ToolReport', ['$scope', '$http', 'localStorageService', '$location',
        function ($scope, $http, localStorageService, $location) {
            $scope.view = 'This is a scope variable1';


            var vm = this;
            vm.test = 'lol'
            vm.savedCreds = localStorageService.get('authorizationData');
            vm.tools = [];
            vm.currentPage = 1;
            vm.maxSize = 1;
            vm.itemsPerPage = 5;
            vm.itemsPerPageOptions = [5, 10, 25, 50, 100, 200]


            vm.hasError = function () {
                return vm.error != null;
            }

            $scope.pageChanged = function () {
                vm.fetchToolReport();
            };

            vm.fetchToolReport = function () {
                $http({
                    method: 'GET',
                    url: '/reports/tool/' + vm.currentPage + '/' + vm.itemsPerPage
                }).then(function successCallback(response) {
                    console.log(response.data);
                    vm.maxSize = response.data.totalsize;
                    vm.tools = response.data.data.map(function (f) {
                        return new Tool(f);
                    });

                }, function errorCallback(response) {
                    vm.error = response.message;
                });
            };

            vm.pageChanged = function () {

            };

            vm.fetchToolReport();

        }]);
