pragma solidity ^0.4.21;

contract Election {
    
    //Structure for Candidates running in election
    struct Candidate { 
        string name;
        uint256 voteCount;
    }
    
    //Structure for Voters voting in election
    struct Voter { //Voter Structure
        bool authorized;
        bool voted;
        uint vote;
    }
    
    //Contract states
    address public owner; //Smart contract owner
    string public electionName;
    mapping( address=> Voter) public voters;  //Voter Ethereum addresses mapped to Voter structure
    Candidate[] public candidates; //Array of candidates running for election
    uint public totalVotes; //Total votes made in election
    
    modifier ownerOnly() { //Ensure functions calling modifier are only run by smart contract owner
        require(msg.sender == owner);
        _;
    }
    
    function Election(string _name) public{
        owner = msg.sender;
        electionName = _name;
    }
    
    function addCandidate(string _name) ownerOnly public{
        candidates.push(Candidate(_name,0));   
    }
    
    //View means constant, function does not change state variables, only read
    //Reading is a free transaction
    function getNumCandidate() public view returns(uint) {
        return candidates.length;
    }
    
    function authorize(address _person) ownerOnly public {
        voters[_person].authorized = true;
    }
    
    function vote(uint _voteIndex) public {
        require(!voters[msg.sender].voted);
        require(voters[msg.sender].authorized);
        
        voters[msg.sender].vote = _voteIndex;
        voters[msg.sender].voted = true;
        
        candidates[_voteIndex].voteCount +=1;
        totalVotes += 1;
    }
    
    //Terminates the smart contract so no further state changes can occur, remaining ETH returned to owner
    function end() ownerOnly public {
        selfdestruct(owner);
    }
    
}
