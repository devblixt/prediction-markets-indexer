/* TypeScript file generated from TestHelpers.res by genType. */

/* eslint-disable */
/* tslint:disable */

import * as TestHelpersJS from './TestHelpers.res.mjs';

import type {PredictionMarketFactory_MarketCreated_event as Types_PredictionMarketFactory_MarketCreated_event} from './Types.gen.js';

import type {PredictionMarket_Burn_event as Types_PredictionMarket_Burn_event} from './Types.gen.js';

import type {PredictionMarket_ChallengeResolved_event as Types_PredictionMarket_ChallengeResolved_event} from './Types.gen.js';

import type {PredictionMarket_ChallengeSubmitted_event as Types_PredictionMarket_ChallengeSubmitted_event} from './Types.gen.js';

import type {PredictionMarket_Expired_event as Types_PredictionMarket_Expired_event} from './Types.gen.js';

import type {PredictionMarket_Finalized_event as Types_PredictionMarket_Finalized_event} from './Types.gen.js';

import type {PredictionMarket_Mint_event as Types_PredictionMarket_Mint_event} from './Types.gen.js';

import type {PredictionMarket_Resolved_event as Types_PredictionMarket_Resolved_event} from './Types.gen.js';

import type {PredictionMarket_Settle_event as Types_PredictionMarket_Settle_event} from './Types.gen.js';

import type {t as Address_t} from 'envio/src/Address.gen.js';

import type {t as TestHelpers_MockDb_t} from './TestHelpers_MockDb.gen.js';

/** The arguements that get passed to a "processEvent" helper function */
export type EventFunctions_eventProcessorArgs<event> = {
  readonly event: event; 
  readonly mockDb: TestHelpers_MockDb_t; 
  readonly chainId?: number
};

export type EventFunctions_eventProcessor<event> = (_1:EventFunctions_eventProcessorArgs<event>) => Promise<TestHelpers_MockDb_t>;

export type EventFunctions_MockBlock_t = {
  readonly hash?: string; 
  readonly number?: number; 
  readonly timestamp?: number
};

export type EventFunctions_MockTransaction_t = {};

export type EventFunctions_mockEventData = {
  readonly chainId?: number; 
  readonly srcAddress?: Address_t; 
  readonly logIndex?: number; 
  readonly block?: EventFunctions_MockBlock_t; 
  readonly transaction?: EventFunctions_MockTransaction_t
};

export type PredictionMarket_Mint_createMockArgs = {
  readonly user?: Address_t; 
  readonly amount?: bigint; 
  readonly mockEventData?: EventFunctions_mockEventData
};

export type PredictionMarket_Burn_createMockArgs = {
  readonly user?: Address_t; 
  readonly amount?: bigint; 
  readonly mockEventData?: EventFunctions_mockEventData
};

export type PredictionMarket_Settle_createMockArgs = {
  readonly user?: Address_t; 
  readonly winningOutcome?: bigint; 
  readonly amount?: bigint; 
  readonly mockEventData?: EventFunctions_mockEventData
};

export type PredictionMarket_Resolved_createMockArgs = {
  readonly resolver?: Address_t; 
  readonly outcome?: bigint; 
  readonly evidenceUri?: string; 
  readonly mockEventData?: EventFunctions_mockEventData
};

export type PredictionMarket_Finalized_createMockArgs = { readonly outcome?: bigint; readonly mockEventData?: EventFunctions_mockEventData };

export type PredictionMarket_Expired_createMockArgs = { readonly defaultOutcome?: bigint; readonly mockEventData?: EventFunctions_mockEventData };

export type PredictionMarket_ChallengeSubmitted_createMockArgs = {
  readonly challenger?: Address_t; 
  readonly proposedOutcome?: bigint; 
  readonly bondAmount?: bigint; 
  readonly mockEventData?: EventFunctions_mockEventData
};

export type PredictionMarket_ChallengeResolved_createMockArgs = {
  readonly fallbackResolver?: Address_t; 
  readonly finalOutcome?: bigint; 
  readonly slashedParty?: Address_t; 
  readonly slashedAmount?: bigint; 
  readonly mockEventData?: EventFunctions_mockEventData
};

