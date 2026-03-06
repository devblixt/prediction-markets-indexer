/* TypeScript file generated from Types.res by genType. */

/* eslint-disable */
/* tslint:disable */

import type {HandlerContext as $$handlerContext} from './Types.ts';

import type {HandlerWithOptions as $$fnWithEventConfig} from './bindings/OpaqueTypes.ts';

import type {SingleOrMultiple as $$SingleOrMultiple_t} from './bindings/OpaqueTypes';

import type {eventOptions as Internal_eventOptions} from 'envio/src/Internal.gen.js';

import type {genericContractRegisterArgs as Internal_genericContractRegisterArgs} from 'envio/src/Internal.gen.js';

import type {genericContractRegister as Internal_genericContractRegister} from 'envio/src/Internal.gen.js';

import type {genericEvent as Internal_genericEvent} from 'envio/src/Internal.gen.js';

import type {genericHandlerArgs as Internal_genericHandlerArgs} from 'envio/src/Internal.gen.js';

import type {genericHandler as Internal_genericHandler} from 'envio/src/Internal.gen.js';

import type {logger as Envio_logger} from 'envio/src/Envio.gen.js';

import type {t as Address_t} from 'envio/src/Address.gen.js';

export type id = string;
export type Id = id;

export type contractRegistrations = {
  readonly log: Envio_logger; 
  readonly addPredictionMarket: (_1:Address_t) => void; 
  readonly addPredictionMarketFactory: (_1:Address_t) => void
};

export type entityHandlerContext<entity,indexedFieldOperations> = {
  readonly get: (_1:id) => Promise<(undefined | entity)>; 
  readonly getOrThrow: (_1:id, message:(undefined | string)) => Promise<entity>; 
  readonly getWhere: indexedFieldOperations; 
  readonly getOrCreate: (_1:entity) => Promise<entity>; 
  readonly set: (_1:entity) => void; 
  readonly deleteUnsafe: (_1:id) => void
};

export type handlerContext = $$handlerContext;

export type Transaction_t = {};

export type Block_t = {
  readonly number: number; 
  readonly timestamp: number; 
  readonly hash: string
};

export type AggregatedBlock_t = {
  readonly hash: string; 
  readonly number: number; 
  readonly timestamp: number
};

export type AggregatedTransaction_t = {};

export type eventLog<params> = Internal_genericEvent<params,Block_t,Transaction_t>;
export type EventLog<params> = eventLog<params>;

export type SingleOrMultiple_t<a> = $$SingleOrMultiple_t<a>;

export type HandlerTypes_args<eventArgs,context> = { readonly event: eventLog<eventArgs>; readonly context: context };

export type HandlerTypes_contractRegisterArgs<eventArgs> = Internal_genericContractRegisterArgs<eventLog<eventArgs>,contractRegistrations>;

export type HandlerTypes_contractRegister<eventArgs> = Internal_genericContractRegister<HandlerTypes_contractRegisterArgs<eventArgs>>;

export type HandlerTypes_eventConfig<eventFilters> = Internal_eventOptions<eventFilters>;

export type fnWithEventConfig<fn,eventConfig> = $$fnWithEventConfig<fn,eventConfig>;

export type contractRegisterWithOptions<eventArgs,eventFilters> = fnWithEventConfig<HandlerTypes_contractRegister<eventArgs>,HandlerTypes_eventConfig<eventFilters>>;

export type PredictionMarket_chainId = 143;

export type PredictionMarket_Mint_eventArgs = { readonly user: Address_t; readonly amount: bigint };

export type PredictionMarket_Mint_block = Block_t;

export type PredictionMarket_Mint_transaction = Transaction_t;

export type PredictionMarket_Mint_event = {
  /** The parameters or arguments associated with this event. */
  readonly params: PredictionMarket_Mint_eventArgs; 
  /** The unique identifier of the blockchain network where this event occurred. */
  readonly chainId: PredictionMarket_chainId; 
  /** The address of the contract that emitted this event. */
  readonly srcAddress: Address_t; 
  /** The index of this event's log within the block. */
  readonly logIndex: number; 
  /** The transaction that triggered this event. Configurable in `config.yaml` via the `field_selection` option. */
  readonly transaction: PredictionMarket_Mint_transaction; 
  /** The block in which this event was recorded. Configurable in `config.yaml` via the `field_selection` option. */
  readonly block: PredictionMarket_Mint_block
};

