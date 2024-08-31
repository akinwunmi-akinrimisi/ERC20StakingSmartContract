// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Interface for the ERC20 token
interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}

contract ERC20Staking{

// State Variables
    address public owner; // Owner Address
    IERC20 public stakingToken; // The ERC20 token to be staked
    uint256 public rewardRate30Days; // Reward Rate for 30 days
    uint256 public rewardRate60Days; // Reward Rate for 60 days
    uint256 public rewardRate90Days; // Reward Rate for 90 days
    uint256 public totalStaked; // Total Staked Tokens
    uint256 public constant earlyWithdrawalFeePercent = 15; // 15% fee for early withdrawal

    // Struct for Staker Information
    struct Staker {
        uint256 stakedAmount;       // The amount of tokens staked by the user
        uint256 stakingTimestamp;   // The timestamp when the tokens were staked
        uint256 stakingDuration;    // The selected staking duration (in seconds)
        uint256 rewards;            // The calculated rewards for the staker
        bool hasStaked;             // Whether the user has an active stake
        bool isRewardWithdrawn;     // Whether the rewards have been withdrawn
        bool isStakeWithdrawn;      // Whether the staked tokens have been withdrawn
        bool isRegistered;          // Whether the user is registered
    }

    // Mapping to store stakers' information
    mapping(address => Staker) public stakers;

    // Array to store the list of stakers
    address[] public stakerList;

    // Constructor to initialize contract
    constructor(IERC20 _stakingToken) {
        owner = msg.sender; // Set the owner of the contract to the deployer
        stakingToken = _stakingToken; // Set the staking ERC20 token
        rewardRate30Days = 3;  // Initialize reward rate for 30 days (3%)
        rewardRate60Days = 5;  // Initialize reward rate for 60 days (5%)
        rewardRate90Days = 15; // Initialize reward rate for 90 days (15%)
    }

// Register Function
    function register(uint256 _preferredDuration) public {
        // Convert days to seconds
        uint256 durationInSeconds = _preferredDuration * 1 days;

        // Ensure the user is not already registered
        require(!stakers[msg.sender].isRegistered, "Already registered.");

        // Ensure a valid duration is selected
        require(
            durationInSeconds == 30 days || durationInSeconds == 60 days || durationInSeconds == 90 days,
            "Invalid staking duration. Choose 30 days, 60 days, or 90 days."
        );

        // Register the user with preferred staking duration
        stakers[msg.sender].stakingDuration = durationInSeconds;
        stakers[msg.sender].isRegistered = true;

        // Add to the list of stakers
        stakerList.push(msg.sender);

        // Emit event for registration
        emit Registered(msg.sender, durationInSeconds);
    }


}