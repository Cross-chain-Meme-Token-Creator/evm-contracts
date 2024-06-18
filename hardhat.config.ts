import { HardhatUserConfig } from "hardhat/config"
import { readFileSync } from "fs"
import { join } from "path"

const mnemonic = readFileSync(join (process.cwd(), "key.pem"), "utf8")

import "@nomicfoundation/hardhat-toolbox"
import "@nomicfoundation/hardhat-ethers"

const config: HardhatUserConfig = {
    solidity: "0.8.26",
    ignition: {
        strategyConfig: {
            create2: {
              // To learn more about salts, see the CreateX documentation   
              salt: "0x0000000000000000000000000000000000000000000000000000000000000000",
            },
          },
    },

    networks: {
        baobap: {
            url: "https://api.baobab.klaytn.net:8651",
            chainId: 1001,
            accounts: {
                mnemonic,
            },
        },
        bscTestnet: {
            url: "https://data-seed-prebsc-1-s1.bnbchain.org:8545",
            chainId: 97,
            accounts: {
                mnemonic,
            },
        },
        celoTestnet: {
            url: "https://alfajores-forno.celo-testnet.org",
            chainId: 44787,
            accounts: {
                mnemonic,
            },
        },
    },
}

export default config