export type PredictionMarket_Mint_handlerArgs = Internal_genericHandlerArgs<PredictionMarket_Mint_event,handlerContext>;

export type PredictionMarket_Mint_handler = Internal_genericHandler<PredictionMarket_Mint_handlerArgs>;

export type PredictionMarket_Mint_contractRegister = Internal_genericContractRegister<Internal_genericContractRegisterArgs<PredictionMarket_Mint_event,contractRegistrations>>;

export type PredictionMarket_Mint_eventFilter = { readonly user?: SingleOrMultiple_t<Address_t> };

export type PredictionMarket_Mint_eventFiltersArgs = { 
/** The unique identifier of the blockchain network where this event occurred. */
readonly chainId: PredictionMarket_chainId; 
/** Addresses of the contracts indexing the event. */
readonly addresses: Address_t[] };

export type PredictionMarket_Mint_eventFiltersDefinition = 
    false
  | true
  | PredictionMarket_Mint_eventFilter
  | PredictionMarket_Mint_eventFilter[];

export type PredictionMarket_Mint_eventFilters = 
    false
  | true
  | PredictionMarket_Mint_eventFilter
  | PredictionMarket_Mint_eventFilter[]
  | ((_1:PredictionMarket_Mint_eventFiltersArgs) => PredictionMarket_Mint_eventFiltersDefinition);

export type PredictionMarket_Burn_eventArgs = { readonly user: Address_t; readonly amount: bigint };

export type PredictionMarket_Burn_block = Block_t;

export type PredictionMarket_Burn_transaction = Transaction_t;

export type PredictionMarket_Burn_event = {
  /** The parameters or arguments associated with this event. */
  readonly params: PredictionMarket_Burn_eventArgs; 
  /** The unique identifier of the blockchain network where this event occurred. */
  readonly chainId: PredictionMarket_chainId; 
  /** The address of the contract that emitted this event. */
  readonly srcAddress: Address_t; 
  /** The index of this event's log within the block. */
  readonly logIndex: number; 
  /** The transaction that triggered this event. Configurable in `config.yaml` via the `field_selection` option. */
  readonly transaction: PredictionMarket_Burn_transaction; 
  /** The block in which this event was recorded. Configurable in `config.yaml` via the `field_selection` option. */
  readonly block: PredictionMarket_Burn_block
};

export type PredictionMarket_Burn_handlerArgs = Internal_genericHandlerArgs<PredictionMarket_Burn_event,handlerContext>;

export type PredictionMarket_Burn_handler = Internal_genericHandler<PredictionMarket_Burn_handlerArgs>;

export type PredictionMarket_Burn_contractRegister = Internal_genericContractRegister<Internal_genericContractRegisterArgs<PredictionMarket_Burn_event,contractRegistrations>>;

export type PredictionMarket_Burn_eventFilter = { readonly user?: SingleOrMultiple_t<Address_t> };

export type PredictionMarket_Burn_eventFiltersArgs = { 
/** The unique identifier of the blockchain network where this event occurred. */
readonly chainId: PredictionMarket_chainId; 
/** Addresses of the contracts indexing the event. */
readonly addresses: Address_t[] };

export type PredictionMarket_Burn_eventFiltersDefinition = 
    false
  | true
  | PredictionMarket_Burn_eventFilter
  | PredictionMarket_Burn_eventFilter[];

export type PredictionMarket_Burn_eventFilters = 
    false
  | true
  | PredictionMarket_Burn_eventFilter
  | PredictionMarket_Burn_eventFilter[]
  | ((_1:PredictionMarket_Burn_eventFiltersArgs) => PredictionMarket_Burn_eventFiltersDefinition);

export type PredictionMarket_Settle_eventArgs = {
  readonly user: Address_t; 
  readonly winningOutcome: bigint; 
  readonly amount: bigint
};

export type PredictionMarket_Settle_block = Block_t;

export type PredictionMarket_Settle_transaction = Transaction_t;

export type PredictionMarket_Settle_event = {
  /** The parameters or arguments associated with this event. */
  readonly params: PredictionMarket_Settle_eventArgs; 
  /** The unique identifier of the blockchain network where this event occurred. */
  readonly chainId: PredictionMarket_chainId; 
  /** The address of the contract that emitted this event. */
  readonly srcAddress: Address_t; 
  /** The index of this event's log within the block. */
  readonly logIndex: number; 
  /** The transaction that triggered this event. Configurable in `config.yaml` via the `field_selection` option. */
  readonly transaction: PredictionMarket_Settle_transaction; 
  /** The block in which this event was recorded. Configurable in `config.yaml` via the `field_selection` option. */
  readonly block: PredictionMarket_Settle_block
};

