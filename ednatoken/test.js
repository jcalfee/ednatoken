
const assert = require('assert')
const Eos = require('eosjs')

const {format} = Eos.modules

const eos = Eos({
  keyProvider: '5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3',
  forceActionDataHex: false,
  // verbose: true
})

// ABI for some reason is giving addstake, stake_account a type of name when its type is really account_name. The cpp and hpp have account_name ..
const auth = {authorization: 'staker@active'}
const authEdna = {authorization: 'ednatoken@active'}

const WEEKLY = 1
const MONTHLY = 2
const QUARTERLY = 3

async function main() {
  const edna = await eos.contract('ednatoken')

  // await assertThrowsAsync(
  //   async () => edna.addstake('staker', WEEKLY - 1, '1.0000 EDNA', auth),
  //   /Invalid stake period/
  // )
  // await assertThrowsAsync(
  //   async () => edna.addstake('staker', QUARTERLY + 1, '1.0000 EDNA', auth),
  //   /Invalid stake period/
  // )

  { // unstake everything from prior runs
    let stakes = await getTableRows({table: 'stakes', upper: 'stakes'})
    stakes.rows.forEach(async stake => {
      await edna.unstake(stake.stake_id, auth)
    })
    // be sure it worked
    await wait(1) // next block
    stakes = await getTableRows({table: 'stakes', upper: 'stakes'})
    assert.equal(stakes.rows.length, 0, 'stakes')
  }

  {
    let bal = await getBalance('staker')
    console.log(`Starting balance:\t${bal}`);

    await edna.transaction(tr => {
      // 100000 / 1B == 0.0001
      tr.addstake('staker', WEEKLY, EDNA(100000), auth)
      tr.addstake('staker', MONTHLY, EDNA(100000), auth)
      tr.addstake('staker', QUARTERLY, EDNA(100000), auth)
    })

    await assertBalance('staker', EDNA(bal -= 300000))
    console.log(`Balance after staking:\t${bal}`);

    // await wait(.5) // next block
    console.log(`Starting stakes:\t${await getStakes()}`);

    await wait(1) // WEEK
    await edna.process(1, authEdna)
    console.log(`Stakes after WEEK:\t${await getStakes()}`);

    await wait(1) // MONTH
    await edna.process(1, authEdna)
    console.log(`Stakes after MONTH:\t${await getStakes()}`);

    await wait(1) // QUARTER
    await edna.process(1, authEdna)
    console.log(`Stakes after QUARTER:\t${await getStakes()}`);

    console.log(`Balance after process:\t${await getBalance('staker')}`);

  }
}

const EDNA = amount => format.DecimalPad(amount, 4) + ' EDNA'
const AMT = asset => format.DecimalPad(amount, 4) + ' EDNA'

async function getBalance(account) {
  const b = await eos.getCurrencyBalance('ednatoken', account, 'EDNA')
  return Number(b[0].split(' ')[0])
}

async function assertBalance(account, asset) {
  const [balance] = await eos.getCurrencyBalance('ednatoken', account, 'EDNA')
  assert.equal(asset, balance, `${account} balance`)
}

async function getTableRows({scope = 'ednatoken', table}) {
  return await eos.getTableRows({
    json: true, code: 'ednatoken', scope, table
  })
}

const getStakes = async () => (
  await getTableRows({table: 'stakes', upper: 'stakes'})
).rows.map(stake => stake.staked)

async function wait(delay = .5) {
  return new Promise(resolve => setTimeout(()=>resolve(), delay * 1000))
}

async function assertThrowsAsync(fn, regExp) {
  let f = () => {};
  try {
    await fn();
  } catch(e) {
    f = () => {throw e};
  } finally {
    assert.throws(f, regExp);
  }
}

main().catch(e => console.error(e))
