// main.go
package main


import (
  "fmt"
  "reflect"
  "io/ioutil"
  "encoding/json"
  "github.com/looplab/fsm"

  "github.com/hyperledger/fabric/core/chaincode/shim"
	pb "github.com/hyperledger/fabric/protos/peer"
)


type ContractChaincode struct {
}


// Policy结构体
type Policy struct {
  PolicyID              string       `json:"policyID"`
  OrderID               string       `json:"orderID"`
  ClientID              string       `json:"clientID"`
  InsurCompanyID        string       `json:"insurCompanyID"`
  ObjectType            string       `json:"objectType"`
  CreateTime            string       `json:"createTime"`
  Premium               float64      `json:"premium"`
  CashDeposit           float64      `json:"cashDeposit"`
}


// Client结构体
type Client struct {
  ClientID              string       `json:"clientID"`
  ObjectType            string       `json:"objectType"`
  PublicKeyX            string       `json:"publicKeyX"`
  PublicKeyY            string       `json:"publicKeyY"`
  Balance               float64      `json:"balance"`
}


// InsuranceCompany结构体
type InsuranceCompany struct {
  InsurCompanyID        string       `json:"insurCompanyID"`
  ObjectType            string       `json:"objectType"`
  PublicKeyX            string       `json:"publicKeyX"`
  PublicKeyY            string       `json:"publicKeyY"`
  Balance               float64      `json:"balance"`
}


// Order结构体
type Order struct {
  OrderID               string       `json:"orderID"`
  ClientID              string       `json:"clientID"`
  AirlineID             string       `json:"airlineID"`
  ObjectType            string       `json:"objectType"`
  CreateTime            string       `json:"createTime"`
  TicketStatus          string       `json:"ticketStatus"`
}


// Array结构体
type Array struct {
  CurrentStatus   string
  Action          string
  NewStatus       string
}


// term.json结构体
type Terms struct {
  InitStatus     string
  FsmArray       []Array
}


type JsonStruct struct {
}


type EventDesc struct {
	Name string
	Src []string
	Dst string
}


//定义路由器结构类型
type Routers struct {
}


var termNum int
var initStatus string
var fMap = make(map[string]*fsm.FSM)
//定义控制器函数Map类型，便于后续快捷使用
type ControllerMapsType map[string]reflect.Value
//声明控制器函数Map类型变量
var ControllerMaps ControllerMapsType


// =========================================
//       Init - initializes chaincode
// =========================================
func (c *ContractChaincode) Init(stub shim.ChaincodeStubInterface) pb.Response {
	return shim.Success(nil)
}


// ============
//     Main
// ============
func main() {
  err := shim.Start(new(ContractChaincode))
	if err != nil {
		fmt.Printf("Error starting Contract chaincode: %s", err)
	}
}


// ======================================================
//       Invoke - Our entry point for Invocations
// ======================================================
func (c *ContractChaincode) Invoke(stub shim.ChaincodeStubInterface) pb.Response {
	function, args := stub.GetFunctionAndParameters()
	fmt.Println("invoke is running " + function)

  if function == "Check_BuyTicket" {
    return c.Check_BuyTicket(stub)
  } else if function == "Check_FlightDelay" {
    return c.Check_FlightDelay(stub)
  } else if function == "ClientRegist" {
    return c.ClientRegist(stub, args)
  } else if function == "InsurCompanyRegist" {
    return c.InsurCompanyRegist(stub, args)
  } else if function == "BuyTicket" {
    return c.BuyTicket(stub, args)
  } else if function == "InitPolicy" {
    return c.InitPolicy(stub, args)
  } else if function == "QueryByObjectType" {
    return c.QueryByObjectType(stub, args)
  } else if function == "QueryPolicy" {
    return c.QueryPolicy(stub, args)
  } else if function == "QueryOrder" {
    return c.QueryOrder(stub, args)
  } else if function == "QueryState" {
    return c.QueryState(stub, args)
  } else if function == "ClientDeposit" {
    return FsmEvent(stub, args, "ClientDeposit")
  } else if function == "InsurCompanyDeposit" {
    return FsmEvent(stub, args, "InsurCompanyDeposit")
  } else if function == "ClientRefund" {
    return FsmEvent(stub, args, "ClientRefund")
  } else if function == "FlightDelay" {
    return FsmEvent(stub, args, "FlightDelay")
  } else if function == "InsurCompanyRefund" {
    return FsmEvent(stub, args, "InsurCompanyRefund")
  } else if function == "Compensate" {
    return FsmEvent(stub, args, "Compensate")
  } else if function == "TimeOut" {
    return FsmEvent(stub, args, "TimeOut")
  } else {
    return shim.Error("Function" + function + " doesn't exits, make sure function is right!")
  }

	return shim.Success(nil)
}