export type PredictionMarket_Settle_handlerArgs = Internal_genericHandlerArgs<PredictionMarket_Settle_event,handlerContext>;

export type PredictionMarket_Settle_handler = Internal_genericHandler<PredictionMarket_Settle_handlerArgs>;

export type PredictionMarket_Settle_contractRegister = Internal_genericContractRegister<Internal_genericContractRegisterArgs<PredictionMarket_Settle_event,contractRegistrations>>;

export type PredictionMarket_Settle_eventFilter = { readonly user?: SingleOrMultiple_t<Address_t>; readonly winningOutcome?: SingleOrMultiple_t<bigint> };

export type PredictionMarket_Settle_eventFiltersArgs = { 
/** The unique identifier of the blockchain network where this event occurred. */
readonly chainId: PredictionMarket_chainId; 
/** Addresses of the contracts indexing the event. */
readonly addresses: Address_t[] };

export type PredictionMarket_Settle_eventFiltersDefinition = 
    false
  | true
  | PredictionMarket_Settle_eventFilter
  | PredictionMarket_Settle_eventFilter[];

export type PredictionMarket_Settle_eventFilters = 
    false
  | true
  | PredictionMarket_Settle_eventFilter
  | PredictionMarket_Settle_eventFilter[]
  | ((_1:PredictionMarket_Settle_eventFiltersArgs) => PredictionMarket_Settle_eventFiltersDefinition);

export type PredictionMarket_Resolved_eventArgs = {
  readonly resolver: Address_t; 
  readonly outcome: bigint; 
  readonly evidenceUri: string
};

export type PredictionMarket_Resolved_block = Block_t;

export type PredictionMarket_Resolved_transaction = Transaction_t;

export type PredictionMarket_Resolved_event = {
  /** The parameters or arguments associated with this event. */
  readonly params: PredictionMarket_Resolved_eventArgs; 
  /** The unique identifier of the blockchain network where this event occurred. */
  readonly chainId: PredictionMarket_chainId; 
  /** The address of the contract that emitted this event. */
  readonly srcAddress: Address_t; 
  /** The index of this event's log within the block. */
  readonly logIndex: number; 
  /** The transaction that triggered this event. Configurable in `config.yaml` via the `field_selection` option. */
  readonly transaction: PredictionMarket_Resolved_transaction; 
  /** The block in which this event was recorded. Configurable in `config.yaml` via the `field_selection` option. */
  readonly block: PredictionMarket_Resolved_block
};

export type PredictionMarket_Resolved_handlerArgs = Internal_genericHandlerArgs<PredictionMarket_Resolved_event,handlerContext>;

export type PredictionMarket_Resolved_handler = Internal_genericHandler<PredictionMarket_Resolved_handlerArgs>;

export type PredictionMarket_Resolved_contractRegister = Internal_genericContractRegister<Internal_genericContractRegisterArgs<PredictionMarket_Resolved_event,contractRegistrations>>;

export type PredictionMarket_Resolved_eventFilter = { readonly resolver?: SingleOrMultiple_t<Address_t>; readonly outcome?: SingleOrMultiple_t<bigint> };

export type PredictionMarket_Resolved_eventFiltersArgs = { 
/** The unique identifier of the blockchain network where this event occurred. */
readonly chainId: PredictionMarket_chainId; 
/** Addresses of the contracts indexing the event. */
readonly addresses: Address_t[] };

export type PredictionMarket_Resolved_eventFiltersDefinition = 
    false
  | true
  | PredictionMarket_Resolved_eventFilter
  | PredictionMarket_Resolved_eventFilter[];

export type PredictionMarket_Resolved_eventFilters = 
    false
  | true
  | PredictionMarket_Resolved_eventFilter
  | PredictionMarket_Resolved_eventFilter[]
  | ((_1:PredictionMarket_Resolved_eventFiltersArgs) => PredictionMarket_Resolved_eventFiltersDefinition);

export type PredictionMarket_Finalized_eventArgs = { readonly outcome: bigint };

export type PredictionMarket_Finalized_block = Block_t;

export type PredictionMarket_Finalized_transaction = Transaction_t;

