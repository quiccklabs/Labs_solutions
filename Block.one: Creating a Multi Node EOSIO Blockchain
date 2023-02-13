

Task 2:- 

sudo apt update

curl -LO https://github.com/eosio/eos/releases/download/v2.1.0/eosio_2.1.0-1-ubuntu-20.04_amd64.deb

sudo apt install ./eosio_2.1.0-1-ubuntu-20.04_amd64.deb -y


Task 3:-

keosd --unlock-timeout 999999999 &

cleos wallet create --file my_wallet_password


Task 4:-

cleos wallet open

cleos wallet unlock <my_wallet_password

cleos wallet import --private-key 5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3


Task 5:-

sudo apt install build-essential -y

curl -LO https://github.com/eosio/eosio.cdt/releases/download/v1.8.1/eosio.cdt_1.8.1-1-ubuntu-18.04_amd64.deb

sudo apt install ./eosio.cdt_1.8.1-1-ubuntu-18.04_amd64.deb


Task 6:-

sudo apt install cmake -y

git clone https://github.com/EOSIO/eosio.contracts.git \
--branch release/1.9.x --single-branch

cd eosio.contracts
./build.sh -e /usr/opt/eosio/2.1.0 -c /usr/opt/eosio.cdt/1.8.1
cd ~


git clone https://github.com/EOSIO/eos.git \
--branch release/2.1.x --single-branch
cd eos/contracts/contracts/eosio.boot
cmake .
make
cd ~


Task 7:-

mkdir nodes

cat >nodes/genesis.json

{
  "initial_timestamp": "2018-06-01T12:00:00.000",
  "initial_key": "EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV",
  "initial_configuration": {
    "max_block_net_usage": 1048576,
    "target_block_net_usage_pct": 1000,
    "max_transaction_net_usage": 524288,
    "base_per_transaction_net_usage": 12,
    "net_usage_leeway": 500,
    "context_free_discount_net_usage_num": 20,
    "context_free_discount_net_usage_den": 100,
    "max_block_cpu_usage": 200000,
    "target_block_cpu_usage_pct": 1000,
    "max_transaction_cpu_usage": 150000,
    "min_transaction_cpu_usage": 100,
    "max_transaction_lifetime": 3600,
    "deferred_trx_expiration_window": 600,
    "max_transaction_delay": 3888000,
    "max_inline_action_size": 524288,
    "max_inline_action_depth": 4,
    "max_authority_depth": 6
  },
  "initial_chain_id": "0000000000000000000000000000000000000000000000000000000000000000"
}



//Press ctrl + D once, It’s a mistake in video sorry for inconvenience 🙏


mkdir nodes/00-boot

nodeos \
--plugin eosio::http_plugin  --plugin eosio::chain_api_plugin  --plugin eosio::chain_plugin  --plugin eosio::producer_api_plugin  --plugin eosio::producer_plugin  --plugin eosio::history_plugin  --plugin eosio::history_api_plugin  --plugin eosio::net_api_plugin \
--contracts-console \
--max-transaction-time=200 \
--chain-state-db-size-mb 1024 \
--enable-stale-production \
--producer-name eosio \
--genesis-json ~/nodes/genesis.json \
--blocks-dir ~/nodes/00-boot/blocks \
--config-dir ~/nodes/00-boot \
--data-dir ~/nodes/00-boot \
--http-server-address 127.0.0.1:8888 \
--p2p-listen-endpoint 127.0.0.1:9876 \
--signature-provider EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV=KEY:5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3 \
>>~/nodes/00-boot/00.log 2>&1 &


cleos get account eosio

cleos create account eosio eosio.bpay EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV
cleos create account eosio eosio.msig EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV
cleos create account eosio eosio.names EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV
cleos create account eosio eosio.ram EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV
cleos create account eosio eosio.ramfee EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV
cleos create account eosio eosio.saving EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV
cleos create account eosio eosio.stake EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV
cleos create account eosio eosio.token EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV
cleos create account eosio eosio.vpay EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV
cleos create account eosio eosio.rex EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV



