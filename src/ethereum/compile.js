const path = require('path');
const solc = require('solc');
const fs = require('fs-extra');

const buildPath = path.resolve(__dirname, 'build');
fs.removeSync(buildPath);

const ERC20Interface = path.resolve(
  __dirname,
  'contracts'
);
const main = path.resolve(__dirname, 'contracts', 'main.sol');
const p2p = path.resolve(__dirname, 'contracts', 'p2p.sol');
const p2g = path.resolve(__dirname, 'contracts', 'p2g.sol');


const input = {
  'main.sol': fs.readFileSync(main, 'utf8'),
  'p2p.sol': fs.readFileSync(p2p, 'utf8'),
  'p2g.sol': fs.readFileSync(p2g, 'utf8')
};

output = solc.compile({ sources: input }).contracts;

fs.ensureDirSync(buildPath);

for (let contract in output) {
  fs.outputJSONSync(
    path.resolve(
      buildPath,
      contract.substring(0, contract.indexOf('.')) + '.json'
    ),
    output[contract]
  );
}