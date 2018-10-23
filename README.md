# fsm


执行过程

Terminal 1
#cd fsm_v1.1/devmode

#./start.sh


Terminal 2
#docker exec -it chaincode bash

#cd contract

#go build

#CORE_PEER_ADDRESS=peer:7052 CORE_CHAINCODE_ID_NAME=mycc:0 ./contract


Terminal 3
#docker exec -it cli bash

#cd scripts

#./test.sh