Task 8:-

cleos set contract eosio.token ~/eosio.contracts/build/contracts/eosio.token/

cleos set contract eosio.msig ~/eosio.contracts/build/contracts/eosio.msig/

cleos push action eosio.token create '["eosio", "10000000000.0000 SYS"]' -p eosio.token

cleos push action eosio.token issue '["eosio", "1000000000.0000 SYS", "memo"]' -p eosio


Task 9:- 

sudo apt install jq -y

curl -X POST http://127.0.0.1:8888/v1/producer/get_supported_protocol_features -d '{"exclude_disabled": false, "exclude_unactivatable": false}' | jq | more

// Press space button multiple times

curl -X POST http://127.0.0.1:8888/v1/producer/schedule_protocol_feature_activations -d '{"protocol_features_to_activate": ["0ec7e080177b2c02b278d5088611686b49d739925a92d9bfcacd7fc6b74053bd"]}'


cleos set contract eosio ~/eos/contracts/contracts/eosio.boot/


# KV_DATABASE
cleos push action eosio activate '["825ee6288fb1373eab1b5187ec2f04f6eacb39cb3a97f356a07c91622dd61d16"]' -p eosio
# ACTION_RETURN_VALUE
cleos push action eosio activate '["c3a6138c5061cf291310887c0b5c71fcaffeab90d5deb50d3b9e687cead45071"]' -p eosio
# CONFIGURABLE_WASM_LIMITS
cleos push action eosio activate '["bf61537fd21c61a60e542a5d66c3f6a78da0589336868307f94a82bccea84e88"]' -p eosio
# BLOCKCHAIN_PARAMETERS
cleos push action eosio activate '["5443fcf88330c586bc0e5f3dee10e7f63c76c00249c87fe4fbf7f38c082006b4"]' -p eosio
# GET_SENDER
cleos push action eosio activate '["f0af56d2c5a48d60a4a5b5c903edfb7db3a736a94ed589d0b797df33ff9d3e1d"]' -p eosio
# FORWARD_SETCODE
cleos push action eosio activate '["2652f5f96006294109b3dd0bbde63693f55324af452b799ee137a81a905eed25"]' -p eosio
# ONLY_BILL_FIRST_AUTHORIZER
cleos push action eosio activate '["8ba52fe7a3956c5cd3a656a3174b931d3bb2abb45578befc59f283ecd816a405"]' -p eosio
# RESTRICT_ACTION_TO_SELF
cleos push action eosio activate '["ad9e3d8f650687709fd68f4b90b41f7d825a365b02c23a636cef88ac2ac00c43"]' -p eosio
# DISALLOW_EMPTY_PRODUCER_SCHEDULE
cleos push action eosio activate '["68dcaa34c0517d19666e6b33add67351d8c5f69e999ca1e37931bc410a297428"]' -p eosio
# FIX_LINKAUTH_RESTRICTION
cleos push action eosio activate '["e0fb64b1085cc5538970158d05a009c24e276fb94e1a0bf6a528b48fbc4ff526"]' -p eosio
# REPLACE_DEFERRED
cleos push action eosio activate '["ef43112c6543b88db2283a2e077278c315ae2c84719a8b25f25cc88565fbea99"]' -p eosio
# NO_DUPLICATE_DEFERRED_ID
cleos push action eosio activate '["4a90c00d55454dc5b059055ca213579c6ea856967712a56017487886a4d4cc0f"]' -p eosio
# ONLY_LINK_TO_EXISTING_PERMISSION
cleos push action eosio activate '["1a99a59d87e06e09ec5b028a9cbb7749b4a5ad8819004365d02dc4379a8b7241"]' -p eosio
# RAM_RESTRICTIONS
cleos push action eosio activate '["4e7bf348da00a945489b2a681749eb56f5de00b900014e137ddae39f48f69d67"]' -p eosio
# WEBAUTHN_KEY
cleos push action eosio activate '["4fca8bd82bbd181e714e283f83e1b45d95ca5af40fb89ad3977b653c448f78c2"]' -p eosio
# WTMSIG_BLOCK_SIGNATURES
cleos push action eosio activate '["299dcb6af692324b899b39f16d5a530a33062804e41f09dc97e9f156b4476707"]' -p eosio


