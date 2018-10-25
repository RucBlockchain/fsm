//BCMETH means Blockchain Match Ethereum 
pragma solidity ^0.4.24;

contract BCMETH {
    enum Status{
        Bought, 
        Deposited,
        Uninsuranced,
        Insuranced,
        Delayed,
        Undelayed,
        ClientRefund,
        Undeposited,
        Success,
        InsurCompanyRefund
    }

    enum Action{
        ClientDeposit, 
        TimeOut,
        InsurCompanyDeposit,
        ClientRefund,
        FlightDelay,
        Compensate,
        InsurCompanyRefund
}

    Status currentStatus;
    constructor () public {
        currentStatus=Status.Bought;
    }

    function clientDeposit(Action action) public returns(bool){
        if(currentStatus==Status.Bought && action==Action.ClientDeposit){
            currentStatus=Status.Deposited;
            return true;
        }
        else
            return false;
    }

    function insurCompanyDeposit(Action action) public returns(bool){
        if(currentStatus==Status.Deposited&& action==Action.InsurCompanyDeposit){
            currentStatus=Status.Insuranced;
          return true;
        }
        else
            return false;
    }

    function clientRefund(Action action) public returns(bool){
        if(currentStatus==Status.Uninsuranced&& action==Action.ClientRefund){
            currentStatus=Status.ClientRefund;
            return true;
        }
        else
            return false;
    }

    function flightDelay(Action action) public returns(bool){
        if(currentStatus==Status.Insuranced&& action==Action.FlightDelay){
            currentStatus=Status.Delayed;
            return true;
        }
        else
            return false;
    }

    function compensate(Action action) public returns(bool){
        if(currentStatus==Status.Delayed&& action==Action.Compensate){
            currentStatus=Status.Success;
            return true;
        }
        else
            return false;
    }

    function insurCompanyRefund(Action action) public returns(bool){
        if(currentStatus==Status.Undelayed&& action==Action.InsurCompanyRefund){
            currentStatus=Status.InsurCompanyRefund;
            return true;
        }
        else
            return false;
    }

}