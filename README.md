#**Decentralized Raffle Smart Contract**

This is a decentralized raffle system built on the Ethereum blockchain. Participants can enter the raffle by paying an entrance fee in ETH, and a winner is selected automatically using Chainlink's Verifiable Random Function (VRF). The contract ensures fairness, transparency, and automation through smart contract logic.

🌟 ##**Features**

Entrance Fee : Users must pay a fixed entrance fee in ETH to participate.
Random Winner Selection : Uses Chainlink VRF to generate a provably random number for selecting the winner.
Automated Execution : Operates on a time-based interval; the winner is picked automatically when the timer expires.
Transparent and Trustless : Fully decentralized and verifiable on-chain.

🛠 ##**Technologies Used**

Solidity : For writing the smart contract.
Foundry : For testing, deployment, and scripting.
Chainlink VRF : For secure and verifiable random number generation.
Sepolia Testnet : Deployed and tested on the Sepolia Ethereum testnet.

🚀 ##**Quick Start**

1. Prerequisites

Install Foundry .
Set up an Ethereum wallet with Sepolia testnet ETH (use a faucet like Sepolia Faucet ).
Obtain a Chainlink VRF subscription ID and fund it with LINK tokens on Sepolia.

2. Clone the Repository

```bash
git clone https://github.com/Avinesh-Git/foundry-smartcontract-raffle
cd smart-contract-raffle
```

3. Set Up Environment Variables
   Create a .env file in the root directory and add the following:

```env
SEPOLIA_RPC_URL=https://****/YOUR_INFURA_PROJECT_ID
PRIVATE_KEY=YOUR_PRIVATE_KEY
ETHERSCAN_API_KEY=YOUR_ETHERSCAN_API_KEY
```

4. Install Dependencies
   Install any required dependencies using Foundry:

```bash
forge install
```

5. Run Tests
   Run the integration tests to ensure everything works as expected:

```bash
forge test
```

6. Deploy to Sepolia
   Deploy the contract to the Sepolia testnet:

```bash
make deploy-sepolia
```

After deployment, verify the contract on Etherscan using the --verify flag.

📝 ##**How It Works**

Participants Enter : Users send ETH to the contract to enter the raffle.
Timer Starts : The raffle runs for a predefined interval (e.g., 30 seconds).
Winner Selected : Once the timer expires, Chainlink VRF generates a random number to select the winner.
Prize Distributed : The winner receives the accumulated ETH from all participants.

🔧 ##**Scripts and Commands**

Test : Run tests using Foundry.

```bash
forge test
```

Deploy : Deploy the contract to Sepolia.

```bash
make deploy-sepolia
```

**Interact : Use cast or Etherscan to interact with the deployed contract.**

📈 ##**Gas Optimization**
Gas usage has been optimized where possible:

Events are used instead of storing unnecessary data on-chain.
Loops and excessive storage writes have been minimized.

🛡 ##**Security**
The contract has been tested using Foundry.

📜 ##**License**
This project is licensed under the MIT License.