cleos set contract eosio ~/eosio.contracts/build/contracts/eosio.system/


Task 10:-

cleos push action eosio setpriv '["eosio.msig", 1]' -p eosio

cleos push action eosio init '["0", "4,SYS"]' -p eosio

cleos wallet import --private-key 5KLGj1HGRWbk5xNmoKfrcrQHXvcVJBPdAckoiJgFftXSJjLPp7b
cleos wallet import --private-key 5K6qk1KaCYYWX86UhAfUsbMwhGPUqrqHrZEQDjs9ekP5j6LgHUu
cleos wallet import --private-key 5JCStvbRgUZ6hjyfUiUaxt5iU3HP6zC1kwx3W7SweaEGvs4EPfQ
cleos wallet import --private-key 5JJjaKnAb9KM2vkkJDgrYXoeUEdGgWtB5WK1a38wrmKnS3KtkS6


cleos system newaccount --transfer eosio producer.one EOS8imf2TDq6FKtLZ8mvXPWcd6EF2rQwo8zKdLNzsbU9EiMSt9Lwz --stake-net "50000000.0000 SYS" --stake-cpu "50000000.0000 SYS" --buy-ram-kbytes 8192
cleos system newaccount --transfer eosio producer.two EOS7Ef4kuyTbXbtSPP5Bgethvo6pbitpuEz2RMWhXb8LXxEgcR7MC --stake-net "50000000.0000 SYS" --stake-cpu "50000000.0000 SYS" --buy-ram-kbytes 8192
cleos system newaccount --transfer eosio produc.three EOS5n442Qz4yVc4LbdPCDnxNSseAiUCrNjRxAfPhUvM8tWS5svid6 --stake-net "50000000.0000 SYS" --stake-cpu "50000000.0000 SYS" --buy-ram-kbytes 8192
cleos system newaccount --transfer eosio produce.four EOS5y3Tm1czTCia3o3JidVKmC78J9gRQU8qHjmRjFxTyhh2vxvF5d --stake-net "50000000.0000 SYS" --stake-cpu "50000000.0000 SYS" --buy-ram-kbytes 8192


cleos system regproducer producer.one EOS8imf2TDq6FKtLZ8mvXPWcd6EF2rQwo8zKdLNzsbU9EiMSt9Lwz https://producer.one.com/EOS8imf2TDq6FKtLZ8mvXPWcd6EF2rQwo8zKdLNzsbU9EiMSt9Lwz
cleos system regproducer producer.two EOS7Ef4kuyTbXbtSPP5Bgethvo6pbitpuEz2RMWhXb8LXxEgcR7MC https://producer.two.com/EOS7Ef4kuyTbXbtSPP5Bgethvo6pbitpuEz2RMWhXb8LXxEgcR7MC
cleos system regproducer produc.three EOS5n442Qz4yVc4LbdPCDnxNSseAiUCrNjRxAfPhUvM8tWS5svid6 https://produc.three.com/EOS5n442Qz4yVc4LbdPCDnxNSseAiUCrNjRxAfPhUvM8tWS5svid6
cleos system regproducer produce.four EOS5y3Tm1czTCia3o3JidVKmC78J9gRQU8qHjmRjFxTyhh2vxvF5d https://produce.four.com/EOS5y3Tm1czTCia3o3JidVKmC78J9gRQU8qHjmRjFxTyhh2vxvF5d


cleos system listproducers


Task 11:-

mkdir nodes/01-node nodes/02-node nodes/03-node nodes/04-node


