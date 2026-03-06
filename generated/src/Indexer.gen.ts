/* TypeScript file generated from Indexer.res by genType. */

/* eslint-disable */
/* tslint:disable */

import * as IndexerJS from './Indexer.res.mjs';

import type {EvmChainId as $$chainId} from './Types.ts';

import type {HandlerTypes_eventConfig as Types_HandlerTypes_eventConfig} from './Types.gen.js';

import type {PredictionMarketFactory_MarketCreated_eventFilters as Types_PredictionMarketFactory_MarketCreated_eventFilters} from './Types.gen.js';

import type {PredictionMarketFactory_MarketCreated_event as Types_PredictionMarketFactory_MarketCreated_event} from './Types.gen.js';

import type {PredictionMarket_Burn_eventFilters as Types_PredictionMarket_Burn_eventFilters} from './Types.gen.js';

import type {PredictionMarket_Burn_event as Types_PredictionMarket_Burn_event} from './Types.gen.js';

import type {PredictionMarket_ChallengeResolved_eventFilters as Types_PredictionMarket_ChallengeResolved_eventFilters} from './Types.gen.js';

import type {PredictionMarket_ChallengeResolved_event as Types_PredictionMarket_ChallengeResolved_event} from './Types.gen.js';

import type {PredictionMarket_ChallengeSubmitted_eventFilters as Types_PredictionMarket_ChallengeSubmitted_eventFilters} from './Types.gen.js';

import type {PredictionMarket_ChallengeSubmitted_event as Types_PredictionMarket_ChallengeSubmitted_event} from './Types.gen.js';

import type {PredictionMarket_Expired_eventFilters as Types_PredictionMarket_Expired_eventFilters} from './Types.gen.js';

import type {PredictionMarket_Expired_event as Types_PredictionMarket_Expired_event} from './Types.gen.js';

import type {PredictionMarket_Finalized_eventFilters as Types_PredictionMarket_Finalized_eventFilters} from './Types.gen.js';

import type {PredictionMarket_Finalized_event as Types_PredictionMarket_Finalized_event} from './Types.gen.js';

import type {PredictionMarket_Mint_eventFilters as Types_PredictionMarket_Mint_eventFilters} from './Types.gen.js';

import type {PredictionMarket_Mint_event as Types_PredictionMarket_Mint_event} from './Types.gen.js';

import type {PredictionMarket_Resolved_eventFilters as Types_PredictionMarket_Resolved_eventFilters} from './Types.gen.js';

import type {PredictionMarket_Resolved_event as Types_PredictionMarket_Resolved_event} from './Types.gen.js';

import type {PredictionMarket_Settle_eventFilters as Types_PredictionMarket_Settle_eventFilters} from './Types.gen.js';

import type {PredictionMarket_Settle_event as Types_PredictionMarket_Settle_event} from './Types.gen.js';

import type {blockEvent as Envio_blockEvent} from 'envio/src/Envio.gen.js';

import type {contractRegistrations as Types_contractRegistrations} from './Types.gen.js';

import type {fnWithEventConfig as Types_fnWithEventConfig} from './Types.gen.js';

import type {genericContractRegisterArgs as Internal_genericContractRegisterArgs} from 'envio/src/Internal.gen.js';

import type {genericContractRegister as Internal_genericContractRegister} from 'envio/src/Internal.gen.js';

import type {genericHandlerArgs as Internal_genericHandlerArgs} from 'envio/src/Internal.gen.js';

import type {genericHandler as Internal_genericHandler} from 'envio/src/Internal.gen.js';

import type {handlerContext as Types_handlerContext} from './Types.gen.js';

import type {onBlockArgs as Envio_onBlockArgs} from 'envio/src/Envio.gen.js';

import type {onBlockOptions as Envio_onBlockOptions} from 'envio/src/Envio.gen.js';

export type chainId = $$chainId;

export const PredictionMarket_Mint_contractRegister: Types_fnWithEventConfig<Internal_genericContractRegister<Internal_genericContractRegisterArgs<Types_PredictionMarket_Mint_event,Types_contractRegistrations>>,Types_HandlerTypes_eventConfig<Types_PredictionMarket_Mint_eventFilters>> = IndexerJS.PredictionMarket.Mint.contractRegister as any;

