. ./dockrc.sh

private_key=${1-5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3}
# private key (wallet import format)

set -o xtrace
docker volume create --name=nodeos-data-volume
docker volume create --name=keosd-data-volume

docker-compose up -d
sleep 5

set -o errexit

wallet="$(basename $(pwd))"
cleos wallet create -n ednatoken | tee /dev/tty |\
  egrep -o "PW[A-Za-z0-9]*" > wallet.txt

cleos wallet import -n $wallet --private-key $private_key

. ./ednatoken/stake.sh
