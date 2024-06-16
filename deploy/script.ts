import { ethers } from "hardhat"

const main = async () => {
    const token = await ethers.deployContract("Token", [
        "0x0000000000000000000000000000000000000000",
        "0x68605AD7b15c732a30b1BbC62BE8F2A509D74b4D",
        "0xC7A13BE098720840dEa132D860fDfa030884b09A",
        4,
        1,
        18,
        "USDT Token",
        "USDT",
        "",
        ""
    ])
    await token.waitForDeployment()
}

main()