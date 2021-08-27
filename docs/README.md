## `FixedToken`






### `initToken(string _name, string _symbol, address _owner, uint256 _initialSupply)` (public)



First set the token variables. This can only be done once

### `init(bytes _data)` (external)





### `initToken(bytes _data)` (public)





### `getInitData(string _name, string _symbol, address _owner, uint256 _initialSupply) → bytes _data` (external)



Generates init data for Farm Factory



## `Address`



Collection of functions related to the address type


### `isContract(address account) → bool` (internal)



Returns true if `account` is a contract.

[IMPORTANT]
====
It is unsafe to assume that an address for which this function returns
false is an externally-owned account (EOA) and not a contract.

Among others, `isContract` will return false for the following
types of addresses:

 - an externally-owned account
 - a contract in construction
 - an address where a contract will be created
 - an address where a contract lived, but was destroyed
====

### `sendValue(address payable recipient, uint256 amount)` (internal)



Replacement for Solidity's `transfer`: sends `amount` wei to
`recipient`, forwarding all available gas and reverting on errors.

https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
of certain opcodes, possibly making contracts go over the 2300 gas limit
imposed by `transfer`, making them unable to receive funds via
`transfer`. {sendValue} removes this limitation.

https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].

IMPORTANT: because control is transferred to `recipient`, care must be
taken to not create reentrancy vulnerabilities. Consider using
{ReentrancyGuard} or the
https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].

### `functionCall(address target, bytes data) → bytes` (internal)



Performs a Solidity function call using a low level `call`. A
plain`call` is an unsafe replacement for a function call: use this
function instead.

If `target` reverts with a revert reason, it is bubbled up by this
function (like regular Solidity function calls).

Returns the raw returned data. To convert to the expected return value,
use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].

Requirements:

- `target` must be a contract.
- calling `target` with `data` must not revert.

_Available since v3.1._

### `functionCall(address target, bytes data, string errorMessage) → bytes` (internal)



Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
`errorMessage` as a fallback revert reason when `target` reverts.

_Available since v3.1._

### `functionCallWithValue(address target, bytes data, uint256 value) → bytes` (internal)



Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
but also transferring `value` wei to `target`.

Requirements:

- the calling contract must have an ETH balance of at least `value`.
- the called Solidity function must be `payable`.

_Available since v3.1._

### `functionCallWithValue(address target, bytes data, uint256 value, string errorMessage) → bytes` (internal)



Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
with `errorMessage` as a fallback revert reason when `target` reverts.

_Available since v3.1._

### `functionStaticCall(address target, bytes data) → bytes` (internal)



Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
but performing a static call.

_Available since v3.3._

### `functionStaticCall(address target, bytes data, string errorMessage) → bytes` (internal)



Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
but performing a static call.

_Available since v3.3._

### `functionDelegateCall(address target, bytes data) → bytes` (internal)



Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
but performing a delegate call.

_Available since v3.4._

### `functionDelegateCall(address target, bytes data, string errorMessage) → bytes` (internal)



Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
but performing a delegate call.

_Available since v3.4._


## `Context`






### `_msgSender() → address payable` (internal)





### `_msgData() → bytes` (internal)






## `ERC20`



Implementation of the {IERC20} interface.

This implementation is agnostic to the way tokens are created. This means
that a supply mechanism has to be added in a derived contract using {_mint}.
For a generic mechanism see {ERC20PresetMinterPauser}.

TIP: For a detailed writeup see our guide
https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
to implement supply mechanisms].

We have followed general OpenZeppelin guidelines: functions revert instead
of returning `false` on failure. This behavior is nonetheless conventional
and does not conflict with the expectations of ERC20 applications.

Additionally, an {Approval} event is emitted on calls to {transferFrom}.
This allows applications to reconstruct the allowance for all accounts just
by listening to said events. Other implementations of the EIP may not emit
these events, as it isn't required by the specification.

Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
functions have been added to mitigate the well-known issues around setting
allowances. See {IERC20-approve}.


### `_initERC20(string name_, string symbol_)` (internal)



Sets the values for {name} and {symbol}, initializes {decimals} with
a default value of 18.

To select a different value for {decimals}, use {_setupDecimals}.

All three of these values are immutable: they can only be set once during
construction.

### `name() → string` (public)



Returns the name of the token.

### `symbol() → string` (public)



Returns the symbol of the token, usually a shorter version of the
name.

### `decimals() → uint8` (public)



Returns the number of decimals used to get its user representation.
For example, if `decimals` equals `2`, a balance of `505` tokens should
be displayed to a user as `5,05` (`505 / 10 ** 2`).

Tokens usually opt for a value of 18, imitating the relationship between
Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
called.

