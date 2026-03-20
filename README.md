# Imperial Oath-Chain

An on-chain registry of Imperial oaths sworn by warriors, priests, and servants of the Imperium of Man.  
Each wallet may hold one active oath at a time; swearing a new oath automatically marks the previous one as broken, but all oaths remain permanently recorded on-chain.

Inspired by the Warhammer 40,000 universe, this project is purely textual, non-financial, and focused on immutable lore.

---

## Contract Address and Verification

The contract is deployed and verified on BaseScan:

**https://basescan.org/address/0xb6d487a1db63002c6f1f39e79d4fc423437ac6a0#code**

From this page you can:

- Inspect the verified source code  
- Read all historical oaths in `oathHistory`  
- Call `swearOath` to swear a new oath  
- Track `OathSworn` and `OathBroken` events  

---

## Contract Overview

Main file: `contracts/ImperialOathChain.sol`

Key elements:

- `Oath[] public oathHistory` – full history of all oaths ever sworn  
- `mapping(address => uint256) public activeOathIndex` – tracks each address’s active oath (stored as index + 1)  
- `swearOath(string faction, string vow, string dutyLevel)` – swears a new oath, breaking the previous one if it exists  
- `totalOaths()` – returns the total number of oaths recorded  

Each `Oath` contains:

- `faction` – the faction or order swearing the oath (e.g., Ultramarines, Cadian 122nd, Adeptus Mechanicus)  
- `vow` – the full text of the oath  
- `dutyLevel` – e.g., Minor, Major, Sacred, Unbreakable  
- `status` – `Active` or `Broken`  
- `swornBy` – the address that swore the oath  
- `timestamp` – block timestamp when it was recorded  

A text size limit (1000 characters per field) prevents oversized inputs.

---

## Safety

This contract is intentionally minimal and safe for public interaction:

- No `payable` functions  
- No ETH transfers  
- No external calls  
- No ownership or admin roles  
- No token or financial logic  
- No `selfdestruct`  

It is a pure text and lore contract; users only pay gas fees to write their oaths on-chain.

---

## How to Use (Remix)

1. Open Remix: https://remix.ethereum.org  
2. Create a file named `ImperialOathChain.sol`  
3. Paste the code from `contracts/ImperialOathChain.sol`  
4. Compile with Solidity **0.8.31**  
5. Deploy using MetaMask or Remix VM  

Purpose
Imperial Oath-Chain is meant as:

A thematic Warhammer 40K on-chain oath archive

A demonstration of evolving per-user state with full historical trace

A non-financial, lore-focused experiment in immutable public data
