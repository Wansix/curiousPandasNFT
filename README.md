# CuriousPandasNFT 🐼

> **Klaytn 기반 NFT 컬렉션 스마트 컨트랙트 프로젝트**

CuriousPandasNFT는 3단계 민팅 시스템과 화이트리스트 기능을 갖춘 ERC-721 기반 NFT 컬렉션입니다. 각 NFT는 고유한 홈타운과 에너지 시스템을 통해 게임화 요소를 제공합니다.

## 🚀 프로젝트 개요

- **총 공급량**: 3,000개 NFT
- **판매량**: 500개 (단계별 분배)
- **네트워크**: Klaytn (메인넷/바오밥 테스트넷)
- **표준**: ERC-721 (OpenZeppelin 기반)

## ✨ 주요 기능

### 🎯 3단계 민팅 시스템
- **Whitelist1**: 150개 (지갑당 2개, 트랜잭션당 2개)
- **Whitelist2**: 150개 (지갑당 2개, 트랜잭션당 1개)
- **Public**: 200개 (지갑당 1개, 트랜잭션당 1개)

### 🏠 홈타운 시스템
각 NFT마다 4가지 홈타운 중 랜덤 할당:
- **INF** (Infinite)
- **FRE** (Freedom)
- **WAL** (Wall)
- **CUR** (Curious)

### ⚡ 에너지 시스템
- 블록 기반 에너지 관리
- 게임화 요소를 통한 사용자 참여도 증대

### 🛡️ 보안 기능
- **봇 방지**: 블록 간격 제한 (3블록)
- **화이트리스트 관리**: 2개 그룹별 주소 관리
- **단계별 접근 제어**: 각 민팅 단계별 권한 관리

## 🛠️ 기술 스택

- **Solidity**: ^0.8.9
- **Hardhat**: ^2.17.2
- **TypeScript**: ^5.1.3
- **OpenZeppelin**: ^4.9.2
- **네트워크**: Klaytn

## 📁 프로젝트 구조

```
curiousPandasNFT/
├── contracts/
│   └── curiousPandas.sol      # 메인 스마트 컨트랙트
├── scripts/
│   └── deploy.ts              # 배포 스크립트
├── test/
│   └── curiousPandas.ts       # 테스트 코드
├── whitelist1                 # 화이트리스트 1 주소 목록
├── whitelist2                 # 화이트리스트 2 주소 목록
└── contractAddress            # 배포된 컨트랙트 주소
```

## 🚀 시작하기

### 설치
```bash
npm install
```

### 테스트 실행
```bash
npx hardhat test
```

### 배포
```bash
# 바오밥 테스트넷
npm run start-baobab

# 메인넷
npm run start
```

## 🔧 주요 컨트랙트 기능

### 관리자 기능
- `advancePhase()`: 민팅 단계 진행
- `setMintPrice()`: 단계별 가격 설정
- `addToWhitelist()`: 화이트리스트 주소 추가
- `setMintBlockTime()`: 민팅 시간 설정

### 사용자 기능
- `batchMintNFT()`: NFT 민팅
- `getMintInfo()`: 민팅 정보 조회
- `getPandaTokens()`: 소유한 NFT 목록 조회
- `getHomeTown()`: NFT 홈타운 조회

## 📊 컨트랙트 상태 관리

```solidity
enum Phase { 
    init, 
    whitelist1, 
    waitingWhitelist2, 
    whitelist2, 
    waitingPublic1, 
    public1, 
    done 
}
```

## 🌐 프로젝트 정보

### 랜딩 페이지
- **웹사이트**: [Curious Pandas 랜딩 페이지](https://kkad.creatorlink.net/)
- **커뮤니티**: Discord, 밤부숲 플랫폼

### 프로젝트 컨셉
> "Curious Pandas는 3천개의 서로 다른 모습의 PFP로 이루어진 판다 모양의 NFT입니다. 홀더들은 NFT 정보 커뮤니티 플랫폼 밤부숲을 통해 C2E적인 로드맵과 밤부숲의 성장에 따른 패시브한 로드맵의 혜택을 받아볼 수 있습니다. 로드맵이 모두 달성된 후에는 Curious Pandas의 밤부숲으로부터의 독립에 관한 거버넌스 투표를 진행할 예정입니다. 
"

### 로드맵
1. **C2E (Contribute to Earn)**: 밤부숲 활동을 통한 보상 시스템
2. **성장하는 보물 상자**: 5마리 모이면 보물 상자 발견
3. **신분증**: 밤부숲 내 프로필 사진 설정 기능
4. **광고판 & 스테이킹**: 스마트 컨트랙트 기반 광고 수익 분배
5. **독립**: 거버넌스를 통한 밤부숲 독립 결정