export type PredictionMarketFactory_MarketCreated_createMockArgs = {
  readonly market?: Address_t; 
  readonly creator?: Address_t; 
  readonly resolver?: Address_t; 
  readonly collateralToken?: Address_t; 
  readonly numOutcomes?: bigint; 
  readonly outcomeTokens?: Address_t[]; 
  readonly orderbooks?: Address_t[]; 
  readonly resolutionBlock?: bigint; 
  readonly allowChallenge?: boolean; 
  readonly insuranceBond?: bigint; 
  readonly metadata?: string; 
  readonly mockEventData?: EventFunctions_mockEventData
};

export const MockDb_createMockDb: () => TestHelpers_MockDb_t = TestHelpersJS.MockDb.createMockDb as any;

export const Addresses_mockAddresses: Address_t[] = TestHelpersJS.Addresses.mockAddresses as any;

export const Addresses_defaultAddress: Address_t = TestHelpersJS.Addresses.defaultAddress as any;

export const PredictionMarket_Mint_processEvent: EventFunctions_eventProcessor<Types_PredictionMarket_Mint_event> = TestHelpersJS.PredictionMarket.Mint.processEvent as any;

export const PredictionMarket_Mint_createMockEvent: (args:PredictionMarket_Mint_createMockArgs) => Types_PredictionMarket_Mint_event = TestHelpersJS.PredictionMarket.Mint.createMockEvent as any;

export const PredictionMarket_Burn_processEvent: EventFunctions_eventProcessor<Types_PredictionMarket_Burn_event> = TestHelpersJS.PredictionMarket.Burn.processEvent as any;

export const PredictionMarket_Burn_createMockEvent: (args:PredictionMarket_Burn_createMockArgs) => Types_PredictionMarket_Burn_event = TestHelpersJS.PredictionMarket.Burn.createMockEvent as any;

export const PredictionMarket_Settle_processEvent: EventFunctions_eventProcessor<Types_PredictionMarket_Settle_event> = TestHelpersJS.PredictionMarket.Settle.processEvent as any;

export const PredictionMarket_Settle_createMockEvent: (args:PredictionMarket_Settle_createMockArgs) => Types_PredictionMarket_Settle_event = TestHelpersJS.PredictionMarket.Settle.createMockEvent as any;

export const PredictionMarket_Resolved_processEvent: EventFunctions_eventProcessor<Types_PredictionMarket_Resolved_event> = TestHelpersJS.PredictionMarket.Resolved.processEvent as any;

export const PredictionMarket_Resolved_createMockEvent: (args:PredictionMarket_Resolved_createMockArgs) => Types_PredictionMarket_Resolved_event = TestHelpersJS.PredictionMarket.Resolved.createMockEvent as any;

export const PredictionMarket_Finalized_processEvent: EventFunctions_eventProcessor<Types_PredictionMarket_Finalized_event> = TestHelpersJS.PredictionMarket.Finalized.processEvent as any;

export const PredictionMarket_Finalized_createMockEvent: (args:PredictionMarket_Finalized_createMockArgs) => Types_PredictionMarket_Finalized_event = TestHelpersJS.PredictionMarket.Finalized.createMockEvent as any;

export const PredictionMarket_Expired_processEvent: EventFunctions_eventProcessor<Types_PredictionMarket_Expired_event> = TestHelpersJS.PredictionMarket.Expired.processEvent as any;

export const PredictionMarket_Expired_createMockEvent: (args:PredictionMarket_Expired_createMockArgs) => Types_PredictionMarket_Expired_event = TestHelpersJS.PredictionMarket.Expired.createMockEvent as any;

export const PredictionMarket_ChallengeSubmitted_processEvent: EventFunctions_eventProcessor<Types_PredictionMarket_ChallengeSubmitted_event> = TestHelpersJS.PredictionMarket.ChallengeSubmitted.processEvent as any;