export const PredictionMarket_Mint_handler: Types_fnWithEventConfig<Internal_genericHandler<Internal_genericHandlerArgs<Types_PredictionMarket_Mint_event,Types_handlerContext>>,Types_HandlerTypes_eventConfig<Types_PredictionMarket_Mint_eventFilters>> = IndexerJS.PredictionMarket.Mint.handler as any;

export const PredictionMarket_Burn_contractRegister: Types_fnWithEventConfig<Internal_genericContractRegister<Internal_genericContractRegisterArgs<Types_PredictionMarket_Burn_event,Types_contractRegistrations>>,Types_HandlerTypes_eventConfig<Types_PredictionMarket_Burn_eventFilters>> = IndexerJS.PredictionMarket.Burn.contractRegister as any;

export const PredictionMarket_Burn_handler: Types_fnWithEventConfig<Internal_genericHandler<Internal_genericHandlerArgs<Types_PredictionMarket_Burn_event,Types_handlerContext>>,Types_HandlerTypes_eventConfig<Types_PredictionMarket_Burn_eventFilters>> = IndexerJS.PredictionMarket.Burn.handler as any;

export const PredictionMarket_Settle_contractRegister: Types_fnWithEventConfig<Internal_genericContractRegister<Internal_genericContractRegisterArgs<Types_PredictionMarket_Settle_event,Types_contractRegistrations>>,Types_HandlerTypes_eventConfig<Types_PredictionMarket_Settle_eventFilters>> = IndexerJS.PredictionMarket.Settle.contractRegister as any;

export const PredictionMarket_Settle_handler: Types_fnWithEventConfig<Internal_genericHandler<Internal_genericHandlerArgs<Types_PredictionMarket_Settle_event,Types_handlerContext>>,Types_HandlerTypes_eventConfig<Types_PredictionMarket_Settle_eventFilters>> = IndexerJS.PredictionMarket.Settle.handler as any;

export const PredictionMarket_Resolved_contractRegister: Types_fnWithEventConfig<Internal_genericContractRegister<Internal_genericContractRegisterArgs<Types_PredictionMarket_Resolved_event,Types_contractRegistrations>>,Types_HandlerTypes_eventConfig<Types_PredictionMarket_Resolved_eventFilters>> = IndexerJS.PredictionMarket.Resolved.contractRegister as any;

export const PredictionMarket_Resolved_handler: Types_fnWithEventConfig<Internal_genericHandler<Internal_genericHandlerArgs<Types_PredictionMarket_Resolved_event,Types_handlerContext>>,Types_HandlerTypes_eventConfig<Types_PredictionMarket_Resolved_eventFilters>> = IndexerJS.PredictionMarket.Resolved.handler as any;

export const PredictionMarket_Finalized_contractRegister: Types_fnWithEventConfig<Internal_genericContractRegister<Internal_genericContractRegisterArgs<Types_PredictionMarket_Finalized_event,Types_contractRegistrations>>,Types_HandlerTypes_eventConfig<Types_PredictionMarket_Finalized_eventFilters>> = IndexerJS.PredictionMarket.Finalized.contractRegister as any;

export const PredictionMarket_Finalized_handler: Types_fnWithEventConfig<Internal_genericHandler<Internal_genericHandlerArgs<Types_PredictionMarket_Finalized_event,Types_handlerContext>>,Types_HandlerTypes_eventConfig<Types_PredictionMarket_Finalized_eventFilters>> = IndexerJS.PredictionMarket.Finalized.handler as any;

export const PredictionMarket_Expired_contractRegister: Types_fnWithEventConfig<Internal_genericContractRegister<Internal_genericContractRegisterArgs<Types_PredictionMarket_Expired_event,Types_contractRegistrations>>,Types_HandlerTypes_eventConfig<Types_PredictionMarket_Expired_eventFilters>> = IndexerJS.PredictionMarket.Expired.contractRegister as any;

export const PredictionMarket_Expired_handler: Types_fnWithEventConfig<Internal_genericHandler<Internal_genericHandlerArgs<Types_PredictionMarket_Expired_event,Types_handlerContext>>,Types_HandlerTypes_eventConfig<Types_PredictionMarket_Expired_eventFilters>> = IndexerJS.PredictionMarket.Expired.handler as any;

