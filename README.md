# CharityFundraiser Smart Contract

## Overview

This project is a prototype of a charity fundraiser  smart contract in the field of information tecnology implemented on the Ethereum blockchain. The smart contract allows for the collection of donations and ensures secure management of the funds. The goal is to provide a transparent and automated way for non-profit organizations to raise funds.

## Features

- **Total Balance:** Tracks the total amount of Ether collected.
- **Manager:** The address of the fundraiser manager who deploys the contract.
- **Fundraising Goal:** The target amount of Ether to be raised.
- **Total Donors:** Tracks the number of unique donors.
- **Fundraiser Status:** Indicates whether the fundraiser is still active or has been closed.
- **Donation Function:** Allows users to donate Ether to the fundraiser.
- **Withdrawal Function:** Allows the manager to withdraw the collected funds once the fundraiser is closed.
- **Goal Check Function:** Checks if the fundraising goal has been reached.

## Contract Functions

| Function                | Description                                                                 | Usage                                                           | 
Restrictions                                    |
|-------------------------|-----------------------------------------------------------------------------|--------------------------------------------------------------------|------------------------------------------------|
| `constructor`           | Initializes the contract with the manager and fundraising goal.             | Used when deploying the contract.                                  | None                                           |
| `donate`                | Allows users to donate Ether to the fundraiser.                             | Called by users who want to donate.                                | Fundraiser must be open, and users can donate only once. |
| `withdrawFunds`         | Allows the manager to withdraw the collected funds.                         | Called by the manager to withdraw funds.                           | Only callable by the manager and if the fundraiser is closed. |
| `closeFundraiser`       | Closes the fundraiser, preventing further donations.                        | Called by the manager to close the fundraiser.                     | Only callable by the manager.                 |
| `checkGoalReached`      | Checks if the fundraising goal has been reached.                            | Can be called by anyone to check the status.                       | None                                           |
| `getGoalInEther`        | Returns the fundraising goal in Ether.                                      | Can be called by anyone to get the goal in Ether.                  | None                                           |
| `getTotalBalanceInEther`| Returns the total balance collected in Ether.                               | Can be called by anyone to get the total balance in Ether.         | None                                           |
| `getTotalDonors`        | Returns the number of unique donors.                                        | Can be called by anyone to get the number of donors.               | None                                           |
| `getFundraiserStatus`   | Returns whether the fundraiser is open or closed.                           | Can be called by anyone to check the fundraiser status.            | None                                           |
| `getParticipant`        | Returns the details of a participant by address.                            | Can be called by anyone to get participant details.                | None                                           |
| `getAllParticipants`    | Returns a list of all participants with their donations.                    | Can be called by anyone to get all participants and their donations. | None                                           |
| `getManagerName`        | Returns the name of the manager who deployed the contract.                  | Can be called by anyone to get the manager's name.                 | None                                           |

## Technological Choices

### Solidity

The smart contract is written in Solidity, a statically-typed programming language designed for developing smart contracts on the Ethereum blockchain. Solidity is specifically used for its ability to handle complex business logic and ensure security in decentralized applications.

### Ethereum Blockchain

The contract is deployed on the Ethereum blockchain, leveraging its decentralized network to provide a transparent and secure platform for fundraising. Ethereum's wide adoption and robust infrastructure make it an ideal choice for blockchain-based applications.

### Remix IDE

The development and testing of the smart contract were conducted using Remix IDE. Remix provides an interactive and user-friendly environment for writing, compiling, and deploying smart contracts on the Ethereum blockchain.

### OpenZeppelin ReentrancyGuard

The contract uses the `ReentrancyGuard` library from OpenZeppelin to prevent reentrancy attacks. This security measure ensures that functions like `withdrawFunds` cannot be exploited through recursive calls, safeguarding the funds collected in the contract.