nodeos \
--plugin eosio::http_plugin  --plugin eosio::chain_api_plugin  --plugin eosio::chain_plugin  --plugin eosio::producer_api_plugin  --plugin eosio::producer_plugin  --plugin eosio::history_plugin  --plugin eosio::history_api_plugin  --plugin eosio::net_api_plugin \
--contracts-console \
--max-transaction-time=200 \
--chain-state-db-size-mb 1024 \
--enable-stale-production \
--producer-name producer.one \
--genesis-json ~/nodes/genesis.json \
--blocks-dir ~/nodes/01-node/blocks \
--config-dir ~/nodes/01-node \
--data-dir ~/nodes/01-node \
--http-server-address 127.0.0.1:8889 \
--p2p-listen-endpoint 127.0.0.1:9877 \
--signature-provider EOS8imf2TDq6FKtLZ8mvXPWcd6EF2rQwo8zKdLNzsbU9EiMSt9Lwz=KEY:5KLGj1HGRWbk5xNmoKfrcrQHXvcVJBPdAckoiJgFftXSJjLPp7b \
--p2p-peer-address 127.0.0.1:9876 \
>>~/nodes/01-node/01.log 2>&1 &



nodeos \
--plugin eosio::http_plugin  --plugin eosio::chain_api_plugin  --plugin eosio::chain_plugin  --plugin eosio::producer_api_plugin  --plugin eosio::producer_plugin  --plugin eosio::history_plugin  --plugin eosio::history_api_plugin  --plugin eosio::net_api_plugin \
--contracts-console \
--max-transaction-time=200 \
--chain-state-db-size-mb 1024 \
--enable-stale-production \
--producer-name producer.two \
--genesis-json ~/nodes/genesis.json \
--blocks-dir ~/nodes/02-node/blocks \
--config-dir ~/nodes/02-node \
--data-dir ~/nodes/02-node \
--http-server-address 127.0.0.1:8890 \
--p2p-listen-endpoint 127.0.0.1:9878 \
--signature-provider EOS7Ef4kuyTbXbtSPP5Bgethvo6pbitpuEz2RMWhXb8LXxEgcR7MC=KEY:5K6qk1KaCYYWX86UhAfUsbMwhGPUqrqHrZEQDjs9ekP5j6LgHUu \
--p2p-peer-address 127.0.0.1:9876 \
--p2p-peer-address 127.0.0.1:9877 \
>>~/nodes/02-node/02.log 2>&1 &




nodeos \
--plugin eosio::http_plugin  --plugin eosio::chain_api_plugin  --plugin eosio::chain_plugin  --plugin eosio::producer_api_plugin  --plugin eosio::producer_plugin  --plugin eosio::history_plugin  --plugin eosio::history_api_plugin  --plugin eosio::net_api_plugin \
--contracts-console \
--max-transaction-time=200 \
--chain-state-db-size-mb 1024 \
--enable-stale-production \
--producer-name produc.three \
--genesis-json ~/nodes/genesis.json \
--blocks-dir ~/nodes/03-node/blocks \
--config-dir ~/nodes/03-node \
--data-dir ~/nodes/03-node \
--http-server-address 127.0.0.1:8891 \
--p2p-listen-endpoint 127.0.0.1:9879 \
--signature-provider EOS5n442Qz4yVc4LbdPCDnxNSseAiUCrNjRxAfPhUvM8tWS5svid6=KEY:5JCStvbRgUZ6hjyfUiUaxt5iU3HP6zC1kwx3W7SweaEGvs4EPfQ \
--p2p-peer-address 127.0.0.1:9876 \
--p2p-peer-address 127.0.0.1:9877 \
--p2p-peer-address 127.0.0.1:9878 \
>>~/nodes/03-node/03.log 2>&1 &



