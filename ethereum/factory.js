import web3 from './web3';
import CampaignFactory from './build/CampaignFactory.json';

const instance = new web3.eth.Contract(
  JSON.parse(CampaignFactory.interface),
  '0xbD4d76cF0907Ba091eE71484C44F0AFB67b08788'
);

export default instance;
