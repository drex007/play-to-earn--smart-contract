// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity >=0.7.0 < 0.90;
import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/utils/Counters.sol';
import '@openzeppelin/contracts/token/ERC20/ERC20.sol';
import '@openzeppelin/contracts/security/ReentrancyGuard.sol';
import '@openzeppelin/contracts/utils/math/SafeMath.sol';

contract PlayToEarn  is Ownable,ReentrancyGuard, ERC20 {

    using Counters for Counters.Counter;
    using SafeMath for uint256;

    //Counters
    Counters.Counter private _totalGames;
    Counters.Counter private _totalPlayers;
    Counters.Counter private _totalInvitations;



    struct GameStruct {
        uint256 id;
        string title;
        string description;
        address owner;
        uint256 participants;
        uint256 numberOfWinners;
        uint256 acceptees;
        uint256 stake;
        uint256 startDate;
        uint256 endDate;
        uint256 timestamp;
        bool deleted;
        bool paidOut;
    }

    struct PlayerStruct {
        uint id;
        uint gameId;
        address account;
    }

    struct InvitationStruct {
        uint256 id;
        string title;
        uint256 gameId;
        address receiver;
        address sender;
        bool responded;
        bool accepted;
        uint256 stake;
        uint256 timestamp;
    }

    struct ScoreStruct {
        uint256 id;
        uint256 gameId;
        address player;
        uint prize;
        bool played;
    }

    uint256 private totalBalance;
    uint256 private servicePct;


    mapping(uint => bool) gameExists;
    mapping(uint256 => GameStruct) games;
    mapping(uint256 => PlayerStruct[]) players;
    mapping(uint256 => ScoreStruct[]) scores;
    mapping(uint256 => mapping(address => bool)) isListed;
    mapping(uint256 => mapping(address => bool)) isInvited;
    mapping(uint256 => InvitationStruct[]) invitationsOf;


    constructor (uint56 _pct) Ownable(msg.sender) ERC20('PlayToEarn', 'P2E') {
        servicePct = _pct;

    }

    function createGame(
        string memory title,
        string memory description,
        uint256 participants,
        uint256 numberOfWinners,
        uint256 startDate,
        uint256 endDate

    ) public payable {
        require(msg.value > 0 ether, 'Stake must be greater than 0');
        require(participants > 1, 'Paricipants must be greater than 1');
        require(bytes(title).length > 0, 'Title cannot be empty');
        require(bytes(description).length > 0, 'Description cannot be cannot be empty');
        require(startDate > 0, 'Start Date must be greater than 0');
        require(endDate > 0 , 'End Date must be greater than 0');
        require(endDate > startDate, 'EndDate must be greater than startDate');
        require(numberOfWinners > 0, 'Number of winners must be greater than 0');

        _totalGames.increment();
        GameStruct memory game;

        game.id = _totalGames.current();
        game.title = title;
        game.description = description;
        game.participants = participants;
        game.numberOfWinners = numberOfWinners;
        game.startDate = startDate;
        game.endDate = endDate;
        game.stake = msg.value;
        game.owner = msg.sender;

        
    }

}