nodeos \
--plugin eosio::http_plugin  --plugin eosio::chain_api_plugin  --plugin eosio::chain_plugin  --plugin eosio::producer_api_plugin  --plugin eosio::producer_plugin  --plugin eosio::history_plugin  --plugin eosio::history_api_plugin  --plugin eosio::net_api_plugin \
--contracts-console \
--max-transaction-time=200 \
--chain-state-db-size-mb 1024 \
--enable-stale-production \
--producer-name produce.four \
--genesis-json ~/nodes/genesis.json \
--blocks-dir ~/nodes/04-node/blocks \
--config-dir ~/nodes/04-node \
--data-dir ~/nodes/04-node \
--http-server-address 127.0.0.1:8892 \
--p2p-listen-endpoint 127.0.0.1:9880 \
--signature-provider EOS5y3Tm1czTCia3o3JidVKmC78J9gRQU8qHjmRjFxTyhh2vxvF5d=KEY:5JJjaKnAb9KM2vkkJDgrYXoeUEdGgWtB5WK1a38wrmKnS3KtkS6 \
--p2p-peer-address 127.0.0.1:9876 \
--p2p-peer-address 127.0.0.1:9877 \
--p2p-peer-address 127.0.0.1:9878 \
--p2p-peer-address 127.0.0.1:9879 \
>>~/nodes/04-node/04.log 2>&1 &



cleos system voteproducer prods producer.one producer.one producer.two produc.three produce.four
cleos system voteproducer prods producer.two producer.two produc.three produce.four
cleos system voteproducer prods produc.three produc.three produce.four
cleos system voteproducer prods produce.four produce.four


cleos system listproducers

cleos get account eosio


cleos push action eosio updateauth '{"account": "eosio", "permission": "owner", "parent": "", "auth": {"threshold": 1, "keys": [], "waits": [], "accounts": [{"weight": 1, "permission": {"actor": "eosio.prods", "permission": "active"}}]}}' -p eosio@owner
cleos push action eosio updateauth '{"account": "eosio", "permission": "active", "parent": "owner", "auth": {"threshold": 1, "keys": [], "waits": [], "accounts": [{"weight": 1, "permission": {"actor": "eosio.prods", "permission": "active"}}]}}' -p eosio@active
cleos get account eosio


