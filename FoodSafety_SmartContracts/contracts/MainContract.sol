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

    struct Product {
        string productName;
        address productManufacturer;
        address productOwner;
        uint productQuantity;
        address[] fromPath;
        address[] toPath;
        string[] positionPath;
        string[] timePath;
        string[] messagePath;
        string[] maxt;
        string[] mint;
        uint index;
    }

    mapping (uint => Product) private productStructs; //information about the products
    uint[] private productList; // the products' ids
    uint private productCount ; // to keep track of the products ids

    function isProduct(uint _productId) public view returns(bool isIndeed) {
        if (productList.length == 0) {
            return false;
        } 
        return (productList[productStructs[_productId].index] == _productId);
    }

    function insertProduct(string _productName, uint _productQuantity ) public returns(uint index) {
        require(!isProduct(productCount)); 
        productStructs[productCount].productName = _productName;
        productStructs[productCount].productOwner = msg.sender;
        productStructs[productCount].productManufacturer = msg.sender;
        productStructs[productCount].productQuantity = _productQuantity;
        productStructs[productCount].fromPath = new address[](16);
        productStructs[productCount].toPath = new address[](16);
        productStructs[productCount].positionPath = new string[](16);
        productStructs[productCount].timePath = new string[](16);
        productStructs[productCount].messagePath = new string[](16);
        productStructs[productCount].maxt = new string[](16);
        productStructs[productCount].mint = new string[](16);
        productStructs[productCount].index = productList.push(productCount)-1;
        productCount = productCount + 1;
        //LogNewUser(userAddress, userStructs[userAddress].index, _userFullName, _userType, _userBrand, _userAge);
        return productList.length-1;
    }

    function getProduct(uint _productId) public view returns (string _productName, uint _productQuantity, address _productManufacturer, string _productOwnerBrand) {
        require(isProduct(_productId));
        return (productStructs[_productId].productName, productStructs[_productId].productQuantity, productStructs[_productId].productManufacturer, userStructs[productStructs[_productId].productOwner].userBrand) ;
    }

    function getProductCount() public view returns(uint count) {
        return productList.length ;
    }

    function getProductAtIndex(uint index) public view returns(uint productId) {
        return productList[index] ;
    }
    
    function addCheckPoint(uint _productId, address _receiver, string _position, string _time, string _message) public returns(bool success) {
        require(msg.sender == productStructs[_productId].productOwner);
        productStructs[_productId].fromPath.push(msg.sender);
        productStructs[_productId].toPath.push(_receiver);
        productStructs[_productId].positionPath.push(_position);
        productStructs[_productId].timePath.push(_time);
        productStructs[_productId].messagePath.push(_message);
        productStructs[_productId].productOwner = _receiver;
        return true;
    }

    // function getPath(uint _productId) public view returns (Action[]) {
    //     uint length = productStructs[_productId].path.length;
    //     Action[] memory path = new Action[](16);
    //     for (uint i = 0; i < length; i++) {
    //         path[i] = productStructs[_productId].path[i];
    //     }
    //     return path;
    // }

    function getActorsAtIndex(uint _productId, uint index) public view returns(address, address) {
        return (productStructs[_productId].fromPath[index], productStructs[_productId].toPath[index]);
    }

    function getPathAtIndex(uint _productId, uint index) public view returns( string, string, string , string , string ) {
        return ( productStructs[_productId].positionPath[index], productStructs[_productId].timePath[index], productStructs[_productId].maxt[index], productStructs[_productId].mint[index], productStructs[_productId].messagePath[index]);
    }

    function getUserProducts(address userId) public view returns(uint[]) {
        uint[] results;
        for(uint i = 0; i<productList.length;i++) {
            if(productStructs[productList[i]].productOwner == userId) {
                results.push(productList[i]);
            }
        }
        uint[] memory staticArray = new uint[] (results.length);
        for(uint j = 0; j < staticArray.length;j++ ) {
              staticArray[j] = results[j];
        }
        return staticArray;
    }

}
