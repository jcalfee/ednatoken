
# private key (wallet import format)
private_key=${1-5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3}
wallet="$(basename $(pwd))"

function nodeosd() { docker-compose exec nodeosd "$@"; }
function keosd() { docker-compose exec keosd "$@"; }
function eosiocpp() { docker-compose exec keosd eosiocpp "$@"; }

function cleos() {
  keosd cleos -u http://nodeosd:8888 --wallet-url http://localhost:8900 "$@"
}

function tail-nodeosd() {
  docker logs ednatoken_nodeosd_1 -f 2>&1 | egrep -v 'Produced block 0'
}
