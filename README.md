## SimpleDEX

This is a Simple Token Exchange contract that allows users to exchange one token for another based on a fixed Exchange Rate.

For Example, if the user has `10 tokenA` then, he can exchange it for `20 tokenB` if the exchange rate is 2.

### Contract Structure

**:computer:[Code](./contracts/SimpleDEX.sol)**

The contract consists of the following main components:

- IERC20 interface: Defines the standard functions for ERC20 tokens.
- SimpleDEX contract: Implements the token exchange functionality.

### State Variables

- `owner`: Address of the contract owner.
- `tokenA` and `tokenB`: IERC20 interfaces for the two tokens that can be exchanged.
- `exchangeRate`: The fixed rate at which tokens are exchanged.

### Key Functions

1. `constructor(address _tokenA, address _tokenB, uint _exchangeRate)`: Initializes the contract with the addresses of the two tokens and the initial exchange rate.
2. `setExchangeRate(uint _newRate)`: Allows the owner to update the exchange rate.
3. `exchangeTokenAForTokenB(uint amountA)`: Exchanges Token A for Token B.
4. `exchangeTokenBForTokenA(uint amountB)`: Exchanges Token B for Token A.
5. `balanceOfTokenA(address account)` and `balanceOfTokenB(address account)`: View functions to check token balances.
6. `_transferTokens(IERC20 token, address from, address to, uint amount)`: Internal function to handle token transfers safely.

### Testing

To test the contract, we first deploy two Mock ERC20 tokens - `tokenA` & `tokenB`on Remix.

Contract for `tokenA`:-

```js
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MyToken is ERC20 {
    constructor() ERC20("TokenA", "A") {
        _mint(msg.sender, 1000000 * (10 ** uint256(decimals())));
    }
}
```

Contract for `tokenB`:-
```js
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MyToken is ERC20 {
    constructor() ERC20("TokenB", "B") {
        _mint(msg.sender, 1000000 * (10 ** uint256(decimals())));
    }
}
```

Now, we use the address of these two tokens and a fixed `exchangeRate` to deploy the `SimpleDEX` contract.

Deploying `SimpleDEX` contract-

![image](https://github.com/user-attachments/assets/7ee3b0e2-70d7-4131-a725-f5e0c28fb90e)


From the screenshot we can conclude that:-
```
tokenA address=0xb5465ED8EcD4F79dD4BE10A7C8e7a50664e5eeEB
tokenB address=0x8059B0AE35c113137694Ba15b2C3585aE77Bb8E9
SimpleDEX address=0x86cA07C6D491Ad7A535c26c5e35442f3e26e8497
ExchangeRate=2
owner of SimpleDEX=0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
```

Now, we add `100 tokenA` and `100 tokenB` to `SimpleDEX` token pool.
![image](https://github.com/user-attachments/assets/b3b38c4f-3e2a-4005-ae20-433857f74de4)


Let's see the initial balance of `tokenA` & `tokenB` in `SimpleDEX `contract -
![image](https://github.com/user-attachments/assets/e779bdfe-c34c-43a3-9dec-3b06b504c8e2)


Now lets test the exchangeToken functions and to do that we need a user and fund that user with 10 tokenA and 10 tokenB and then see if the user is able to exchange by calling the `exchangeTokenAForTokenB` & `exchangeTokenBForTokenA` functions.

```
User address=0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2
```

Initial Balance of `tokenA` for User -
![image](https://github.com/user-attachments/assets/07eb029e-b4f2-47ec-88c0-a4cb5f45e4e2)


Initial Balance of `tokenB` for User -
![image](https://github.com/user-attachments/assets/1384accb-31f9-447a-8024-0ac845b6965e)


Before calling the `exchangeTokenAForTokenB` function or the `exchangeTokenBForTokenA` function , we need to approve the `SimpleDEX` contract to spend `tokenA` & `tokenB` as the user.

To do this we need to call approve from the user account-
![image](https://github.com/user-attachments/assets/439619bd-660d-4f15-89f2-44e9482abd68)

##### Testing `exchangeTokenBForTokenA` function

Now, let's test `exchangeTokenAForTokenB` by transferring `5 tokenA` from user to contract and since the `Exchange Rate is 2` the user should get back `10 tokenB`. Thus, the end balance of `tokenA` for the user should be `5 tokenA` &` 20 tokenB`. On the other hand , the contract should end up with `100+5=105 tokenA` & `100-10=90 tokenB`.

Contract Balance after exchange-
![image](https://github.com/user-attachments/assets/27fa3f12-5735-439d-839c-004e471383c6)


User Balance after exchange-
![image](https://github.com/user-attachments/assets/7a67c7d9-2423-4863-9665-1aa1ab75328c)


##### Testing `exchangeTokenBForTokenA` function

Now, let's test `exchangeTokenBForTokenA` by transferring `10 tokenB` from user to contract and since the `Exchange Rate is 2` the user should get back `5 tokenA`. Thus, the end balance of `tokenA` for the user should be `10 tokenA` & `10 tokenB`. On the other hand , the contract should end up with `105-5=100 tokenA` & `90+10=100 tokenB`.

User Balance after exchange-
![image](https://github.com/user-attachments/assets/b0f0643f-5f17-4d37-bf72-b62c0353d5cf)

Contract Balance after exchange-
![image](https://github.com/user-attachments/assets/929075ac-7f31-4c00-bac5-3191af06eb5b)




##### Testing `setExchangeRate` function 

Now, let's check the `setExchangeRate` function and test if the owner is only able to change the Exchange Rate

First, we try to call the `setExchangeRate` function with the owner address and get the following output-

![image](https://github.com/user-attachments/assets/cb133979-164c-4b77-aa68-431c838d3d22)


It shows that we can change the Exchange Rate as the `owner`.

Next, we try the same with the `user` and get the following output:-

![image](https://github.com/user-attachments/assets/5593c4c7-4a75-4f5d-b246-d2b27c650a4d)


This proves that `onlyOwner` can call this function.
