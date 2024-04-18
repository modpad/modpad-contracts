// SPDX-License-Identifier: AGPL-3.0
pragma solidity 0.8.20;

interface IPoints {
    error ERC20InsufficientAllowance(address spender, uint256 allowance, uint256 needed);
    error ERC20InsufficientBalance(address sender, uint256 balance, uint256 needed);
    error ERC20InvalidApprover(address approver);
    error ERC20InvalidReceiver(address receiver);
    error ERC20InvalidSender(address sender);
    error ERC20InvalidSpender(address spender);
    error OnlyAdmin();
    error OnlyBurner();
    error OnlyMinter();
    error TokenIsSoulBound();

    event Approval(address indexed owner, address indexed spender, uint256 value);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event BurnerStatusChanged(address burner, bool status);
    event MinterStatusChanged(address minter, bool status);
    event PointsBurned(address indexed burner, address indexed user, uint256 amount);
    event PointsMinted(address indexed minter, address indexed user, uint256 amount);

    function admin() external view returns (address);
    
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address, uint256) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
    function decimals() external view returns (uint8);
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function totalSupply() external view returns (uint256);
    function transfer(address, uint256) external returns (bool);
    function transferFrom(address, address, uint256) external returns (bool);
    
    function burn(address _from, uint256 _amount) external;
    function burners(address) external view returns (bool);
    function setBurner(address burner) external;
    function batchBurn(address[] memory _from, uint256 _amount) external;
    function batchBurnMultiple(address[] memory _from, uint256[] memory _amounts) external;
    
    function mint(address _to, uint256 _amount) external;
    function minters(address) external view returns (bool);
    function setMinter(address minter) external;
    function batchMint(address[] memory _to, uint256 _amount) external;
    function batchMintMultiple(address[] memory _to, uint256[] memory _amounts) external;
}