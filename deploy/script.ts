import { ethers } from "hardhat"

const main = async () => {
    const token = await ethers.deployContract("Token", [
        "0x0000000000000000000000000000000000000000",
        "0x68605AD7b15c732a30b1BbC62BE8F2A509D74b4D",
        "0x9dcF9D205C9De35334D646BeE44b2D2859712A09",
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