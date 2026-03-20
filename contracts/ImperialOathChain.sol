// SPDX-License-Identifier: MIT
pragma solidity 0.8.31;

/// @title Imperial Oath-Chain
/// @notice Users swear Imperial oaths; new oaths overwrite the old one and mark it as broken.
/// @dev Pure text-based contract. No funds, no external calls, no owner.

contract ImperialOathChain {

    uint256 public constant MAX_TEXT_SIZE = 1000;

    enum OathStatus { Active, Broken }

    struct Oath {
        string faction;         // Faction making the oath (Astartes, Guard, Mechanicus...)
        string vow;             // The oath text
        string dutyLevel;       // Minor, Major, Sacred, Unbreakable
        OathStatus status;      // Active or Broken
        address swornBy;        // Who made the oath
        uint256 timestamp;      // When it was sworn
    }

    /// @notice Full historical list of all oaths ever sworn.
    Oath[] public oathHistory;

    /// @notice Tracks the index of the active oath for each user.
    /// @dev Stores index + 1. Zero means "no active oath".
    mapping(address => uint256) public activeOathIndex;

    /// @notice Emitted whenever a new oath is sworn.
    event OathSworn(
        address indexed swornBy,
        uint256 indexed oathIndex,
        string faction,
        string dutyLevel
    );

    /// @notice Emitted when a previous oath is marked as broken.
    event OathBroken(
        address indexed swornBy,
        uint256 indexed oathIndex
    );

    /// @notice Swear a new Imperial oath. Previous oath becomes broken.
    function swearOath(
        string calldata faction,
        string calldata vow,
        string calldata dutyLevel
    ) external {
        require(bytes(faction).length <= MAX_TEXT_SIZE, "Faction text too large");
        require(bytes(vow).length <= MAX_TEXT_SIZE, "Vow text too large");
        require(bytes(dutyLevel).length <= MAX_TEXT_SIZE, "Duty text too large");

        uint256 storedIndex = activeOathIndex[msg.sender];

        // If user has an active oath, mark it as broken
        if (storedIndex != 0) {
            uint256 realIndex = storedIndex - 1;
            Oath storage oldOath = oathHistory[realIndex];
            if (oldOath.status == OathStatus.Active) {
                oldOath.status = OathStatus.Broken;
                emit OathBroken(msg.sender, realIndex);
            }
        }

        // Create new oath
        Oath memory newOath = Oath({
            faction: faction,
            vow: vow,
            dutyLevel: dutyLevel,
            status: OathStatus.Active,
            swornBy: msg.sender,
            timestamp: block.timestamp
        });

        oathHistory.push(newOath);
        uint256 newIndex = oathHistory.length - 1;

        // Store index + 1 to avoid zero-index ambiguity
        activeOathIndex[msg.sender] = newIndex + 1;

        emit OathSworn(msg.sender, newIndex, faction, dutyLevel);
    }

    /// @notice Returns the total number of oaths ever sworn.
    function totalOaths() external view returns (uint256) {
        return oathHistory.length;
    }
}
