pragma solidity ^0.4.0;

contract MainContract {

    
    struct userStruct {
        string userFullName;
        string userType;
        string userBrand ;
        uint userAge;
        uint index ;
    }


    mapping (address => userStruct) private userStructs ;
    address[] private userList;

    event LogNewUser   (address indexed userAddress, uint index, string userFullName, string userType, string userBrand, uint userAge);
    event LogUpdateUser(address indexed userAddress, uint index, string userFullName, string userType, string userBrand, uint userAge);
    event LogDeleteUser(address indexed userAddress, uint index);


    function isUser(address userAddress) public view returns(bool isIndeed) {
        if (userList.length == 0) {
            return false;
        } 
        return (userList[userStructs[userAddress].index] == userAddress);
    }


    function insertUser(address userAddress, string _userFullName, string _userType, string _userBrand, uint _userAge) public returns(uint index) {
        require(!isUser(userAddress)); 
        userStructs[userAddress].userFullName = _userFullName;
        userStructs[userAddress].userAge = _userAge;
        userStructs[userAddress].index = userList.push(userAddress)-1;
        LogNewUser(userAddress, userStructs[userAddress].index, _userFullName, _userType, _userBrand, _userAge);
        return userList.length-1;
    }

    function getUser(address userAddress) public view returns (string userFullName, string userType, string userBrand, uint userAge) {
        require(isUser(userAddress));
        return (userStructs[userAddress].userFullName, userStructs[userAddress].userType, userStructs[userAddress].userBrand, userStructs[userAddress].userAge) ;
    }


    function updateUserFullName(address userAddress, string _userFullName) public returns(bool success) {
        require(isUser(userAddress)); 
        userStructs[userAddress].userFullName = _userFullName;
        LogUpdateUser(userAddress, userStructs[userAddress].index, _userFullName, userStructs[userAddress].userType, userStructs[userAddress].userBrand, userStructs[userAddress].userAge);
        return true;
    }

    function updateUserType(address userAddress, string _userType) public returns(bool success) {
        require(isUser(userAddress)); 
        userStructs[userAddress].userType = _userType;
        LogUpdateUser(userAddress, userStructs[userAddress].index, userStructs[userAddress].userFullName, _userType, userStructs[userAddress].userBrand, userStructs[userAddress].userAge);
        return true;
    }

    function updateUserBrand(address userAddress, string _userBrand) public returns(bool success) {
        require(isUser(userAddress)); 
        userStructs[userAddress].userBrand = _userBrand;
        LogUpdateUser(userAddress, userStructs[userAddress].index, userStructs[userAddress].userFullName, userStructs[userAddress].userType, _userBrand, userStructs[userAddress].userAge);
        return true;
    }

    function updateUserAge(address userAddress, uint _userAge) public returns(bool success) {
        require(isUser(userAddress)); 
        userStructs[userAddress].userAge = _userAge;
        LogUpdateUser(userAddress, userStructs[userAddress].index, userStructs[userAddress].userFullName, userStructs[userAddress].userType, userStructs[userAddress].userBrand, _userAge);
        return true;
    }

    function getUserCount() public view returns(uint count) {
        return userList.length ;
    }

    function getUserAtIndex(uint index) public view returns(address userAdress) {
        return userList[index] ;
    }

    function deleteUser(address userAddress) public returns(uint index) {
        require(isUser(userAddress)); 
        uint rowToDelete = userStructs[userAddress].index;
        address keyToMove = userList[userList.length-1];
        userList[rowToDelete] = keyToMove;
        userStructs[keyToMove].index = rowToDelete; 
        userList.length--;
        LogDeleteUser(userAddress, rowToDelete);
        LogUpdateUser(userAddress, userStructs[userAddress].index, userStructs[userAddress].userFullName, userStructs[userAddress].userType, userStructs[userAddress].userBrand, userStructs[userAddress].userAge);
        return rowToDelete;
    }
}