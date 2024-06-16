
import { buildModule } from "@nomicfoundation/hardhat-ignition/modules"

const TokenFactoryModule = buildModule("TokenFactoryModule", (m) => {
    const tokenFactory = m.contract("TokenFactory", [])

    return { tokenFactory }
})

export default TokenFactoryModule

//npx hardhat ignition deploy ignition/modules/TokenFactory.ts --network bscTestnet