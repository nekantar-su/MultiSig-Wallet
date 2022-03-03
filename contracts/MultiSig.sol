pragma solidity 0.8.11;
pragma abicoder v2;
contract MulitSig{

    address [] owners;
    uint256 approvalsNeeded;
    //Set Transaction to done when finished
    enum status{NOTDONE,DONE}

    struct Transaction{
        address to;
        uint256 amount;
        uint256 txId;
        status txStatus;
    }
    //Holds array of all transactions, array length will result in Transaction Id
    Transaction [] pendingTrans;
    mapping(address => mapping(uint256 => bool)) hasApproved;
    // TransactionId to Aprovalcount to keep track
    mapping(uint256 => uint256) aprovalConfirmed;
    //Read in number of approvals and list of owners
    constructor(uint256 _number, address [] memory _owners){
        require(_number <= _owners.length + 1,"Cant have more approvals than owners");
         approvalsNeeded = _number;
        owners = _owners;
        owners.push(msg.sender);
    }
    modifier onlyOwner{
        require(isOwner(msg.sender)==true,"You are not an owner");
        _;
    }

    //push transaction to array only owners can do this
    function startTransaction(address _to, uint256 _amount) public onlyOwner{
        require(address(this).balance >= _amount,"Not enough balance for this transaction");
            pendingTrans.push(Transaction(_to,_amount,pendingTrans.length,status.NOTDONE));
    }
    //approve a transaction
    function approve(uint256 _txId)public onlyOwner{
        require(pendingTrans.length != 0, "There are no transactions yet");
        require(_txId < pendingTrans.length, "This transaction does not exist");
        require(pendingTrans[_txId].txStatus == status.NOTDONE ,"The transaction has procced already");
        require(hasApproved[msg.sender][_txId] == false,"You have approved this already");
        //set user to approved and increase a approval
        hasApproved[msg.sender][_txId] = true;
        aprovalConfirmed[_txId]+=1;
        //if transactionid approval number is equal to amount of approvals set trasnsaction to done and transfer funds
         if(aprovalConfirmed[_txId] == approvalsNeeded){
        _transfer(pendingTrans[_txId].to,pendingTrans[_txId].amount);
        pendingTrans[_txId].txStatus = status.DONE;
        }
    }
    function viewTransaction(uint256 _txId)public view returns(Transaction memory){
        require(pendingTrans.length > _txId);
        return pendingTrans[_txId];
    }

    function _transfer(address _to, uint256 _amount)internal{
        payable(_to).transfer(_amount);
    }


    //Empty payable function
    function deposit() payable public {}

    //function to ensure an address is an owner
    function isOwner(address _addy) internal view returns(bool){
        for(uint i = 0; i < owners.length;i++){
            if(_addy == owners[i]){
                return true;
            }
        }
        return false;
            
            }

}