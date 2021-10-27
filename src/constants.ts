// @FIXME - import protocol/constants and merge these two files

import JSBI from 'jsbi';



//***********************************************************************\\

export type BigintIsh = JSBI | bigint | string

export enum SolidityType {
  uint8 = 'uint8',
  uint256 = 'uint256'
}

export const SOLIDITY_TYPE_MAXIMA = {
  [SolidityType.uint8]: JSBI.BigInt('0xff'),
  [SolidityType.uint256]: JSBI.BigInt('0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff')
}

// exports for internal consumption
export const ZERO = JSBI.BigInt(0);
export const ONE = JSBI.BigInt(1);
export const FIVE = JSBI.BigInt(5);
export const _997 = JSBI.BigInt(997);
export const _1000 = JSBI.BigInt(1000);

//***********************************************************************\\


export const FACTORY_ADDRESS = '';

export const INIT_CODE_HASH = '';

export const MINIMUM_LIQUIDITY = JSBI.BigInt(1000);


//***********************************************************************\\


// @exports constants