export const PredictionMarket_ChallengeSubmitted_contractRegister: Types_fnWithEventConfig<Internal_genericContractRegister<Internal_genericContractRegisterArgs<Types_PredictionMarket_ChallengeSubmitted_event,Types_contractRegistrations>>,Types_HandlerTypes_eventConfig<Types_PredictionMarket_ChallengeSubmitted_eventFilters>> = IndexerJS.PredictionMarket.ChallengeSubmitted.contractRegister as any;

export const PredictionMarket_ChallengeSubmitted_handler: Types_fnWithEventConfig<Internal_genericHandler<Internal_genericHandlerArgs<Types_PredictionMarket_ChallengeSubmitted_event,Types_handlerContext>>,Types_HandlerTypes_eventConfig<Types_PredictionMarket_ChallengeSubmitted_eventFilters>> = IndexerJS.PredictionMarket.ChallengeSubmitted.handler as any;

export const PredictionMarket_ChallengeResolved_contractRegister: Types_fnWithEventConfig<Internal_genericContractRegister<Internal_genericContractRegisterArgs<Types_PredictionMarket_ChallengeResolved_event,Types_contractRegistrations>>,Types_HandlerTypes_eventConfig<Types_PredictionMarket_ChallengeResolved_eventFilters>> = IndexerJS.PredictionMarket.ChallengeResolved.contractRegister as any;

export const PredictionMarket_ChallengeResolved_handler: Types_fnWithEventConfig<Internal_genericHandler<Internal_genericHandlerArgs<Types_PredictionMarket_ChallengeResolved_event,Types_handlerContext>>,Types_HandlerTypes_eventConfig<Types_PredictionMarket_ChallengeResolved_eventFilters>> = IndexerJS.PredictionMarket.ChallengeResolved.handler as any;

export const PredictionMarketFactory_MarketCreated_contractRegister: Types_fnWithEventConfig<Internal_genericContractRegister<Internal_genericContractRegisterArgs<Types_PredictionMarketFactory_MarketCreated_event,Types_contractRegistrations>>,Types_HandlerTypes_eventConfig<Types_PredictionMarketFactory_MarketCreated_eventFilters>> = IndexerJS.PredictionMarketFactory.MarketCreated.contractRegister as any;

export const PredictionMarketFactory_MarketCreated_handler: Types_fnWithEventConfig<Internal_genericHandler<Internal_genericHandlerArgs<Types_PredictionMarketFactory_MarketCreated_event,Types_handlerContext>>,Types_HandlerTypes_eventConfig<Types_PredictionMarketFactory_MarketCreated_eventFilters>> = IndexerJS.PredictionMarketFactory.MarketCreated.handler as any;

/** Register a Block Handler. It'll be called for every block by default. */
export const onBlock: (_1:Envio_onBlockOptions<chainId>, _2:((_1:Envio_onBlockArgs<Envio_blockEvent,Types_handlerContext>) => Promise<void>)) => void = IndexerJS.onBlock as any;

export const PredictionMarketFactory: { MarketCreated: { handler: Types_fnWithEventConfig<Internal_genericHandler<Internal_genericHandlerArgs<Types_PredictionMarketFactory_MarketCreated_event,Types_handlerContext>>,Types_HandlerTypes_eventConfig<Types_PredictionMarketFactory_MarketCreated_eventFilters>>; contractRegister: Types_fnWithEventConfig<Internal_genericContractRegister<Internal_genericContractRegisterArgs<Types_PredictionMarketFactory_MarketCreated_event,Types_contractRegistrations>>,Types_HandlerTypes_eventConfig<Types_PredictionMarketFactory_MarketCreated_eventFilters>> } } = IndexerJS.PredictionMarketFactory as any;

