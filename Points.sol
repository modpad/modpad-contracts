// SPDX-License-Identifier: AGPL-3.0

//                    _                    _     ___                    _         
// /'\_/`\           ( )                  ( )   (  _`\        _        ( )_       
// |     |   _      _| | _ _      _ _    _| |   | |_) )  _   (_)  ___  | ,_)  ___ 
// | (_) | /'_`\  /'_` |( '_`\  /'_` ) /'_` |   | ,__/'/'_`\ | |/' _ `\| |  /',__)
// | | | |( (_) )( (_| || (_) )( (_| |( (_| |   | |   ( (_) )| || ( ) || |_ \__, \
// (_) (_)`\___/'`\__,_)| ,__/'`\__,_)`\__,_)   (_)   `\___/'(_)(_) (_)`\__)(____/
//                      | |                                                       
//                      (_)                                                       

pragma solidity 0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
 * @title Soulbound ERC20 contract for Modpad XP tokens.
 * @author Modpad.
 */
contract Points is ERC20 {
    address public admin;

    mapping(address => bool) public minters;
    mapping(address => bool) public burners;

    event MinterStatusChanged(address minter, bool status);
    event BurnerStatusChanged(address burner, bool status);
    event PointsMinted(address indexed minter, address indexed user, uint256 amount);
    event PointsBurned(address indexed burner, address indexed user, uint256 amount);

    error OnlyAdmin();
    error OnlyMinter();
    error OnlyBurner();
    error TokenIsSoulBound();

    constructor() ERC20("Modpad XP", "MXP") {
        admin = msg.sender;
    }

    modifier onlyAdmin() {
        if (admin != msg.sender) {
            revert OnlyAdmin();
        }
        _;
    }

    modifier onlyMinter() {
        if (!minters[msg.sender]) {
            revert OnlyMinter();
        }
        _;
    }

    modifier onlyBurner() {
        if (!burners[msg.sender]) {
            revert OnlyBurner();
        }
        _;
    }

    function setMinter(address minter) external onlyAdmin {
        bool status = !minters[minter];
        minters[minter] = status;
        emit MinterStatusChanged(minter, status);
    }

    function setBurner(address burner) external onlyAdmin {
        bool status = !burners[burner];
        burners[burner] = status;
        emit BurnerStatusChanged(burner, status);
    }

    function mint(address _to, uint256 _amount) external onlyMinter {
        _mint(_to, _amount);
        emit PointsMinted(msg.sender, _to, _amount);
    }

    function batchMint(address[] calldata _to, uint256 _amount) external onlyMinter {
        uint256 addressLength = _to.length;

        for (uint256 i; i < addressLength;) {
            unchecked {
                _mint(_to[i], _amount);
                emit PointsMinted(msg.sender, _to[i], _amount);
                ++i;
            }
        }
    }

    function batchMintMultiple(address[] calldata _to, uint256[] calldata _amounts) external onlyMinter {
        require(_to.length == _amounts.length, "Array lengths do not match");

        uint256 addressLength = _to.length;
        for (uint256 i; i < addressLength;) {
            unchecked {
                _mint(_to[i], _amounts[i]);
                emit PointsMinted(msg.sender, _to[i], _amounts[i]);
                ++i;
            }
        }
    }

    function burn(address _from, uint256 _amount) external onlyBurner {
        _burn(_from, _amount);
        emit PointsBurned(msg.sender, _from, _amount);
    }

    function batchBurn(address[] calldata _from, uint256 _amount) external onlyBurner {
        uint256 addressLength = _from.length;

        for (uint256 i; i < addressLength;) {
            unchecked {
                _burn(_from[i], _amount);
                emit PointsBurned(msg.sender, _from[i], _amount);
                ++i;
            }
        }
    }

    function batchBurnMultiple(address[] calldata _from, uint256[] calldata _amounts) external onlyBurner {
        require(_from.length == _amounts.length, "Array lengths do not match");

        uint256 addressLength = _from.length;
        for (uint256 i; i < addressLength;) {
            unchecked {
                _burn(_from[i], _amounts[i]);
                emit PointsBurned(msg.sender, _from[i], _amounts[i]);
                ++i;
            }
        }
    }

    /**
     * @notice Overrides and reverts base functions for transfer.
     */
    function transfer(address, uint256) public virtual override returns (bool) {
        revert TokenIsSoulBound();
    }

    /**
     * @notice Overrides and reverts base functions for transferFrom.
     */
    function transferFrom(address, address, uint256) public virtual override returns (bool) {
        revert TokenIsSoulBound();
    }

    /**
     * @notice Overrides and reverts base functions for approve.
     */
    function approve(address, uint256) public virtual override returns (bool) {
        revert TokenIsSoulBound();
    }
}