export type PredictionMarket_Finalized_event = {
  /** The parameters or arguments associated with this event. */
  readonly params: PredictionMarket_Finalized_eventArgs; 
  /** The unique identifier of the blockchain network where this event occurred. */
  readonly chainId: PredictionMarket_chainId; 
  /** The address of the contract that emitted this event. */
  readonly srcAddress: Address_t; 
  /** The index of this event's log within the block. */
  readonly logIndex: number; 
  /** The transaction that triggered this event. Configurable in `config.yaml` via the `field_selection` option. */
  readonly transaction: PredictionMarket_Finalized_transaction; 
  /** The block in which this event was recorded. Configurable in `config.yaml` via the `field_selection` option. */
  readonly block: PredictionMarket_Finalized_block
};

export type PredictionMarket_Finalized_handlerArgs = Internal_genericHandlerArgs<PredictionMarket_Finalized_event,handlerContext>;

export type PredictionMarket_Finalized_handler = Internal_genericHandler<PredictionMarket_Finalized_handlerArgs>;

export type PredictionMarket_Finalized_contractRegister = Internal_genericContractRegister<Internal_genericContractRegisterArgs<PredictionMarket_Finalized_event,contractRegistrations>>;

export type PredictionMarket_Finalized_eventFilter = { readonly outcome?: SingleOrMultiple_t<bigint> };

export type PredictionMarket_Finalized_eventFiltersArgs = { 
/** The unique identifier of the blockchain network where this event occurred. */
readonly chainId: PredictionMarket_chainId; 
/** Addresses of the contracts indexing the event. */
readonly addresses: Address_t[] };

export type PredictionMarket_Finalized_eventFiltersDefinition = 
    false
  | true
  | PredictionMarket_Finalized_eventFilter
  | PredictionMarket_Finalized_eventFilter[];

export type PredictionMarket_Finalized_eventFilters = 
    false
  | true
  | PredictionMarket_Finalized_eventFilter
  | PredictionMarket_Finalized_eventFilter[]
  | ((_1:PredictionMarket_Finalized_eventFiltersArgs) => PredictionMarket_Finalized_eventFiltersDefinition);

export type PredictionMarket_Expired_eventArgs = { readonly defaultOutcome: bigint };

export type PredictionMarket_Expired_block = Block_t;

export type PredictionMarket_Expired_transaction = Transaction_t;

export type PredictionMarket_Expired_event = {
  /** The parameters or arguments associated with this event. */
  readonly params: PredictionMarket_Expired_eventArgs; 
  /** The unique identifier of the blockchain network where this event occurred. */
  readonly chainId: PredictionMarket_chainId; 
  /** The address of the contract that emitted this event. */
  readonly srcAddress: Address_t; 
  /** The index of this event's log within the block. */
  readonly logIndex: number; 
  /** The transaction that triggered this event. Configurable in `config.yaml` via the `field_selection` option. */
  readonly transaction: PredictionMarket_Expired_transaction; 
  /** The block in which this event was recorded. Configurable in `config.yaml` via the `field_selection` option. */
  readonly block: PredictionMarket_Expired_block
};

export type PredictionMarket_Expired_handlerArgs = Internal_genericHandlerArgs<PredictionMarket_Expired_event,handlerContext>;

export type PredictionMarket_Expired_handler = Internal_genericHandler<PredictionMarket_Expired_handlerArgs>;

export type PredictionMarket_Expired_contractRegister = Internal_genericContractRegister<Internal_genericContractRegisterArgs<PredictionMarket_Expired_event,contractRegistrations>>;

export type PredictionMarket_Expired_eventFilter = { readonly defaultOutcome?: SingleOrMultiple_t<bigint> };

export type PredictionMarket_Expired_eventFiltersArgs = { 
/** The unique identifier of the blockchain network where this event occurred. */
readonly chainId: PredictionMarket_chainId; 
/** Addresses of the contracts indexing the event. */
readonly addresses: Address_t[] };

export type PredictionMarket_Expired_eventFiltersDefinition = 
    false
  | true
  | PredictionMarket_Expired_eventFilter
  | PredictionMarket_Expired_eventFilter[];

export type PredictionMarket_Expired_eventFilters = 
    false
  | true
  | PredictionMarket_Expired_eventFilter
  | PredictionMarket_Expired_eventFilter[]
  | ((_1:PredictionMarket_Expired_eventFiltersArgs) => PredictionMarket_Expired_eventFiltersDefinition);

