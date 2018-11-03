import Web3 from 'web3';

let web3;

if (typeof window !== 'undefined' && typeof window.web3 !== 'undefined') {
  // we are in the broswer and metamask is running
  web3 = new Web3(window.web3.currentProvider);
} else {
  const provider = new Web3.providers.HttpProvider(
    'https://rinkeby.infura.io/v3/cdb19fc216c34e0db091c8c051deb426'
  );
  web3 = new Web3(provider);
}

export default web3;
