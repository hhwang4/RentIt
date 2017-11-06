'use strict';

angular.module('myApp.register', ['ngRoute'])

    .config(['$routeProvider', function ($routeProvider) {
        $routeProvider.when('/register', {
            templateUrl: 'static/registration/registration.html',
            controller: 'RegisterCtrl'
        });
    }])

    .controller('RegisterCtrl', ['$scope', '$http', 'localStorageService',
        function ($scope, $http, localStorageService) {
            $scope.view = 'This is a scope variable1';

            var vm = this;
            vm.months = [
                {id: 1, name: "January"},
                {id: 2, name: "February"},
                {id: 3, name: "March"},
                {id: 4, name: "April"},
                {id: 5, name: "May"},
                {id: 6, name: "June"},
                {id: 7, name: "July"},
                {id: 8, name: "August"},
                {id: 9, name: "September"},
                {id: 10, name: "October"},
                {id: 11, name: "November"},
                {id: 12, name: "December"}
            ];

            vm.years = Array.apply(null, {length: 20}).map(function (value, index) {
                return index + 2017;
            });


            vm.userName = null;
            vm.firstName = null;
            vm.middleName = null;
            vm.lastName = null;
            vm.homePhone = null;
            vm.homePhoneAreaCode = null;
            vm.homePhoneExt = null;
            vm.workPhone = null;
            vm.workPhoneAreaCode = null;
            vm.workPhoneExt = null;
            vm.cellPhone = null;
            vm.cellPhoneAreaCode = null;
            vm.cellPhoneExt = null;
            vm.primaryPhone = 'home';
            vm.email = null;
            vm.password = null;
            vm.repassword = null;
            vm.address = null;
            vm.city = null;
            vm.state = "AL";
            vm.zip = null;
            vm.cardName = null;
            vm.cardNumber = null;
            vm.expirationMonth = {id: 1};
            vm.expirationYear = 2017;
            vm.cvc = null;
            vm.id = null;

            vm.error = null;

            vm.hasError = function () {
                return vm.error != null;
            }

            vm.register = function () {
                vm.error = null;
                var data = {
                    "id": vm.id,
                    "userName": vm.userName,
                    "firstName": vm.firstName,
                    "middleName": vm.middleName,
                    "lastName": vm.lastName,
                    "primaryPhone": vm.primaryPhone,
                    "homePhone": vm.homePhone,
                    "homePhoneAreaCode": vm.homePhoneAreaCode,
                    "homePhoneExt": vm.homePhoneExt,
                    "workPhone": vm.workPhone,
                    "workPhoneAreaCode": vm.workPhoneAreaCode,
                    "workPhoneExt": vm.workPhoneExt,
                    "cellPhone": vm.cellPhone,
                    "cellPhoneAreaCode": vm.cellPhoneAreaCode,
                    "cellPhoneExt": vm.cellPhoneExt,
                    "email": vm.email,
                    "password": vm.password,
                    "repassword": vm.repassword,
                    "address": vm.address,
                    "city": vm.city,
                    "state": vm.state,
                    "zip": vm.zip,
                    "cardName": vm.cardName,
                    "cardNumber": vm.cardNumber,
                    "expirationMonth": vm.expirationMonth.id,
                    "expirationYear": vm.expirationYear,
                    "cvc": vm.cvc
                };

                console.log("Data", data);
                $http.post('/register', data, {headers: {'Content-Type': 'application/json'}})
                    .success(function (response) {

                        localStorageService.set('authorizationData', {username: vm.userName, type: 'customer'});
                        $location.path('/dashboard');
                    })
                    .error(function (err, status) {
                        console.log('Error', err, status);
                        vm.error = err.message
                    });
            };

            vm.logout = function () {
                localStorageService.remove('authorizationData');
            };

            vm.logout();

        }]);
