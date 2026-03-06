export type EvmChains = {
  "monad": { id: 143 };
};
export type EvmContracts = {
  "PredictionMarket": {};
  "PredictionMarketFactory": {};
};
export type FuelChains = {};
export type FuelContracts = {};
export type SvmChains = {};
export type Enums = {};
export type Entities = {
  "Market": {
    readonly "id": string;
    readonly "factory": string;
    readonly "creator": string;
    readonly "resolver": string;
    readonly "collateralToken": string;
    readonly "numOutcomes": number;
    readonly "outcomeTokens": string;
    readonly "orderbooks": string;
    readonly "resolutionBlock": bigint;
    readonly "allowChallenge": boolean;
    readonly "insuranceBond": bigint;
    readonly "metadata": string;
    readonly "status": string;
    readonly "resolvedOutcome": number | undefined;
    readonly "resolvedBlock": bigint | undefined;
    readonly "totalCollateral": bigint;
    readonly "challenger": string | undefined;
    readonly "challengerBond": bigint | undefined;
    readonly "challengerProposedOutcome": number | undefined;
    readonly "challengeStatus": string;
    readonly "createdAt": bigint;
    readonly "createdAtBlock": bigint;
  };
  "MarketActivity": {
    readonly "id": string;
    readonly "market_id": string;
    readonly "type": string;
    readonly "user": string;
    readonly "amount": bigint;
    readonly "outcome": number | undefined;
    readonly "timestamp": bigint;
    readonly "blockNumber": bigint;
  };
};