export type PredictionMarket_ChallengeSubmitted_eventArgs = {
  readonly challenger: Address_t; 
  readonly proposedOutcome: bigint; 
  readonly bondAmount: bigint
};

export type PredictionMarket_ChallengeSubmitted_block = Block_t;

export type PredictionMarket_ChallengeSubmitted_transaction = Transaction_t;

export type PredictionMarket_ChallengeSubmitted_event = {
  /** The parameters or arguments associated with this event. */
  readonly params: PredictionMarket_ChallengeSubmitted_eventArgs; 
  /** The unique identifier of the blockchain network where this event occurred. */
  readonly chainId: PredictionMarket_chainId; 
  /** The address of the contract that emitted this event. */
  readonly srcAddress: Address_t; 
  /** The index of this event's log within the block. */
  readonly logIndex: number; 
  /** The transaction that triggered this event. Configurable in `config.yaml` via the `field_selection` option. */
  readonly transaction: PredictionMarket_ChallengeSubmitted_transaction; 
  /** The block in which this event was recorded. Configurable in `config.yaml` via the `field_selection` option. */
  readonly block: PredictionMarket_ChallengeSubmitted_block
};

export type PredictionMarket_ChallengeSubmitted_handlerArgs = Internal_genericHandlerArgs<PredictionMarket_ChallengeSubmitted_event,handlerContext>;

export type PredictionMarket_ChallengeSubmitted_handler = Internal_genericHandler<PredictionMarket_ChallengeSubmitted_handlerArgs>;

export type PredictionMarket_ChallengeSubmitted_contractRegister = Internal_genericContractRegister<Internal_genericContractRegisterArgs<PredictionMarket_ChallengeSubmitted_event,contractRegistrations>>;

export type PredictionMarket_ChallengeSubmitted_eventFilter = { readonly challenger?: SingleOrMultiple_t<Address_t>; readonly proposedOutcome?: SingleOrMultiple_t<bigint> };

export type PredictionMarket_ChallengeSubmitted_eventFiltersArgs = { 
/** The unique identifier of the blockchain network where this event occurred. */
readonly chainId: PredictionMarket_chainId; 
/** Addresses of the contracts indexing the event. */
readonly addresses: Address_t[] };

export type PredictionMarket_ChallengeSubmitted_eventFiltersDefinition = 
    false
  | true
  | PredictionMarket_ChallengeSubmitted_eventFilter
  | PredictionMarket_ChallengeSubmitted_eventFilter[];

export type PredictionMarket_ChallengeSubmitted_eventFilters = 
    false
  | true
  | PredictionMarket_ChallengeSubmitted_eventFilter
  | PredictionMarket_ChallengeSubmitted_eventFilter[]
  | ((_1:PredictionMarket_ChallengeSubmitted_eventFiltersArgs) => PredictionMarket_ChallengeSubmitted_eventFiltersDefinition);

export type PredictionMarket_ChallengeResolved_eventArgs = {
  readonly fallbackResolver: Address_t; 
  readonly finalOutcome: bigint; 
  readonly slashedParty: Address_t; 
  readonly slashedAmount: bigint
};

export type PredictionMarket_ChallengeResolved_block = Block_t;

export type PredictionMarket_ChallengeResolved_transaction = Transaction_t;

export type PredictionMarket_ChallengeResolved_event = {
  /** The parameters or arguments associated with this event. */
  readonly params: PredictionMarket_ChallengeResolved_eventArgs; 
  /** The unique identifier of the blockchain network where this event occurred. */
  readonly chainId: PredictionMarket_chainId; 
  /** The address of the contract that emitted this event. */
  readonly srcAddress: Address_t; 
  /** The index of this event's log within the block. */
  readonly logIndex: number; 
  /** The transaction that triggered this event. Configurable in `config.yaml` via the `field_selection` option. */
  readonly transaction: PredictionMarket_ChallengeResolved_transaction; 
  /** The block in which this event was recorded. Configurable in `config.yaml` via the `field_selection` option. */
  readonly block: PredictionMarket_ChallengeResolved_block
};

export type PredictionMarket_ChallengeResolved_handlerArgs = Internal_genericHandlerArgs<PredictionMarket_ChallengeResolved_event,handlerContext>;

export type PredictionMarket_ChallengeResolved_handler = Internal_genericHandler<PredictionMarket_ChallengeResolved_handlerArgs>;

export type PredictionMarket_ChallengeResolved_contractRegister = Internal_genericContractRegister<Internal_genericContractRegisterArgs<PredictionMarket_ChallengeResolved_event,contractRegistrations>>;

