pragma solidity ^0.4.17;

contract CampaignFactory {
    address[] public deployedCampaigns;

    function createCampaign(uint minimum) public {
        address newCampaign = new Campaign(minimum, msg.sender);
        deployedCampaigns.push(newCampaign);
    }

    function getDeployedCampaigns() public view returns (address[]) {
        return deployedCampaigns;
    }
}

contract Campaign {
    struct Request {
        string description;
        uint value;
        address recipient;
        bool complete;
        uint approvalCount;
        mapping(address => bool) approvals;
    }

    address public manager;
    uint public minimumContribution;
    mapping(address => bool) public approvers;
    uint public approversCount;
    Request[] public requests;

    modifier restricted() {
        require(msg.sender == manager);
        _;
    }

    constructor(uint minimum, address creator) public {
        manager = creator;
        minimumContribution = minimum;
    }

    function contribute() public payable {
        require(msg.value > minimumContribution);

        approvers[msg.sender] = true;
        approversCount++;
    }

    function createRequest(string description, uint value, address recipient) public restricted {
        Request memory newReq = Request({
           description: description,
           value: value,
           recipient: recipient,
           complete: false,
           approvalCount: 0
        });

        requests.push(newReq);
    }

    function approveRequest(uint index) public {
        Request storage theRequest = requests[index];

        require(approvers[msg.sender]);
        require(!theRequest.approvals[msg.sender]);

        theRequest.approvals[msg.sender] = true;
        theRequest.approvalCount++;
    }

    function finalizeRequest(uint index) public restricted {
        Request storage theRequest = requests[index];

        require(theRequest.approvalCount > (approversCount / 2));
        require(!theRequest.complete);

        theRequest.recipient.transfer(theRequest.value);
        theRequest.complete = true;
    }
}