func NewJsonStruct() *JsonStruct {
  return &JsonStruct{}
}


func (jst *JsonStruct) Load(filename string, v interface{}) {
  //ReadFile函数会读取文件的全部内容，并将结果以[]byte类型返回
  data, err := ioutil.ReadFile(filename)
  if err != nil {
    return
  }

  //读取的数据为json格式，需要进行解码
  err = json.Unmarshal(data, v)
  if err != nil {
    return
  }
}


func ReadJson() (string, []string, []string, []string){
  var currentStatus []string = make([]string, 0)
  var action []string = make([]string, 0)
  var newStatus []string = make([]string, 0)
  JsonParse := NewJsonStruct()
  v := Terms{}

  //下面使用的是相对路径，term.json文件和main.go文件处于同一目录下
  JsonParse.Load("./term.json", &v)
  initStatus = v.InitStatus
  termNum = len(v.FsmArray)
  for i := 0; i < termNum; i ++ {
    currentStatus = append(currentStatus, v.FsmArray[i].CurrentStatus)
    action = append(action, v.FsmArray[i].Action)
    newStatus = append(newStatus, v.FsmArray[i].NewStatus)
  }
  return initStatus, currentStatus, action, newStatus
}


func InitFSM() *fsm.FSM {
  var events []fsm.EventDesc = make([]fsm.EventDesc, 0)
  initStatus, currentStatus, action, newStatus := ReadJson()
  for i := 0; i < termNum; i ++ {
    events = append(events, fsm.EventDesc{Name: action[i], Src: []string{currentStatus[i]}, Dst: newStatus[i]})
  }
  f := fsm.NewFSM(
    initStatus,
    events,
    fsm.Callbacks{},
  )
  return f;
}


func FsmEvent(stub shim.ChaincodeStubInterface, args []string, event string) pb.Response{
  var ruTest Routers
  var str string
  var resError string

  crMap := make(ControllerMapsType, 0)
  vf := reflect.ValueOf(&ruTest)
  vft := vf.Type()
  //读取方法数量
  mNum := vf.NumMethod()

  //遍历路由器的方法，并将其存入控制器映射变量中
  for i := 0; i < mNum; i++ {
    mName := vft.Method(i).Name
    crMap[mName] = vf.Method(i) //<<<
  }

  policyID := args[0]
  bstatus, err := stub.GetState(policyID)         //从StateDB中读取对应表单的状态
  if err != nil{
    return shim.Error("Query policy status fail, policy ID: " + policyID)
  }

  status := string(bstatus)
  fmt.Println("Policy[" + policyID + "] status:" + status)
  //f := InitFSM(status)        //初始化状态机，并设置当前状态为表单的状态
  f := fMap[policyID]
  err = f.Event(event)        //触发状态机的事件
  if err != nil {
    return shim.Error("Current status is " + status + " not support envent:" + event)
  } else if event == "TimeOut" {
    str = "Done"
  } else {
    //创建带调用方法时需要传入的参数列表
    parms := []reflect.Value{reflect.ValueOf(stub), reflect.ValueOf(args)}
    //使用方法名字符串调用指定方法
    result := crMap[event].Call(parms)
    resError = reflect.Value.String(result[0])
    str = reflect.Value.String(result[1])
  }

  if str != "Done" {
    return shim.Error(resError)
  }

  stub.PutState(policyID, []byte(status))        //更新表单的状态
  status = f.Current()
  fmt.Println("New status:" + status + "\n")
  return shim.Success([]byte(status));           //返回新状态
}


// =============================================================
//        InitPolicy - set policy init status Bought
// =============================================================
func (c *ContractChaincode) InitPolicy(stub shim.ChaincodeStubInterface, args []string) pb.Response {
  var f *fsm.FSM

  //      0
	// "PolicyID"
  if len(args) != 1 {
    return shim.Error("Incorrect number of arguments. Expecting 1")
  }

	if len(args[0]) <= 0 {
		return shim.Error("1st argument must be a non-empty string")
	}

  policyID := args[0]

  f = InitFSM()        //初始化状态机
	fMap[policyID] = f

  stub.PutState(policyID, []byte(initStatus))        //更新表单的状态
  return shim.Success(nil)
}
