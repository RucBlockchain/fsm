
echo
echo "##########################################################"
echo "################### chaincode install ####################"
echo "##########################################################"
echo
sleep 2
peer chaincode install -p chaincodedev/chaincode/contract -n mycc -v 0

echo
echo "##########################################################"
echo "############### chaincode instantiate ####################"
echo "##########################################################"
echo
sleep 2
peer chaincode instantiate -n mycc -v 0 -c '{"Args":["Init"]}' -C myc

sleep 3

cX="b72b32932795f37880940dcc172e206ec1ad113a171d600df8998ed87c120dc5"
cY="f6a60d055f03b65a353e8962706b9e3615cb312ccf81f4bc98e7c1166306f8bf"

echo
echo "##########################################################"
echo "##################### ClientRegist #######################"
echo "##########################################################"
echo
sleep 2
peer chaincode invoke -n mycc -v 1.0 -c '{"Args":["ClientRegist", "1", "'${cX}'", "'${cY}'"]}' -C myc

sleep 3

iX="70abfb4f27f570df417234600aa29303def0fadeff2bf4c36ca52800ae0dd418"
iY="3e0387b4c93d2c4ef9e103f2006e15b5950370a5b977202f45cd375566b0292c"

echo
echo "##########################################################"
echo "################## InsurCompanyRegist ####################"
echo "##########################################################"
echo
sleep 2
peer chaincode invoke -n mycc -v 1.0 -c '{"Args":["InsurCompanyRegist", "1", "'${iX}'", "'${iY}'"]}' -C myc

sleep 3

echo
echo "##########################################################"
echo "################### Check_BuyTicket ######################"
echo "##########################################################"
echo
sleep 2
boolValue=`peer chaincode query -n mycc -v 1.0 -c '{"Args":["Check_BuyTicket"]}' -C myc`
echo $boolValue

if [ "$boolValue" = "Query Result: false" ] ; then
  echo "Ticket has not been bought! EXIT!"
  exit 1