export const PredictionMarket_ChallengeSubmitted_createMockEvent: (args:PredictionMarket_ChallengeSubmitted_createMockArgs) => Types_PredictionMarket_ChallengeSubmitted_event = TestHelpersJS.PredictionMarket.ChallengeSubmitted.createMockEvent as any;

export const PredictionMarket_ChallengeResolved_processEvent: EventFunctions_eventProcessor<Types_PredictionMarket_ChallengeResolved_event> = TestHelpersJS.PredictionMarket.ChallengeResolved.processEvent as any;

export const PredictionMarket_ChallengeResolved_createMockEvent: (args:PredictionMarket_ChallengeResolved_createMockArgs) => Types_PredictionMarket_ChallengeResolved_event = TestHelpersJS.PredictionMarket.ChallengeResolved.createMockEvent as any;

export const PredictionMarketFactory_MarketCreated_processEvent: EventFunctions_eventProcessor<Types_PredictionMarketFactory_MarketCreated_event> = TestHelpersJS.PredictionMarketFactory.MarketCreated.processEvent as any;

export const PredictionMarketFactory_MarketCreated_createMockEvent: (args:PredictionMarketFactory_MarketCreated_createMockArgs) => Types_PredictionMarketFactory_MarketCreated_event = TestHelpersJS.PredictionMarketFactory.MarketCreated.createMockEvent as any;

export const Addresses: { mockAddresses: Address_t[]; defaultAddress: Address_t } = TestHelpersJS.Addresses as any;

export const PredictionMarketFactory: { MarketCreated: { processEvent: EventFunctions_eventProcessor<Types_PredictionMarketFactory_MarketCreated_event>; createMockEvent: (args:PredictionMarketFactory_MarketCreated_createMockArgs) => Types_PredictionMarketFactory_MarketCreated_event } } = TestHelpersJS.PredictionMarketFactory as any;

export const PredictionMarket: {
  ChallengeSubmitted: {
    processEvent: EventFunctions_eventProcessor<Types_PredictionMarket_ChallengeSubmitted_event>; 
    createMockEvent: (args:PredictionMarket_ChallengeSubmitted_createMockArgs) => Types_PredictionMarket_ChallengeSubmitted_event
  }; 
  ChallengeResolved: {
    processEvent: EventFunctions_eventProcessor<Types_PredictionMarket_ChallengeResolved_event>; 
    createMockEvent: (args:PredictionMarket_ChallengeResolved_createMockArgs) => Types_PredictionMarket_ChallengeResolved_event
  }; 
  Resolved: {
    processEvent: EventFunctions_eventProcessor<Types_PredictionMarket_Resolved_event>; 
    createMockEvent: (args:PredictionMarket_Resolved_createMockArgs) => Types_PredictionMarket_Resolved_event
  }; 
  Settle: {
    processEvent: EventFunctions_eventProcessor<Types_PredictionMarket_Settle_event>; 
    createMockEvent: (args:PredictionMarket_Settle_createMockArgs) => Types_PredictionMarket_Settle_event
  }; 
  Expired: {
    processEvent: EventFunctions_eventProcessor<Types_PredictionMarket_Expired_event>; 
    createMockEvent: (args:PredictionMarket_Expired_createMockArgs) => Types_PredictionMarket_Expired_event
  }; 
  Mint: {
    processEvent: EventFunctions_eventProcessor<Types_PredictionMarket_Mint_event>; 
    createMockEvent: (args:PredictionMarket_Mint_createMockArgs) => Types_PredictionMarket_Mint_event
  }; 
  Finalized: {
    processEvent: EventFunctions_eventProcessor<Types_PredictionMarket_Finalized_event>; 
    createMockEvent: (args:PredictionMarket_Finalized_createMockArgs) => Types_PredictionMarket_Finalized_event
  }; 
  Burn: {
    processEvent: EventFunctions_eventProcessor<Types_PredictionMarket_Burn_event>; 
    createMockEvent: (args:PredictionMarket_Burn_createMockArgs) => Types_PredictionMarket_Burn_event
  }
} = TestHelpersJS.PredictionMarket as any;

export const MockDb: { createMockDb: () => TestHelpers_MockDb_t } = TestHelpersJS.MockDb as any;
