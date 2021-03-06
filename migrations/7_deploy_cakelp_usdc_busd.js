const LP = artifacts.require('./CakeLP_USDC_BUSD.sol')

module.exports = async function (deployer) {
    if (parseInt(process.env.DEPLOY_CAKE) == 1) {
        await deployer.deploy(
            LP,
            process.env.NAME,
            process.env.ALIAS,
            process.env.TOKEN_MAIN,
            "0x680Dd100E4b394Bda26A59dD5c119A391e747d18", //tokenLP
            process.env.CONTROLLER,
            process.env.MASTERCHEF,
            process.env.CAKE_POOL,
            53
        )
    }
}