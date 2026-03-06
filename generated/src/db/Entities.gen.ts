/* TypeScript file generated from Entities.res by genType. */

/* eslint-disable */
/* tslint:disable */

export type id = string;

export type Market_t = {
  readonly id: id; 
  readonly factory: string; 
  readonly creator: string; 
  readonly resolver: string; 
  readonly collateralToken: string; 
  readonly numOutcomes: number; 
  readonly outcomeTokens: string; 
  readonly orderbooks: string; 
  readonly resolutionBlock: bigint; 
  readonly allowChallenge: boolean; 
  readonly insuranceBond: bigint; 
  readonly metadata: string; 
  readonly status: string; 
  readonly resolvedOutcome: (undefined | number); 
  readonly resolvedBlock: (undefined | bigint); 
  readonly totalCollateral: bigint; 
  readonly challenger: (undefined | string); 
  readonly challengerBond: (undefined | bigint); 
  readonly challengerProposedOutcome: (undefined | number); 
  readonly challengeStatus: string; 
  readonly createdAt: bigint; 
  readonly createdAtBlock: bigint
};

export type Market_indexedFieldOperations = {};

export type MarketActivity_t = {
  readonly id: id; 
  readonly market_id: id; 
  readonly type: string; 
  readonly user: string; 
  readonly amount: bigint; 
  readonly outcome: (undefined | number); 
  readonly timestamp: bigint; 
  readonly blockNumber: bigint
};

export type MarketActivity_indexedFieldOperations = {};
