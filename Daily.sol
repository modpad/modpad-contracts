// SPDX-License-Identifier: AGPL-3.0
pragma solidity 0.8.20;

//                    _                    _     ___              _          
// /'\_/`\           ( )                  ( )   (  _`\         _ (_ )        
// |     |   _      _| | _ _      _ _    _| |   | | ) |   _ _ (_) | |  _   _ 
// | (_) | /'_`\  /'_` |( '_`\  /'_` ) /'_` |   | | | ) /'_` )| | | | ( ) ( )
// | | | |( (_) )( (_| || (_) )( (_| |( (_| |   | |_) |( (_| || | | | | (_) |
// (_) (_)`\___/'`\__,_)| ,__/'`\__,_)`\__,_)   (____/'`\__,_)(_)(___)`\__, |
//                      | |                                           ( )_| |
//                      (_)                                           `\___/'

import {IPoints} from  "./interface/IPoints.sol";

/**
 * @title Daily check-in contract.
 * @author Modpad.
 */
contract Daily {
    address public admin;
    IPoints public pointsContract;
    uint256 public pointsPerClaim;

    mapping(address => uint256) public userLastClaim;
    mapping(address => uint256) public totalClaims;

    event DailyClaimed(address indexed user, uint256 indexed timestamp, uint256 amount);

    error OnlyAdmin();

    constructor(address _pointsContract, uint256 _pointsPerClaim) {
        admin = msg.sender;
        pointsContract = IPoints(_pointsContract);
        pointsPerClaim = _pointsPerClaim;
    }

    modifier onlyAdmin() {
        if (admin != msg.sender) {
            revert OnlyAdmin();
        }
        _;
    }

    function claimDaily() external {
        require(block.timestamp >= nextClaimDaily(msg.sender), "Try again later");
        
        userLastClaim[msg.sender] = block.timestamp;
        totalClaims[msg.sender]++;
        emit DailyClaimed(msg.sender, block.timestamp, pointsPerClaim);
        
        pointsContract.mint(msg.sender, pointsPerClaim);
    }

    function nextClaimDaily(address user) public view returns (uint256 timestamp) {
        return userLastClaim[user] + 1 days;
    }

    function changePointsPerClaim(uint256 _pointsPerClaim) external onlyAdmin {
        pointsPerClaim = _pointsPerClaim;
    }

}
