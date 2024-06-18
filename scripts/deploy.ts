import { ethers } from "hardhat"

const main = async () => {
    const tokenFactoryDeployer = await  ethers.deployContract("TokenFactory")
    const deployedTokenFactoryDeployer = await tokenFactoryDeployer.waitForDeployment()
    const tokenFactoryAddr = await deployedTokenFactoryDeployer.getAddress()
    console.log(`Token Factory: ${tokenFactoryAddr}`)
}

main()

//npx hardhat run --network baobap scripts/deploy.ts