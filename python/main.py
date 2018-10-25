import json
def resolveJson():
    file = open("term.json",'r')
    fileJson = json.load(file)
    InitStatus = fileJson['InitStatus']
    FsmArray=fileJson['FsmArray']
    #print(FsmArray)
    CurrentStatus=[]
    Action=[]
    NewStatus=[]
    for a in FsmArray:
        CurrentStatus.append(a['CurrentStatus'])
        Action.append(a['Action'])
        NewStatus.append(a['NewStatus'])
    return (InitStatus,CurrentStatus,Action,NewStatus)
def transferSolidity(strSol):
    file = open("BCMETH.sol",'w')
    file.write(strSol)
    file.close()

result=resolveJson()
InitStatus=result[0]
CurrentStatus=result[1]
Action=result[2]
NewStatus=result[3]

strConfirm='//BCMETH means Blockchain Match Ethereum \npragma solidity ^0.4.24;'+'\n\n'+'contract BCMETH {'+'\n'
strEnumSta='    enum Status{\n        Bought, \n        Deposited,\n        Uninsuranced,\n        Insuranced,\n        Delayed,\n        Undelayed,\n        ClientRefund,\n        Undeposited,\n        Success,\n        InsurCompanyRefund\n    }\n\n'
strEnumAction='    enum Action{\n        ClientDeposit, \n        TimeOut,\n        InsurCompanyDeposit,\n        ClientRefund,\n        FlightDelay,\n        Compensate,\n        InsurCompanyRefund\n}\n\n'
strCurrentStatus='    Status currentStatus;\n'
strConstructor='    constructor () public {\n        currentStatus=Status.'+InitStatus+';\n    }\n\n'
strClientDeposit='    function clientDeposit(Action action) public returns(bool){\n        if(currentStatus==Status.'+CurrentStatus[0]+' && action==Action.'+Action[0]+'){\n            currentStatus=Status.'+NewStatus[0]+';\n            return true;\n        }\n        else\n            return false;\n    }\n\n'
strInsurCompanyDeposit='    function insurCompanyDeposit(Action action) public returns(bool){\n        if(currentStatus==Status.'+ CurrentStatus[2]+'&& action==Action.'+Action[2]+'){\n            currentStatus=Status.'+NewStatus[2]+';\n          return true;\n        }\n        else\n            return false;\n    }\n\n'
strClientRefund='    function clientRefund(Action action) public returns(bool){\n        if(currentStatus==Status.'+ CurrentStatus[4]+'&& action==Action.'+Action[4]+'){\n            currentStatus=Status.'+NewStatus[4]+';\n            return true;\n        }\n        else\n            return false;\n    }\n\n'
strFlightDelay ='    function flightDelay(Action action) public returns(bool){\n        if(currentStatus==Status.'+ CurrentStatus[5]+'&& action==Action.'+Action[5]+'){\n            currentStatus=Status.'+NewStatus[5]+';\n            return true;\n        }\n        else\n            return false;\n    }\n\n'
strCompensate='    function compensate(Action action) public returns(bool){\n        if(currentStatus==Status.'+ CurrentStatus[6]+'&& action==Action.'+Action[6]+'){\n            currentStatus=Status.'+NewStatus[6]+';\n            return true;\n        }\n        else\n            return false;\n    }\n\n'
strInsurCompanyRefund='    function insurCompanyRefund(Action action) public returns(bool){\n        if(currentStatus==Status.'+ CurrentStatus[7]+'&& action==Action.'+Action[7]+'){\n            currentStatus=Status.'+NewStatus[7]+';\n            return true;\n        }\n        else\n            return false;\n    }\n\n'
strEnd="}"
strSol=strConfirm+strEnumSta+strEnumAction+strCurrentStatus+strConstructor+strClientDeposit+strInsurCompanyDeposit+strClientRefund+strFlightDelay+strCompensate+strInsurCompanyRefund+strEnd

transferSolidity(strSol)


