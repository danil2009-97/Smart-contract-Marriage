pragma solidity ^0.4.18;

contract Marriage{
    
     /**
     * Declaring variables
     */
	string public marriageStatus;
	string public marriageDate;
    string public ipfsHash;
	string public husbandName;
	string public wifeName;
	address public husbandAddress;
	address public wifeAddress;
	address owner;
	uint contractAmount;
	
	mapping (address => uint256) balanceOf;

	bool public isSigned;
	bool public wifeSigned;
	bool public husbandSigned;

    /**
     * This is the constructor. It is called only once when deploying the
     * contract. We set the variables in it.
     */
	function Marriage(string _marriageStatus, string _marriageDate, string _ipfsHash, 
	string _husbandName, string _wifeName, address _husbandAddress, address _wifeAddress) payable
	{
		marriageStatus = _marriageStatus;
		marriageDate = _marriageDate;
		ipfsHash = _ipfsHash;
		husbandName = _husbandName;
		wifeName = _wifeName;
		husbandAddress = _husbandAddress;
		wifeAddress = _wifeAddress;
		owner = msg.sender;
		contractAmount += msg.value;
	}
	
	/**
     * This is verification that some functions can call only contract's owner 
     */
		modifier onlyOwner() { 
        require(msg.sender == owner);
        _;
    }
	
	/**
     * If couple wants, they can appoint another contract owner, who will
     * regulate their relationships
     */
	function transferOwnership(address newOwner) onlyOwner public {
        owner = newOwner;
    }

    /**
     * This is a marriage contract. It should be signed by both 
     * wife and husband. 
     */
	function signTheContract(){
		if(msg.sender == husbandAddress){
			husbandSigned = true;
			if (wifeSigned == true){
				isSigned = true;
			}
		} 
		if(msg.sender == wifeAddress){
			wifeSigned = true;
			if (husbandSigned == true){
				isSigned = true;
			}
		}
	}
    
    /**
     * This is the function to set wife's and husbands's balance.
     */
    function setBalance (address _input, uint value) onlyOwner returns(uint256){
        require(_input != 0x0);
        balanceOf[_input] = value;
        return value;
    }
    
    /**
     * This is the function to get wife's and husbands's balance.
     */
    function getBalance(address _input) constant returns (uint256){
        return balanceOf[_input];
    }
    
    /**
     * This is the function which divides money in half between husband and wife
     * in case of divorce. Only the one who registered this marriage can call 
     * this function
     */
    function divorce() onlyOwner{
        uint256 allmoney = balanceOf[husbandAddress] + balanceOf[wifeAddress];
        balanceOf[husbandAddress] = allmoney / 2;
        balanceOf[wifeAddress] = allmoney / 2;
    }
    
    /**
     * This is the function that changes the status of relationships.
     */
    function changeStatus(string _status) onlyOwner{
        marriageStatus = _status;
    }
    
    /**
     * Function that change the IPFS of the document. In this case the
     * terms of the contract change and therefore signatures are reset.
     */
    function changeIPFS(string _hash) onlyOwner{
        ipfsHash = _hash;   
        isSigned = false;
    }
    
    /**
     * Fallback function
     * The function without name is the default function that is called whenever anyone sends funds 
     * to a contract
     */
        function () payable{
        contractAmount = msg.value;
        balanceOf[msg.sender] += contractAmount;
    }
}