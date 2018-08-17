. ./dockrc.sh

set -o xtrace
set -o errexit

docker-compose down -v --remove-orphans
docker volume rm -f nodeos-data-volume
docker volume rm -f keosd-data-volume
docker volume create --name=nodeos-data-volume
docker volume create --name=keosd-data-volume

docker-compose up -d
sleep 5

set -o errexit

cleos wallet create -n $wallet | tee /dev/tty |\
  egrep -o "PW[A-Za-z0-9]*" > wallet.txt

cleos wallet import -n $wallet --private-key $private_key

. ./ednatoken/stake.sh
