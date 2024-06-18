
import { buildModule } from "@nomicfoundation/hardhat-ignition/modules"

const TokenFactoryDeployerModule = buildModule("TokenFactoryDeployerModule", (m) => {
    const tokenFactoryDeployer = m.contract("TokenFactoryDeployer", [])

    const factoryContract = m.call(tokenFactoryDeployer, "deploy", []);
    console.log(factoryContract)
    
    return { tokenFactoryDeployer }
})

export default TokenFactoryDeployerModule

//npx hardhat ignition deploy ignition/modules/TokenFactoryDeployer.ts --network bscTestnet --strategy create2