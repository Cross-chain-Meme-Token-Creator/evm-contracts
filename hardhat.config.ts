import { HardhatUserConfig } from "hardhat/config"
import "@nomicfoundation/hardhat-toolbox"

const config: HardhatUserConfig = {
    solidity: "0.8.26",
    networks: {
        baobap: {
            url: "https://api.baobab.klaytn.net:8651",
            chainId: 1001,
            accounts: {
                mnemonic: "point smart analyst disagree concert famous act accident river donate license dizzy",
            },
        },
        bscTestnet: {
            url: "https://bsc-testnet.publicnode.com",
            chainId: 97,
            accounts: {
                mnemonic: "point smart analyst disagree concert famous act accident river donate license dizzy",
            },
            gasPrice: 35000000000,
        },
    },
}

export default config
