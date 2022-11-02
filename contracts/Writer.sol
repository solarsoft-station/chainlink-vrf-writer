//SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import "./Topic.sol";

contract Writer{

    //storage variables
    address[] public s_topics;
    address payable public immutable i_Writer;
    mapping(address => address[]) public walletToTopicOwned;
    mapping(address => uint256[]) public hasTopic;
    mapping(address => uint256) public topicToId;

    uint256 public immutable i_percentCut;
    uint256 public s_nextTopicId;
    uint256 public s_maxTopicPerUser;

    error Writer__Unauthorized();
    error Writer__AlreadyAtMaxTopic();
    error Writer__ErrorWithdrawing();
    error Writer__ErrorDeleting();

    event TopicCreated(address indexed topicAddress);
    event DonationReceived(uint256 indexed amount);
    event WithdrawalMade(uint256 indexed amount);
    event TopicDeleted(address indexed topicAddress, bool deleted);

    modifier onlyOwner(){
        if (msg.sender != i_Writer){
        revert Writer__Unauthorized();
        }
        _;
    }

    constructor(uint256 percentCut) {
        i_Writer = payable(msg.sender);
        i_percentCut = percentCut;
        s_nextTopicId = 0;
    } 

    receive() external payable {
        sponsorSite();
    }

    fallback() external payable {
        sponsorSite();
    }

    function createTopic(string memory topicName, uint256 maxPostPerWriter) public returns(address){
        if (hasTopic[msg.sender].length >= s_maxTopicPerUser){
            revert Writer__AlreadyAtMaxTopic();
        }
        Topic newTopic = new Topic(
            topicName,
            maxPostPerWriter,
            payable(msg.sender),
            i_percentCut,
            s_nextTopicId
        );
        //newTopic.unlock()
        s_topics.push(address(newTopic));
        walletToTopicOwned[msg.sender].push(address(newTopic));
        hasTopic[msg.sender].push(s_nextTopicId);
        topicToId[address(newTopic)] = s_nextTopicId;
        s_nextTopicId = s_nextTopicId + 1;

        emit TopicCreated(address(newTopic));
        return address(newTopic);
    }

    function sponsorSite() public payable {
        emit DonationReceived(msg.value);
    }

    function withdrawAll() public payable
    onlyOwner
    // onlyDAO
    {
        uint256 amount = address(this).balance;
        bool success = payable(msg.sender).send(amount);
        if(!success){
            revert Writer__ErrorWithdrawing();
        }
        emit WithdrawalMade(amount);
    }

    function giveaway() public payable
    onlyOwner
    // onlyDAO
    {
        uint256 share = s_topics.length;
        uint256 amount = address(this).balance / share;
        bool success = payable(msg.sender).send(amount);
        if(!success){
            revert Writer__ErrorWithdrawing();
        }
        emit WithdrawalMade(amount);

    }

    function lock(uint256 topicId) public
    //onlyDAO
    {
        Topic topic = Topic(payable(s_topics[topicId]));
        topic.lock();
    }

    function unlock(uint256 topicId) public
    //onlyDAO
    {
        Topic topic = Topic(payable(s_topics[topicId]));
        topic.unlock();
    }

    function handOver(address newOwner) public 
    // onlyDAO
    {
        require((hasTopic[msg.sender].length != 0) && (hasTopic[newOwner].length > 0));
        hasTopic[newOwner] = hasTopic[msg.sender];
        delete hasTopic[msg.sender];
        walletToTopicOwned[newOwner] = walletToTopicOwned[msg.sender];
        delete walletToTopicOwned[msg.sender];
    }

    //getTopicAddress
    //getTopicAddressByOwnerWallet
    function getLatestTopicAddress() public view returns (address) {
        address latestTopicAddress = address(s_topics[s_nextTopicId - 1]);
        return latestTopicAddress;
    }

    function deleteTopic(address topicToDelete) public
    //onlyDAO
    //onlyOwner
    returns (string memory){
        uint256 id = topicToId[topicToDelete];
        if (id != 0){
            (bool deleted,) = topicToDelete.call(abi.encodeWithSignature("destroyTopic()"));
            if(!deleted){
            revert Writer__ErrorDeleting();
        }
            emit TopicDeleted(topicToDelete, deleted);
            return "Topic Deleted";
        } else{
            return "Topic does not exist";
        }
    }

}