NOTE: This information is only used for _display_ purposes: it in
no way affects any of the arithmetic of the contract, including
{IERC20-balanceOf} and {IERC20-transfer}.

### `totalSupply() → uint256` (public)



See {IERC20-totalSupply}.

### `balanceOf(address account) → uint256` (public)



See {IERC20-balanceOf}.

### `transfer(address recipient, uint256 amount) → bool` (public)



See {IERC20-transfer}.

Requirements:

- `recipient` cannot be the zero address.
- the caller must have a balance of at least `amount`.

### `allowance(address owner, address spender) → uint256` (public)



See {IERC20-allowance}.

### `approve(address spender, uint256 amount) → bool` (public)



See {IERC20-approve}.

Requirements:

- `spender` cannot be the zero address.

### `permit(address owner_, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s)` (external)

Approves `value` from `owner_` to be spend by `spender`.




### `transferFrom(address sender, address recipient, uint256 amount) → bool` (public)



See {IERC20-transferFrom}.

Emits an {Approval} event indicating the updated allowance. This is not
required by the EIP. See the note at the beginning of {ERC20};

Requirements:
- `sender` and `recipient` cannot be the zero address.
- `sender` must have a balance of at least `amount`.
- the caller must have allowance for ``sender``'s tokens of at least
`amount`.

### `increaseAllowance(address spender, uint256 addedValue) → bool` (public)



Atomically increases the allowance granted to `spender` by the caller.

This is an alternative to {approve} that can be used as a mitigation for
problems described in {IERC20-approve}.

Emits an {Approval} event indicating the updated allowance.

Requirements:

- `spender` cannot be the zero address.

### `decreaseAllowance(address spender, uint256 subtractedValue) → bool` (public)



Atomically decreases the allowance granted to `spender` by the caller.

This is an alternative to {approve} that can be used as a mitigation for
problems described in {IERC20-approve}.

Emits an {Approval} event indicating the updated allowance.

Requirements:

- `spender` cannot be the zero address.
- `spender` must have allowance for the caller of at least
`subtractedValue`.

### `_transfer(address sender, address recipient, uint256 amount)` (internal)



Moves tokens `amount` from `sender` to `recipient`.

This is internal function is equivalent to {transfer}, and can be used to
e.g. implement automatic token fees, slashing mechanisms, etc.

Emits a {Transfer} event.

Requirements:

- `sender` cannot be the zero address.
- `recipient` cannot be the zero address.
- `sender` must have a balance of at least `amount`.

### `_mint(address account, uint256 amount)` (internal)



Creates `amount` tokens and assigns them to `account`, increasing
the total supply.

Emits a {Transfer} event with `from` set to the zero address.

Requirements

- `to` cannot be the zero address.

### `_burn(address account, uint256 amount)` (internal)



Destroys `amount` tokens from `account`, reducing the
total supply.

Emits a {Transfer} event with `to` set to the zero address.

Requirements

- `account` cannot be the zero address.
- `account` must have at least `amount` tokens.

### `_approve(address owner, address spender, uint256 amount)` (internal)



Sets `amount` as the allowance of `spender` over the `owner` s tokens.

This internal function is equivalent to `approve`, and can be used to
e.g. set automatic allowances for certain subsystems, etc.

Emits an {Approval} event.

Requirements:

- `owner` cannot be the zero address.
- `spender` cannot be the zero address.

### `_setupDecimals(uint8 decimals_)` (internal)



Sets {decimals} to a value other than the default one of 18.

WARNING: This function should only be called from the constructor. Most
applications that interact with token contracts will not expect
{decimals} to ever change, and may work incorrectly if it does.

### `_beforeTokenTransfer(address from, address to, uint256 amount)` (internal)



Hook that is called before any transfer of tokens. This includes
minting and burning.

Calling conditions:

- when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
will be to transferred to `to`.
- when `from` is zero, `amount` tokens will be minted for `to`.
- when `to` is zero, `amount` of ``from``'s tokens will be burned.
- `from` and `to` are never both zero.

To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].


## `IERC20`






### `totalSupply() → uint256` (external)





### `balanceOf(address account) → uint256` (external)





### `allowance(address owner, address spender) → uint256` (external)





### `approve(address spender, uint256 amount) → bool` (external)





### `name() → string` (external)





### `symbol() → string` (external)





### `decimals() → uint8` (external)





### `permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s)` (external)






### `Transfer(address from, address to, uint256 value)`





### `Approval(address owner, address spender, uint256 value)`





## `IMisoToken`






### `init(bytes data)` (external)





### `initToken(bytes data)` (external)





### `tokenTemplate() → uint256` (external)