else
  act1="{'Args':['BuyTicket','1','1','1','11:00']}"
  r1="d421d23b986f0a605eb03099d3881e2aeef2183be2537c6de264f537a2faceb8"
  s1="4647fd1efa3317d07798cb18d069aae0052cf6433c1ea9e247d3cf9060f8495a"

  echo
  echo "##########################################################"
  echo "####################### BuyTicket ########################"
  echo "##########################################################"
  echo
  sleep 2
  peer chaincode invoke -n mycc  -v 1.0 -c '{"Args":["BuyTicket","1","1","1","11:00","'${act1}'","'${r1}'","'${s1}'"]}' -C myc

  sleep 3

  echo
  echo "##########################################################"
  echo "###################### QueryOrder ########################"
  echo "##########################################################"
  echo
  sleep 2
  peer chaincode query -n mycc  -v 1.0 -c '{"Args":["QueryByObjectType","order"]}' -C myc

  echo
  echo "##########################################################"
  echo "##################### InitPolicy #########################"
  echo "##########################################################"
  echo
  sleep 2
  peer chaincode invoke -n mycc  -v 1.0 -c '{"Args":["InitPolicy","1"]}' -C myc

  sleep 3

  #echo
  #echo "##########################################################"
  #echo "######################## timeOut #########################"
  #echo "##########################################################"
  #echo
  #sleep 2
  #peer chaincode invoke -n mycc  -v 1.0 -c '{"Args":["TimeOut","1"]}' -C myc

  #sleep 1
  #echo "Client didn't deposit during the required time!"

  #exit 1

  act2="{'Args':['ClientDeposit','1','1','1','1','12:00']}"
  r2="bc6245269ffaae5bfe13f1d10e23f57109f5c59db440bee01cb8617485e47ae3"
  s2="ee201ffca59cefa63f3fcd41ffccecf43464caa332117a032549dc73505675c3"

  echo
  echo "##########################################################"
  echo "#################### ClientDeposit #######################"
  echo "##########################################################"
  echo
  sleep 2
  peer chaincode invoke -n mycc  -v 1.0 -c '{"Args":["ClientDeposit","1","1","1","1","12:00","'${act2}'","'${r2}'","'${s2}'"]}' -C myc

  sleep 3

  #echo
  #echo "##########################################################"
  #echo "######################## TimeOut #########################"
  #echo "##########################################################"
  #echo
  #sleep 2
  #peer chaincode invoke -n mycc  -v 1.0 -c '{"Args":["TimeOut","11"]}' -C myc

  #sleep 1
  #echo "Insurance company didn't deposit during the required time!"

  #act3="{'Args':['ClientRefund','1','1']}"
  #r3="2579bfac2ce1d8069fc67c5e6ff8fb8bea63b8d562d61eda2fc5547532331cd1"
  #s3="392ea4316d4fd01442b1ed731327e46a20e9767f0646d35406e28fd89b9d0282"

  #echo
  #echo "##########################################################"
  #echo "####################### ClientRefund #####################"
  #echo "##########################################################"
  #echo
  #sleep 2
  #peer chaincode invoke -n mycc  -v 1.0 -c '{"Args":["ClientRefund","1","1","'${act3}'","'${r3}'","'${s3}'"]}' -C myc

  #sleep 1

  #exit 1

  echo
  echo "##########################################################"
  echo "##################### QueryPolicy ########################"
  echo "##########################################################"
  echo
  sleep 2
  peer chaincode query -n mycc -v 1.0 -c '{"Args":["QueryByObjectType","policy"]}' -C myc

  Act1="{'Args':['InsurCompanyDeposit','1','1','1','1','12:00']}"
  R1="295b7f6edcad31f63f5edfb3680a0d370aa9a7f2103e77d0a27523a3d1c99e3"
  S1="3a09e21aeef4e7d1b0a254f368a62b8c8272560cb044153c41e64fb335d9ea9c"

  echo
  echo "##########################################################"
  echo "################# InsurCompanyDeposit ####################"
  echo "##########################################################"
  echo
  sleep 2
  peer chaincode invoke -n mycc -v 1.0 -c '{"Args":["InsurCompanyDeposit","1","1","1","1","12:00","'${Act1}'","'${R1}'","'${S1}'"]}' -C myc
  sleep 3

  echo
  echo "##########################################################"
  echo "##################### QueryPolicy ########################"
  echo "##########################################################"
  echo
  sleep 2
  peer chaincode query -n mycc  -v 1.0 -c '{"Args":["QueryByObjectType","policy"]}' -C myc

  echo
  echo "##########################################################"
  echo "################# Check_FlightDelay ######################"
  echo "##########################################################"
  echo
  sleep 2
  boolValue=`peer chaincode query -n mycc  -v 1.0 -c '{"Args":["Check_FlightDelay"]}' -C myc`
  echo $boolValue

  if [ "$boolValue" = "Query Result: true" ] ; then
    echo
    echo "##########################################################"
    echo "###################### FlightDelay #######################"
    echo "##########################################################"
    echo
    sleep 2

    peer chaincode invoke -n mycc  -v 1.0 -c '{"Args":["FlightDelay","1","1","DELAY"]}' -C myc

    sleep 3

    act4="{'Args':['Compensate','1','1']}"
    r4="86183bb5fdb25b64a1d2c451e99be6102f0641153c750bf983aeb6fe19bc2f85"
    s4="c7769287334c8c8a9b8c9085a90249c34116c13f685e720915f2a7600cf6f092"

    echo
    echo "##########################################################"
    echo "###################### Compensate ########################"
    echo "##########################################################"
    echo
    sleep 2

    peer chaincode invoke -n mycc  -v 1.0 -c '{"Args":["Compensate","1","1","'${act4}'","'${r4}'","'${s4}'"]}' -C myc

    sleep 3

    echo "Compensate successfully"
    exit 1
  else

    Act2="{'Args':['InsurCompanyDeposit','1','1']}"
    R2="a851f45f186f319f846f7fa99c9601633bfd9e6dec8420dc33f9add660f6f602"
    S2="892fd23cab322e707e590f865955b2c0142f00c0c920db43ad1e325bfed927"

    echo
    echo "##########################################################"
    echo "################## InsurCompanyDeposit ###################"
    echo "##########################################################"
    echo
    sleep 2

    peer chaincode invoke -n mycc  -v 1.0 -c '{"Args":["InsurCompanyDeposit","1","1","'${Act2}'","'${R2}'","'${S2}'"]}' -C myc

    sleep 3

    echo "Refund successfully"
    exit 1
  fi

  echo
  echo "##########################################################"
  echo "###################### QueryOrder ########################"
  echo "##########################################################"
  echo
  sleep 2
  peer chaincode query -n mycc  -v 1.0 -c '{"Args":["QueryByObjectType","order"]}' -C myc
fi
