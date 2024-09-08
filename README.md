
This is a Simple Token Exchange contract that allows users to exchange one token for another based on a fixed Exchange Rate.

For Example, if the user has `10 tokenA` then, he can exchange it for `20 tokenB` if the exchange rate is 2.


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
![[Pasted image 20240908170345.png]]

From the screenshot we can conclude that:-
```
tokenA address=0xb5465ED8EcD4F79dD4BE10A7C8e7a50664e5eeEB
tokenB address=0x8059B0AE35c113137694Ba15b2C3585aE77Bb8E9
SimpleDEX address=0x86cA07C6D491Ad7A535c26c5e35442f3e26e8497
ExchangeRate=2
owner of SimpleDEX=0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
```

Now, we add `100 tokenA` and `100 tokenB` to `SimpleDEX` token pool.
![[Pasted image 20240908170731.png]]
![[Pasted image 20240908170751.png]]

Let's see the initial balance of `tokenA` & `tokenB` in `SimpleDEX `contract -
![[Pasted image 20240908170915.png]]

Now lets test the exchangeToken functions and to do that we need a user and fund that user with 10 tokenA and 10 tokenB and then see if the user is able to exchange by calling the `exchangeTokenAForTokenB` & `exchangeTokenBForTokenA` functions.

```
User address=0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2
```

Initial Balance of `tokenA` for User -
![[Pasted image 20240908171358.png]]

Initial Balance of `tokenB` for User -
![[Pasted image 20240908171448.png]]

Before calling the `exchangeTokenAForTokenB` function or the `exchangeTokenBForTokenA` function , we need to approve the `SimpleDEX` contract to spend `tokenA` & `tokenB` as the user.

To do this we need to call approve from the user account-
![[Pasted image 20240908180417.png]]
##### Testing `exchangeTokenBForTokenA` function

Now, let's test `exchangeTokenAForTokenB` by transferring `5 tokenA` from user to contract and since the `Exchange Rate is 2` the user should get back `10 tokenB`. Thus, the end balance of `tokenA` for the user should be `5 tokenA` &` 20 tokenB`. On the other hand , the contract should end up with `100+5=105 tokenA` & `100-10=90 tokenB`.

Final Contract Balance-
![[Pasted image 20240908172139.png]]

Final User Balance-
![[Pasted image 20240908172208.png]]

##### Testing `exchangeTokenBForTokenA` function

Now, let's test `exchangeTokenBForTokenA` by transferring `10 tokenB` from user to contract and since the `Exchange Rate is 2` the user should get back `5 tokenA`. Thus, the end balance of `tokenA` for the user should be `10 tokenA` & `10 tokenB`. On the other hand , the contract should end up with `105-5=100 tokenA` & `90+10=100 tokenB`.

![[Pasted image 20240908172349.png]]

![[Pasted image 20240908172408.png]]



##### Testing `setExchangeRate` function 

Now, let's check the `setExchangeRate` function and test if the owner is only able to change the Exchange Rate

First, we try to call the `setExchangeRate` function with the owner address and get the following output-
![[Pasted image 20240908172748.png]]

It shows that we can change the Exchange Rate as the `owner`.

Next, we try the same with the `user` and get the following output:-

![[Pasted image 20240908172905.png]]

This proves that `onlyOwner` can call this function.
