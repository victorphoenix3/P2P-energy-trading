const HDWalletProvider = require('truffle-hdwallet-provider');
const Web3 = require('web3');
const compiledmain = require('./build/main.json');
const compiledp2p = require('./build/p2p.json');
const compiledp2g = require('./build/p2g.json');
const config = require('./production/config');

const provider = new HDWalletProvider(config.MNEMONIC, config.NETWORKURL);
const web3 = new Web3(provider);

let accounts;

const deploymain = async () => {
  accounts = await web3.eth.getAccounts();
  console.log('deploying...');
  ERC20Interface = await new web3.eth.Contract(
    JSON.parse(compiledmain.interface)
  )
    .deploy({
      data: '0x' + compiledmain.bytecode
    })
    .send({
      from: accounts[0],
      gas: '5000000'
    });

  console.log(
    'Main is deployed! Contract Address: ',
    main.options.address
  );
};

const deployp2p = async () => {
  accounts = await web3.eth.getAccounts();
  p2p = await new web3.eth.Contract(JSON.parse(compiledp2p.interface))
    .deploy({
      data: '0x' + compiledp2p.bytecode
    })
    .send({
      from: accounts[0],
      gas: '6000000'
    });

  console.log(
    'DEXtoken is deployed! Contract Address: ',
    p2p.options.address
  );
};

const deployp2g = async () => {
  p2g = await new web3.eth.Contract(JSON.parse(compiledp2g.interface))
    .deploy({
      data: '0x' + compiledp2g.bytecode
    })
    .send({
      from: accounts[0],
      gas: '6500000'
    });

  console.log(
    'P2G is deployed! Contract Address: ',
    p2g.options.address
  );
};

deployp2p().then(deployp2g).then(deploymain);