export const PredictionMarket: {
  ChallengeSubmitted: {
    handler: Types_fnWithEventConfig<Internal_genericHandler<Internal_genericHandlerArgs<Types_PredictionMarket_ChallengeSubmitted_event,Types_handlerContext>>,Types_HandlerTypes_eventConfig<Types_PredictionMarket_ChallengeSubmitted_eventFilters>>; 
    contractRegister: Types_fnWithEventConfig<Internal_genericContractRegister<Internal_genericContractRegisterArgs<Types_PredictionMarket_ChallengeSubmitted_event,Types_contractRegistrations>>,Types_HandlerTypes_eventConfig<Types_PredictionMarket_ChallengeSubmitted_eventFilters>>
  }; 
  ChallengeResolved: {
    handler: Types_fnWithEventConfig<Internal_genericHandler<Internal_genericHandlerArgs<Types_PredictionMarket_ChallengeResolved_event,Types_handlerContext>>,Types_HandlerTypes_eventConfig<Types_PredictionMarket_ChallengeResolved_eventFilters>>; 
    contractRegister: Types_fnWithEventConfig<Internal_genericContractRegister<Internal_genericContractRegisterArgs<Types_PredictionMarket_ChallengeResolved_event,Types_contractRegistrations>>,Types_HandlerTypes_eventConfig<Types_PredictionMarket_ChallengeResolved_eventFilters>>
  }; 
  Resolved: {
    handler: Types_fnWithEventConfig<Internal_genericHandler<Internal_genericHandlerArgs<Types_PredictionMarket_Resolved_event,Types_handlerContext>>,Types_HandlerTypes_eventConfig<Types_PredictionMarket_Resolved_eventFilters>>; 
    contractRegister: Types_fnWithEventConfig<Internal_genericContractRegister<Internal_genericContractRegisterArgs<Types_PredictionMarket_Resolved_event,Types_contractRegistrations>>,Types_HandlerTypes_eventConfig<Types_PredictionMarket_Resolved_eventFilters>>
  }; 
  Settle: {
    handler: Types_fnWithEventConfig<Internal_genericHandler<Internal_genericHandlerArgs<Types_PredictionMarket_Settle_event,Types_handlerContext>>,Types_HandlerTypes_eventConfig<Types_PredictionMarket_Settle_eventFilters>>; 
    contractRegister: Types_fnWithEventConfig<Internal_genericContractRegister<Internal_genericContractRegisterArgs<Types_PredictionMarket_Settle_event,Types_contractRegistrations>>,Types_HandlerTypes_eventConfig<Types_PredictionMarket_Settle_eventFilters>>
  }; 
  Expired: {
    handler: Types_fnWithEventConfig<Internal_genericHandler<Internal_genericHandlerArgs<Types_PredictionMarket_Expired_event,Types_handlerContext>>,Types_HandlerTypes_eventConfig<Types_PredictionMarket_Expired_eventFilters>>; 
    contractRegister: Types_fnWithEventConfig<Internal_genericContractRegister<Internal_genericContractRegisterArgs<Types_PredictionMarket_Expired_event,Types_contractRegistrations>>,Types_HandlerTypes_eventConfig<Types_PredictionMarket_Expired_eventFilters>>
  }; 
  Mint: {
    handler: Types_fnWithEventConfig<Internal_genericHandler<Internal_genericHandlerArgs<Types_PredictionMarket_Mint_event,Types_handlerContext>>,Types_HandlerTypes_eventConfig<Types_PredictionMarket_Mint_eventFilters>>; 
    contractRegister: Types_fnWithEventConfig<Internal_genericContractRegister<Internal_genericContractRegisterArgs<Types_PredictionMarket_Mint_event,Types_contractRegistrations>>,Types_HandlerTypes_eventConfig<Types_PredictionMarket_Mint_eventFilters>>
  }; 
  Finalized: {
    handler: Types_fnWithEventConfig<Internal_genericHandler<Internal_genericHandlerArgs<Types_PredictionMarket_Finalized_event,Types_handlerContext>>,Types_HandlerTypes_eventConfig<Types_PredictionMarket_Finalized_eventFilters>>; 
    contractRegister: Types_fnWithEventConfig<Internal_genericContractRegister<Internal_genericContractRegisterArgs<Types_PredictionMarket_Finalized_event,Types_contractRegistrations>>,Types_HandlerTypes_eventConfig<Types_PredictionMarket_Finalized_eventFilters>>
  }; 
  Burn: {
    handler: Types_fnWithEventConfig<Internal_genericHandler<Internal_genericHandlerArgs<Types_PredictionMarket_Burn_event,Types_handlerContext>>,Types_HandlerTypes_eventConfig<Types_PredictionMarket_Burn_eventFilters>>; 
    contractRegister: Types_fnWithEventConfig<Internal_genericContractRegister<Internal_genericContractRegisterArgs<Types_PredictionMarket_Burn_event,Types_contractRegistrations>>,Types_HandlerTypes_eventConfig<Types_PredictionMarket_Burn_eventFilters>>
  }
} = IndexerJS.PredictionMarket as any;
