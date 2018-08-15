. ./dockrc.sh

wallet="$(basename $(pwd))"
cleos wallet unlock -n $wallet --password wallet.txt
