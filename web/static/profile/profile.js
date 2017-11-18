'use strict';

function ProfileTool(t) {
    this.category = t[0];
    this.powerSource = t[1];
    this.subType = t[2];
    this.subOption = t[3];
};

function Reservation(d) {
    this.id = d[0];
    this.startDate = moment(d[1]).format('MM/DD/YY');
    this.endDate = moment(d[2]).format('MM/DD/YY');
    this.dropOffClerk = d[3];
    this.pickupClerk = d[4];
    this.numDays = d[5];
    this.totalDepositPrice = d[6];
    this.totalRentalPrice = d[7];
    this.tools = d[8].map(function (f) {
        return new ProfileTool(f);
    });
};


angular.module('myApp.profile', ['ngRoute'])

    .config(['$routeProvider', function ($routeProvider) {
        $routeProvider.when('/profile/:username', {
            templateUrl: 'static/profile/profile.html',
            // controller: 'ProfileCtrl',
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

    .controller('ProfileCtrl', ['$scope', '$http', 'localStorageService', '$location', '$routeParams',
        function ($scope, $http, localStorageService, $location, $routeParams) {
            $scope.view = 'This is a scope variable1';

            var savedCreds = localStorageService.get('authorizationData');
            var vm = this;
            vm.username = $routeParams.username;
            vm.loginType = savedCreds.type;
            vm.error = null;
            vm.email = null;
            vm.fullName = null;
            vm.homePhone = null;
            vm.workPhone = null;
            vm.cellPhone = null;
            vm.address = null;

            vm.reservations = [];


            vm.hasError = function () {
                return vm.error != null;
            }

            vm.getUserdata = function () {
                $http({
                    method: 'GET',
                    url: '/customer/' + vm.username
                }).then(function successCallback(response) {
                    console.log(response);
                    var r = response.data.data;
                    if (r) {
                        vm.email = r[0];
                        vm.fullName = r[1] + ' ' + r[2] + ' ' + r[3];
                        vm.homePhone = r[4];
                        vm.workPhone = r[5];
                        vm.cellPhone = r[6];
                        vm.address = r[7];
                    }


                }, function errorCallback(response) {
                    vm.error = response.message;
                });
            };

            vm.getReservationData = function () {
                $http({
                    method: 'GET',
                    url: '/reservations/' + vm.username
                }).then(function successCallback(response) {
                    console.log(response.data);
                    vm.reservations = response.data.data.map(function (f) {
                        return new Reservation(f);
                    });
                    console.log(vm.reservations);

                }, function errorCallback(response) {
                    vm.error = response.message;
                });
            };

            vm.getUserdata();
            vm.getReservationData();


        }]);