cleos push action eosio updateauth '{"account": "eosio.bpay", "permission": "owner", "parent": "", "auth": {"threshold": 1, "keys": [], "waits": [], "accounts": [{"weight": 1, "permission": {"actor": "eosio", "permission": "active"}}]}}' -p eosio.bpay@owner
cleos push action eosio updateauth '{"account": "eosio.bpay", "permission": "active", "parent": "owner", "auth": {"threshold": 1, "keys": [], "waits": [], "accounts": [{"weight": 1, "permission": {"actor": "eosio", "permission": "active"}}]}}' -p eosio.bpay@active
cleos push action eosio updateauth '{"account": "eosio.msig", "permission": "owner", "parent": "", "auth": {"threshold": 1, "keys": [], "waits": [], "accounts": [{"weight": 1, "permission": {"actor": "eosio", "permission": "active"}}]}}' -p eosio.msig@owner
cleos push action eosio updateauth '{"account": "eosio.msig", "permission": "active", "parent": "owner", "auth": {"threshold": 1, "keys": [], "waits": [], "accounts": [{"weight": 1, "permission": {"actor": "eosio", "permission": "active"}}]}}' -p eosio.msig@active
cleos push action eosio updateauth '{"account": "eosio.names", "permission": "owner", "parent": "", "auth": {"threshold": 1, "keys": [], "waits": [], "accounts": [{"weight": 1, "permission": {"actor": "eosio", "permission": "active"}}]}}' -p eosio.names@owner
cleos push action eosio updateauth '{"account": "eosio.names", "permission": "active", "parent": "owner", "auth": {"threshold": 1, "keys": [], "waits": [], "accounts": [{"weight": 1, "permission": {"actor": "eosio", "permission": "active"}}]}}' -p eosio.names@active
cleos push action eosio updateauth '{"account": "eosio.ram", "permission": "owner", "parent": "", "auth": {"threshold": 1, "keys": [], "waits": [], "accounts": [{"weight": 1, "permission": {"actor": "eosio", "permission": "active"}}]}}' -p eosio.ram@owner
cleos push action eosio updateauth '{"account": "eosio.ram", "permission": "active", "parent": "owner", "auth": {"threshold": 1, "keys": [], "waits": [], "accounts": [{"weight": 1, "permission": {"actor": "eosio", "permission": "active"}}]}}' -p eosio.ram@active
cleos push action eosio updateauth '{"account": "eosio.ramfee", "permission": "owner", "parent": "", "auth": {"threshold": 1, "keys": [], "waits": [], "accounts": [{"weight": 1, "permission": {"actor": "eosio", "permission": "active"}}]}}' -p eosio.ramfee@owner
cleos push action eosio updateauth '{"account": "eosio.ramfee", "permission": "active", "parent": "owner", "auth": {"threshold": 1, "keys": [], "waits": [], "accounts": [{"weight": 1, "permission": {"actor": "eosio", "permission": "active"}}]}}' -p eosio.ramfee@active
cleos push action eosio updateauth '{"account": "eosio.saving", "permission": "owner", "parent": "", "auth": {"threshold": 1, "keys": [], "waits": [], "accounts": [{"weight": 1, "permission": {"actor": "eosio", "permission": "active"}}]}}' -p eosio.saving@owner
cleos push action eosio updateauth '{"account": "eosio.saving", "permission": "active", "parent": "owner", "auth": {"threshold": 1, "keys": [], "waits": [], "accounts": [{"weight": 1, "permission": {"actor": "eosio", "permission": "active"}}]}}' -p eosio.saving@active
cleos push action eosio updateauth '{"account": "eosio.stake", "permission": "owner", "parent": "", "auth": {"threshold": 1, "keys": [], "waits": [], "accounts": [{"weight": 1, "permission": {"actor": "eosio", "permission": "active"}}]}}' -p eosio.stake@owner
cleos push action eosio updateauth '{"account": "eosio.stake", "permission": "active", "parent": "owner", "auth": {"threshold": 1, "keys": [], "waits": [], "accounts": [{"weight": 1, "permission": {"actor": "eosio", "permission": "active"}}]}}' -p eosio.stake@active
cleos push action eosio updateauth '{"account": "eosio.token", "permission": "owner", "parent": "", "auth": {"threshold": 1, "keys": [], "waits": [], "accounts": [{"weight": 1, "permission": {"actor": "eosio", "permission": "active"}}]}}' -p eosio.token@owner
cleos push action eosio updateauth '{"account": "eosio.token", "permission": "active", "parent": "owner", "auth": {"threshold": 1, "keys": [], "waits": [], "accounts": [{"weight": 1, "permission": {"actor": "eosio", "permission": "active"}}]}}' -p eosio.token@active
cleos push action eosio updateauth '{"account": "eosio.vpay", "permission": "owner", "parent": "", "auth": {"threshold": 1, "keys": [], "waits": [], "accounts": [{"weight": 1, "permission": {"actor": "eosio", "permission": "active"}}]}}' -p eosio.vpay@owner
cleos push action eosio updateauth '{"account": "eosio.vpay", "permission": "active", "parent": "owner", "auth": {"threshold": 1, "keys": [], "waits": [], "accounts": [{"weight": 1, "permission": {"actor": "eosio", "permission": "active"}}]}}' -p eosio.vpay@active
cleos push action eosio updateauth '{"account": "eosio.rex", "permission": "owner", "parent": "", "auth": {"threshold": 1, "keys": [], "waits": [], "accounts": [{"weight": 1, "permission": {"actor": "eosio", "permission": "active"}}]}}' -p eosio.rex@owner
cleos push action eosio updateauth '{"account": "eosio.rex", "permission": "active", "parent": "owner", "auth": {"threshold": 1, "keys": [], "waits": [], "accounts": [{"weight": 1, "permission": {"actor": "eosio", "permission": "active"}}]}}' -p eosio.rex@active