export type PredictionMarket_ChallengeResolved_eventFilter = { readonly fallbackResolver?: SingleOrMultiple_t<Address_t>; readonly finalOutcome?: SingleOrMultiple_t<bigint> };

export type PredictionMarket_ChallengeResolved_eventFiltersArgs = { 
/** The unique identifier of the blockchain network where this event occurred. */
readonly chainId: PredictionMarket_chainId; 
/** Addresses of the contracts indexing the event. */
readonly addresses: Address_t[] };

export type PredictionMarket_ChallengeResolved_eventFiltersDefinition = 
    false
  | true
  | PredictionMarket_ChallengeResolved_eventFilter
  | PredictionMarket_ChallengeResolved_eventFilter[];

export type PredictionMarket_ChallengeResolved_eventFilters = 
    false
  | true
  | PredictionMarket_ChallengeResolved_eventFilter
  | PredictionMarket_ChallengeResolved_eventFilter[]
  | ((_1:PredictionMarket_ChallengeResolved_eventFiltersArgs) => PredictionMarket_ChallengeResolved_eventFiltersDefinition);

export type PredictionMarketFactory_chainId = 143;

export type PredictionMarketFactory_MarketCreated_eventArgs = {
  readonly market: Address_t; 
  readonly creator: Address_t; 
  readonly resolver: Address_t; 
  readonly collateralToken: Address_t; 
  readonly numOutcomes: bigint; 
  readonly outcomeTokens: Address_t[]; 
  readonly orderbooks: Address_t[]; 
  readonly resolutionBlock: bigint; 
  readonly allowChallenge: boolean; 
  readonly insuranceBond: bigint; 
  readonly metadata: string
};

export type PredictionMarketFactory_MarketCreated_block = Block_t;

export type PredictionMarketFactory_MarketCreated_transaction = Transaction_t;

export type PredictionMarketFactory_MarketCreated_event = {
  /** The parameters or arguments associated with this event. */
  readonly params: PredictionMarketFactory_MarketCreated_eventArgs; 
  /** The unique identifier of the blockchain network where this event occurred. */
  readonly chainId: PredictionMarketFactory_chainId; 
  /** The address of the contract that emitted this event. */
  readonly srcAddress: Address_t; 
  /** The index of this event's log within the block. */
  readonly logIndex: number; 
  /** The transaction that triggered this event. Configurable in `config.yaml` via the `field_selection` option. */
  readonly transaction: PredictionMarketFactory_MarketCreated_transaction; 
  /** The block in which this event was recorded. Configurable in `config.yaml` via the `field_selection` option. */
  readonly block: PredictionMarketFactory_MarketCreated_block
};

export type PredictionMarketFactory_MarketCreated_handlerArgs = Internal_genericHandlerArgs<PredictionMarketFactory_MarketCreated_event,handlerContext>;

export type PredictionMarketFactory_MarketCreated_handler = Internal_genericHandler<PredictionMarketFactory_MarketCreated_handlerArgs>;

export type PredictionMarketFactory_MarketCreated_contractRegister = Internal_genericContractRegister<Internal_genericContractRegisterArgs<PredictionMarketFactory_MarketCreated_event,contractRegistrations>>;

export type PredictionMarketFactory_MarketCreated_eventFilter = {
  readonly market?: SingleOrMultiple_t<Address_t>; 
  readonly creator?: SingleOrMultiple_t<Address_t>; 
  readonly resolver?: SingleOrMultiple_t<Address_t>
};

export type PredictionMarketFactory_MarketCreated_eventFiltersArgs = { 
/** The unique identifier of the blockchain network where this event occurred. */
readonly chainId: PredictionMarketFactory_chainId; 
/** Addresses of the contracts indexing the event. */
readonly addresses: Address_t[] };

export type PredictionMarketFactory_MarketCreated_eventFiltersDefinition = 
    false
  | true
  | PredictionMarketFactory_MarketCreated_eventFilter
  | PredictionMarketFactory_MarketCreated_eventFilter[];

export type PredictionMarketFactory_MarketCreated_eventFilters = 
    false
  | true
  | PredictionMarketFactory_MarketCreated_eventFilter
  | PredictionMarketFactory_MarketCreated_eventFilter[]
  | ((_1:PredictionMarketFactory_MarketCreated_eventFiltersArgs) => PredictionMarketFactory_MarketCreated_eventFiltersDefinition);
