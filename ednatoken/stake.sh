set -o errexit
set -o xtrace

# compile
eosiocpp -g /edna/ednatoken/ednatoken.abi /edna/ednatoken/ednatoken.hpp && eosiocpp -o /edna/ednatoken/ednatoken.wast /edna/ednatoken/ednatoken.cpp

# deploy
cleos create account eosio ednatoken EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV
cleos set contract ednatoken /edna/ednatoken -p ednatoken

cleos create account eosio staker EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV
cleos create account eosio staker1 EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV
cleos create account eosio staker2 EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV
cleos create account eosio staker3 EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV
cleos create account eosio staker4 EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV
cleos create account eosio staker5 EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV
cleos create account eosio overflow EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV

cleos push action ednatoken create '["staker", "1300000000.0000 EDNA"]' -p ednatoken
cleos push action ednatoken setoverflow '["overflow"]' -p ednatoken

cleos push action ednatoken issue '["ednatoken",  "1000000000.0000 EDNA", "memo"]' -p staker

cleos push action ednatoken issue '["staker",  "200000000.0000 EDNA", "memo"]' -p staker
cleos push action ednatoken issue '["staker1", "200000000.0000 EDNA", "memo"]' -p staker
cleos push action ednatoken issue '["staker2", "200000000.0000 EDNA", "memo"]' -p staker
cleos push action ednatoken issue '["staker3", "200000000.0000 EDNA", "memo"]' -p staker
cleos push action ednatoken issue '["staker4", "200000000.0000 EDNA", "memo"]' -p staker

# cleos push action ednatoken addstake '["staker1", 1, "200000000.0000 EDNA"]' -p staker1
# cleos push action ednatoken addstake '["staker2", 1, "66663666.0000 EDNA"]' -p staker2
# cleos push action ednatoken addstake '["staker3", 1, "88882388.0000 EDNA"]' -p staker3
# cleos push action ednatoken addstake '["staker4", 1, "200000000.0000 EDNA"]' -p staker4

cleos push action ednatoken process '[0]' -p ednatoken


#/opt/eosio/bin/data-dir/config.ini
