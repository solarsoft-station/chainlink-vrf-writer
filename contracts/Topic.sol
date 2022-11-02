//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.9;

contract Topic{

    struct Post{
        string cid;
        uint256 count;
        address writer;
    }
    
    uint256 public i_limit;
    uint256 public immutable i_percentCut;
    uint256 public immutable i_topicId;
    uint256 public s_mumDeletions;

    bool public is_limitReached;
    bool public is_openToPost;
    bool public is_Blocked;
    bool public is_Withdrawn;

    address public s_topicOwner;
    address public s_topicContractCreator;

    string public topicName;
    //string public postURI;

    mapping(address => uint256) public writerToNumberOfPost;
    mapping(address => Post[]) public writerToPost;
    // mapping( => )
    // Post[] public postsList;
    uint256 public postCount;

    error Topic__isNotOpenToPost();
    error Topic__cannotInCurrentState();
    error Topic__notAuthorized();
    error Topic__ErrorWithdrawing();
    error Topic__AlreadyInState();
    error Topic__YouDoNotOwnAPost();

    event PostAdded(address poster, string cid);
    event WithdrawalMade(address withdrawer, uint256 amount);
    event IsOpenToPostsSwitched(bool isOpenToPosts);
    event OwnershipChanged(address indexed newOwner);
    // event PostURISet(string postURI);
    event TopicLocked(bool isLocked);
    event TopicUnlocked(bool isLocked);
    event DonationReceived(uint256 amount);
 
    // event Refunded(address refundee, uint256 amount);


    modifier onlyOwner() {
        if (msg.sender != s_topicOwner) {
            revert Topic__notAuthorized();
        }        
    _;
    }   
    modifier onlyParentContract() {
          if (msg.sender != s_topicContractCreator) {
            revert Topic__notAuthorized();
                   }
        _;
    }


       constructor(
        string memory nameOfTopic,
        uint256 limit,
        address payable topicOwner,
        uint256 percentCut,
        uint256 topicId
    ) {
        topicName = nameOfTopic;
        i_limit = limit;
        s_topicOwner = topicOwner;
        i_percentCut = percentCut;
        i_topicId = topicId;
        
    }

    function lock() public onlyOwner{}
    function unlock() public onlyOwner{}
    function setTopicContract( address writerContract) public onlyOwner{}
    receive() external payable {
            emit DonationReceived(msg.value);

        }
    fallback() external payable {
            emit DonationReceived(msg.value);

        }

    function createPost( string memory cid) public payable{
        if (is_limitReached || !is_openToPost || is_Blocked){
            revert Topic__isNotOpenToPost();
        }
        if(postCount+1 > i_limit){
            revert Topic__cannotInCurrentState();
        }
        Post memory newPost = Post(cid, postCount, msg.sender);
        writerToNumberOfPost[msg.sender] += 1;
        writerToPost[msg.sender].push(newPost);
        unchecked {postCount++;}

        emit PostAdded(msg.sender, cid);
    }

    function destroyTopic()public onlyParentContract{}
    function getPostByWriter() public{}
    function getPostById() public{}
    function getPostURI() public{}

}