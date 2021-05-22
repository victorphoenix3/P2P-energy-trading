import Web3 from 'web3';

let web3;

//optimized for server-side rendering and for absent metamask

if (typeof window !== 'undefined' && typeof window.web3 !== 'undefined') {
  //We are in the browser and metamask in running
  web3 = new Web3(window.web3.currentProvider);
} else {
  //We are either on the server or the user isn't running metamask
  const provider = new Web3.providers.HttpProvider(
    'https://rinkeby.infura.io/v3/3f0542feaafa428db37496e01de8cb5f'
  );

  web3 = new Web3(provider);
}
export default web3;