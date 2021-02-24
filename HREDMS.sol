

contract ActivateContract {
    
    string public ProductOwner;
    string public Goodstate;
    string public SystemmMessage;
    constructor() public{           //先預設一項產品資料
        productList[2001]=Product("Customer",2001,"Product1",2000);
        ProductOwner=productList[2001].ProductOwner;
        RegulatorList[msg.sender]=Regulator(msg.sender,"Donothing");
    }
    function RetailerRegister() public{
            RetailerList[msg.sender]=Retailer(msg.sender);
    }
    function CustomerRegister() public{
            CustomerList[msg.sender]=Customer(msg.sender,1001,2001,3000,"Customer",50,100,false,false,"Kevin","091234567");
    }
    function MaintainerRegister() public{
        MaintainerList[msg.sender]=Maintainer(msg.sender,msg.sender,1000,1000,0);
    }
    function LogisticsCompanyRegister() public{
        LogisticsCompanyList[msg.sender]=LogisticsCompany(msg.sender,1000,1000);
    }
    function ManufacturerRegister()public{
        ManufacturerList[msg.sender]=Manufacturer(msg.sender,false);
    }
    
    //消費者
    struct Customer{
        address CustomerAddr;           //消費者位址
        uint    OrderID;                //訂單編號
        uint    ProductID;              //商品編號
        uint    ProductPrice;           //商品價格
        string  ProductOwner;           //產商品擁有者
        uint    DismantlingCharge;      //維修費用
        uint    Freight;                //運費
        bool    ReturnOrExchangeStatus; //退換貨狀態
        bool    ActivateStatus;         //true=啟動;false=未啟動
        string  CustomerName;            //消費者姓名
        string    CustomerPhoneNum;       //消費者電話
    }
    mapping(address => Customer) CustomerList;
    //零售商
    struct Retailer{
        address RetailerAddr;            //零售商位址
    }
    mapping(address => Retailer) RetailerList;
    //物流公司
    struct LogisticsCompany{
        address LogisticsCompanyAddr;  //物流公司位址
        uint    OrderID;               //訂單編號
        uint    ProductID;             //商品編號
    }
    mapping(address => LogisticsCompany) LogisticsCompanyList;
    //工廠
    struct Manufacturer{
        address ManufacturerAddr;        //物流公司位址
        bool    ReturnOrExchangeStatus;  //退換貨狀態
    }
    mapping(address => Manufacturer) ManufacturerList;
    
    //維修人員
    struct Maintainer{
        address MaintainerAddr;          //維修人員位址
        address CustomerAddr;            //消費者位址
        uint    OrderID;                 //訂單編號
        uint    ProductID;               //產品編號
        uint    DismantlingCharge;       //維修費用
    }
   mapping(address => Maintainer) MaintainerList;
    struct Regulator{
        address RegulatorAddr;          //監管者位址
        string DoSomething;             //監管者處理爭議訊息
    }
    mapping(address => Regulator) RegulatorList;
   //產品資訊
    struct  Product{
        string   ProductOwner ;
        uint  ProductID;               //產品編號
        string ProductName;           //產品名稱
        uint ProductPrice;            //產品價格
    }
    mapping(uint => Product) productList;
    event event_str(string);
function activate(uint OrderID, uint ProductID) public{             //消費者請求退貨
    if (msg.sender==CustomerList[msg.sender].CustomerAddr){
        if(OrderID==CustomerList[msg.sender].OrderID){
            if(ProductID== CustomerList[msg.sender].ProductID){
                
                Goodstate="Waiting for Dismantling";
                emit event_str("Customer activate the Return/Exchange of goods ");
                SystemmMessage="Customer activate the Return/Exchange of goods";
            }
            else{
                emit event_str("ProductID is not true");
                SystemmMessage="ProductID is not true";    
                }
            }
        else{
            emit event_str("OrderID is not true");
            SystemmMessage="OrderID is not true";
            }
        }
    else{
        emit event_str("address is not true");  
        SystemmMessage="address is not true";
        }
}
function quoteprice(address CustomerAddr, uint OrderID,uint ProductID,uint DismantlingCharge) public {   //消費者進行報價
        if (msg.sender==MaintainerList[msg.sender].MaintainerAddr){
            if (CustomerList[CustomerAddr].OrderID==OrderID){
                if(CustomerList[CustomerAddr].ProductID==ProductID){
                    emit event_str("Maintainer quoteprice  is success");
                    SystemmMessage="Maintainer quoteprice  is success";
                    Goodstate="Dismantling";
                    }
                else{
                    emit event_str("ProductID is not correct");
                    SystemmMessage="ProductID is not correct";
                }
            }
            else{
                emit event_str("OrderID is not correct");
                SystemmMessage="OrderID is not correct";
            }
        }
        else{
            emit event_str("Invalid address");
            SystemmMessage="Invalid address";
        }
}
function DeliverComplete(uint ProductID)public{
   
         if (msg.sender==LogisticsCompanyList[msg.sender].LogisticsCompanyAddr){
            emit event_str("The Goods has been delivered ");
            SystemmMessage="The Goods has been delivered";
            Goodstate="Manufacturer Receive the goods";
            productList[ProductID].ProductOwner="Manufacturer";
            ProductOwner=productList[ProductID].ProductOwner;
        }
        else{
            emit event_str("address is not true");
            SystemmMessage="address is not true";
        }
    }
function CompanyDecision(address CustomerAddr,uint OrderID,uint ProductID,bool access ) public{     //廠商做出決策
        if (msg.sender==ManufacturerList[msg.sender].ManufacturerAddr){
            if(OrderID==CustomerList[CustomerAddr].OrderID){
                if(ProductID== CustomerList[CustomerAddr].ProductID){
                    if (access==true){
                        emit event_str("change another goods");
                        Goodstate="change another goods";
                        SystemmMessage="Manufacturer Receive the goods and will change another goods";
                        productList[ProductID].ProductOwner="Manufacturer";
                        ProductOwner=productList[2001].ProductOwner;
                    }
                    else if(access==false){
                        emit event_str("just return the good");
                        Goodstate="return the goods";
                        SystemmMessage="Manufacturer Receive the goods and accept that Customer returns the goods";
                        productList[ProductID].ProductOwner="Manufacturer";
                        ProductOwner=productList[2001].ProductOwner;
                    }
                    }
                else{
                    emit event_str("ProductID is not true");
                    SystemmMessage="ProductID is not true";
                    }
                }
            else{
                emit event_str("OrderID is not true");  
                SystemmMessage="OrderID is not true";
                }
            }
        else{
            emit event_str("address is not true");    
            SystemmMessage="address is not true";
            }
}


function payquoted(address payable To,uint money,uint ProductID)public payable{             //消費者針對拆裝費付款給合約
            transfermoney(To,money);                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
            emit event_str("pay quote of fee is success");
            SystemmMessage="pay quote of fee is success";
            productList[ProductID].ProductOwner="Customer";
            ProductOwner=productList[ProductID].ProductOwner;
            Goodstate="Waiting for deliver";
}
function  transfermoney(address payable To,uint money) public {                                //合約將拆裝費給予拆裝人員
            To.transfer(money * 1 ether );
            emit event_str("money is correct too");
}    
function payfreight(address payable To,uint money,uint ProductID)public payable{            //消費者付運費給合約
            transfermoney(To,money);
            emit event_str("pay Freight of fee is success");
            SystemmMessage="pay Freight of fee is success";
            productList[ProductID].ProductOwner="LogisticsCompany";
            ProductOwner=productList[ProductID].ProductOwner;
            Goodstate="delivering";
}

function paygoodtocustomer(address payable To,uint money,uint ProductID)public payable{         //廠商決定退貨付清貨款給予合約
            transfermoney(To,money);
            emit event_str("pay goods of price to customer is success");
            SystemmMessage="pay goods of price to customer is success";
            productList[ProductID].ProductOwner="Manufacturer";
            ProductOwner=productList[ProductID].ProductOwner;
            Goodstate="Manufacturer Receive";
}


function paygoodtoretailer(address payable To,uint money,uint ProductID)public payable{         //廠商決定退貨付清貨款給予合約
            transfermoney(To,money );
            emit event_str("pay goods of price to retailer is success");
            SystemmMessage="ay goods of price to retailer is success";
            productList[ProductID].ProductOwner="Manufacturer";
            ProductOwner=productList[ProductID].ProductOwner;
            Goodstate="Manufacturer Receive";
}

function Argument()public{                                                                 //處理爭議
             if(msg.sender==RegulatorList[msg.sender].RegulatorAddr){
                emit event_str("may be change ProductOwner?");
                SystemmMessage="Argument is process";
                }
             else{
                emit event_str("you can't use this");
                SystemmMessage="Argument is not process";
                }
}
}