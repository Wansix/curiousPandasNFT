// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";


// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract CuriousPandasNFT is ERC721Enumerable, Ownable{
    struct NFTCounts{    
        uint whitelist1;
        uint whitelist2;    
        uint public1;        
    }   

    enum MintPhase {whitelist1, whitelist2, public1}
    enum Phase {init, whitelist1, waitingWhitelist2, whitelist2, waitingPublic1, public1, done}
    uint256 public stage = 1;
    Phase public currentPhase = Phase.init;   
    string public metadataURI = "https://curiouspandasnft.com/testJsons";    // 수정 필요        

    uint256 public totalNFTAmount = 3000;
    uint256 public totalSaleNFTAmount = 50;
    uint256 public initSupply = 0;
    address public mintDepositAddress;  

    uint256[] public saleTotalAmount = [10, 10, 0]; // whitelist1 : 50, whitelist2 : 100  , public1은 constructor에서 생성   
    uint256[] public saleRemainAmount = [0, 0, 0]; 
    uint256[] public maxPerWallet = [10, 10, 30]; // whitelist1 : 1, whitelist2 : 2, public1 : 2    
    uint256[] public maxPerTransaction = [10, 10, 10]; 

    uint256[] public mintStartBlockNumber = [block.number + 10*60,block.number + 60*60,block.number + 130*60];
    uint256[] public mintEndBlockNumber = [block.number + 30*60,block.number + 120*60,block.number + 200*60];

    uint256 public _antibotInterval = 3;
    
    
    mapping (MintPhase => uint256) public mintPriceList;
    mapping (uint256 => mapping(address => NFTCounts)) public NFTCountsList;

    mapping (uint256 => mapping(address => bool)) public _whitelistedAddress;
    mapping (uint256 => mapping(address => bool)) public _whitelistedAddress2;
    mapping (address => uint256) public _lastCallBlockNumber;

    constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol) {
        mintDepositAddress = owner();     
        saleTotalAmount[uint256(MintPhase.public1)] = totalSaleNFTAmount - saleTotalAmount[uint256(MintPhase.whitelist1)] - saleTotalAmount[uint256(MintPhase.whitelist2)];
        
        for(uint i = 0; i < 3; i++)
        {
            saleRemainAmount[i] = saleTotalAmount[i];
        }
        
        _whitelistedAddress[stage][owner()] = true;  //추후 삭제 필요
        _whitelistedAddress[stage][0xC13dC1a385F525A28ACD1f5bB251198DeB4b3d09] = true;  //추후 삭제 필요
        _whitelistedAddress[stage][0xDFc3a935e3e428413f0307FCceef074a5742879B] = true;  //추후 삭제 필요

        _whitelistedAddress2[stage][0xA1390f1c2c97e528d48f3254f292a339f9014424] = true;  //추후 삭제 필요
        _whitelistedAddress2[stage][0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266] = true;  //추후 삭제 필요
    }    

    function getDatas() public view returns (uint256, uint256, Phase, uint256, uint256, uint256, uint256[] memory, uint256[] memory, uint256[] memory, uint256[] memory, uint256[] memory, uint256[] memory){
        return (
         block.number,
         stage,         
         currentPhase, 
         totalNFTAmount, 
         totalSaleNFTAmount,
         initSupply,
         saleTotalAmount,
         saleRemainAmount,
         maxPerWallet,
         maxPerTransaction,
         mintStartBlockNumber,
         mintEndBlockNumber         
         );
    }

    function getMintInfo(address _address) public view returns(uint256, uint256, bool, bool)
    {
        uint256 mintPhase = getMintPhase();        
        uint256 NFTCount;
        if(mintPhase == 0) //whitelist1
        {
            NFTCount =  NFTCountsList[stage][_address].whitelist1;
        }
        else if(mintPhase == 1) // whitelist2
        {
            NFTCount =  NFTCountsList[stage][_address].whitelist2;
        }
        else // public
        {
            NFTCount =  NFTCountsList[stage][_address].public1;
        }

        return (
          mintPriceList[MintPhase(mintPhase)],     
          NFTCount,     
          _whitelistedAddress[stage][_address],
          _whitelistedAddress2[stage][_address]
        );
    }

    function addWhitelist(uint256 index, address holder) public onlyOwner {
        if(index == 0) _whitelistedAddress[stage][holder] = true;
        if(index == 1) _whitelistedAddress2[stage][holder] = true;
    }

    function addToWhitelist(uint256 index, address[] calldata toAddAddresses) public onlyOwner
    {        
        if(index == 0)
        {
            for (uint i = 0; i < toAddAddresses.length; i++)
            {
                _whitelistedAddress[stage][toAddAddresses[i]] = true;
            }                 
        }
        else if(index == 1)
        {
            for (uint i = 0; i < toAddAddresses.length; i++)
            {
                _whitelistedAddress2[stage][toAddAddresses[i]] = true;
            }            
        }        
    }

    function removeWhitelist(uint256 index, address holder) public onlyOwner {
        if(index == 0) _whitelistedAddress[stage][holder] = false;
        if(index == 1) _whitelistedAddress2[stage][holder] = false;
    }

    function setTotalSaleNFTAmount (uint256 _totalSaleNFTAmount) public onlyOwner {
        totalSaleNFTAmount = _totalSaleNFTAmount;   
    }

    function setInitSupply (uint256 _initSupply) public onlyOwner {
        initSupply = _initSupply;
    }

    function setMintStartBlockTimeAuto(uint256 startMin1, uint256 endMin1, uint256 startMin2, uint256 endMin2, uint256 startMin3, uint256 endMin3) public onlyOwner{        
        mintStartBlockNumber[0] = block.number + startMin1*60;
        mintStartBlockNumber[1] = block.number + startMin2*60;
        mintStartBlockNumber[2] = block.number + startMin3*60;

        mintEndBlockNumber[0] = block.number + endMin1*60;
        mintEndBlockNumber[1] = block.number + endMin2*60;
        mintEndBlockNumber[2] = block.number + endMin3*60;
    }

    function setMintBlockTime(uint256 index, uint256 start, uint256 end) public onlyOwner{        
        mintStartBlockNumber[index] = block.number + (start * 60);
        mintEndBlockNumber[index] = block.number + (end * 60);
    }

    function setValues (uint256 select, uint256[] calldata _values) public onlyOwner{
        if(select == 0) // totalAmount 설정
        {
            for (uint i = 0; i < saleTotalAmount.length; i++)
            {
                saleTotalAmount[i] = _values[i];
            }
        }
        if(select == 1) // remainAmount 설정
        {
            for (uint i = 0; i < saleTotalAmount.length; i++)
            {
                saleRemainAmount[i] = _values[i];
            }
        }
        if(select == 2) // maxPerWallet 설정
        {
            for (uint i = 0; i < saleTotalAmount.length; i++)
            {
                maxPerWallet[i] = _values[i];
            }
        }
        if(select == 3) // maxPerTransaction 설정
        {
            for (uint i = 0; i < saleTotalAmount.length; i++)
            {
                maxPerTransaction[i] = _values[i];
            }
        }
    }

    function setMintPrice(MintPhase phase, uint256 _mintPrice) public onlyOwner {        
        mintPriceList[phase] = _mintPrice; 
    }

    function getMintPhase() public view returns (uint256){

        if(currentPhase <= Phase.whitelist1) return 0; //whitelist1
        if(currentPhase <= Phase.whitelist2) return 1; // whitelist2
        return 2; // public1
    }

    // 수동으로 phase를 옮겨주어야함.
    function advancePhase() public onlyOwner{        
        if(currentPhase != Phase.done){
            uint nextPhase = uint(currentPhase) + 1;
            currentPhase = Phase(nextPhase); 

   
            if(currentPhase == Phase.waitingWhitelist2)           
            {
                uint256 preIndex;
                uint256 index;

                preIndex = uint256(MintPhase.whitelist1);
                index = uint256(MintPhase.whitelist2);          

                saleTotalAmount[index] += saleRemainAmount[preIndex];
                saleRemainAmount[index] = saleTotalAmount[index];
                saleRemainAmount[preIndex] = 0;      
            }
            if(currentPhase == Phase.waitingPublic1)
            {
                uint256 preIndex;
                uint256 index;

                preIndex = uint256(MintPhase.whitelist2);
                index = uint256(MintPhase.public1); 

                saleTotalAmount[index] += saleRemainAmount[preIndex];
                saleRemainAmount[index] = saleTotalAmount[index];
                saleRemainAmount[preIndex] = 0;                  
            }        
            if(currentPhase == Phase.done)
            {
                initSupply = totalSupply();
            }
        }
    }
    function backPhase() public onlyOwner{        
        if(currentPhase != Phase.init){
            uint nextPhase = uint(currentPhase) - 1;
            currentPhase = Phase(nextPhase);
        }
    }

    function resetPhase() public onlyOwner{
        currentPhase = Phase(Phase.init);
        stage += 1;
    }

    function mintNFT_Owner(address to) public onlyOwner{        
        require(totalSupply() < totalNFTAmount, "You can no longer mint NFT."); 
        uint tokenId = totalSupply() + 1;
        _mint(to, tokenId);
    }

    function batchMintNFT_Owner(uint _amount, address to) public onlyOwner{   
        for(uint i = 0; i < _amount; i++) {
            mintNFT_Owner(to);
        }

        initSupply = totalSupply();
    }

    function updateAmount() private {
        if(currentPhase == Phase.whitelist1)
        {            
            NFTCountsList[stage][msg.sender].whitelist1++;            
        }
        else if(currentPhase == Phase.whitelist2)
        {            
            NFTCountsList[stage][msg.sender].whitelist2++;            
        }
        else if(currentPhase == Phase.public1)
        {            
            NFTCountsList[stage][msg.sender].public1++;             
        }

        saleRemainAmount[getMintPhase()]--;      
    }

    function mintNFT() private { 
        uint tokenId = totalSupply() + 1;
        updateAmount();
        _mint(msg.sender, tokenId);        
    }   

    function batchMintNFT(uint _amount) public payable{  

        uint256 mintPhaseIndex = getMintPhase();
        require(_lastCallBlockNumber[msg.sender] + _antibotInterval < block.number, "Bot is not allowed");
        require(currentPhase==Phase.whitelist1 || currentPhase==Phase.whitelist2 || currentPhase==Phase.public1,"no mint stage");
        require(block.number >= mintStartBlockNumber[mintPhaseIndex], "Not yet started");
        require(block.number < mintEndBlockNumber[mintPhaseIndex], "End mint time");
        require((totalSupply() + _amount) <= totalSaleNFTAmount + initSupply, "You can no longer mint NFT.");   
        require(msg.value >= (mintPriceList[MintPhase(mintPhaseIndex)]*_amount), "Not enough klay.");
        require(_amount <= maxPerTransaction[mintPhaseIndex], "Over max transaction");
        require(saleRemainAmount[mintPhaseIndex] > 0, "no amount! sold out!");

        
        if(currentPhase == Phase.whitelist1)
        {           
            require((NFTCountsList[stage][msg.sender].whitelist1 + _amount) <= maxPerWallet[mintPhaseIndex], "whitelist1 limit!");
            require(_whitelistedAddress[stage][msg.sender] == true, "not whitelist1");
        } 
        if(currentPhase == Phase.whitelist2)
        {           
            require((NFTCountsList[stage][msg.sender].whitelist2 + _amount) <= maxPerWallet[mintPhaseIndex], "whitelist2 limit!");
            require(_whitelistedAddress2[stage][msg.sender] == true, "not whitelist2");
        } 
        if(currentPhase == Phase.public1)
        {           
            require((NFTCountsList[stage][msg.sender].public1 + _amount) <= maxPerWallet[mintPhaseIndex], "public1 limit!");
        } 
      
        for(uint i = 0; i < _amount; i++) {
            mintNFT();
        }
        payable(mintDepositAddress).transfer(msg.value);

        _lastCallBlockNumber[msg.sender] = block.number;
    }

    function tokenURI(uint _tokenId) override public view returns (string memory) { 
        return string(abi.encodePacked(metadataURI, '/', Strings.toString(_tokenId), '.json'));
    }

    function setTokenURI(string memory _metadataURI) public onlyOwner {        
        metadataURI = _metadataURI;
    }

    function setMintDeposit(address _mintDepositAddress) public onlyOwner{        
        mintDepositAddress = _mintDepositAddress;
    }
}
