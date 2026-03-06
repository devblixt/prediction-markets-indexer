/***** TAKE NOTE ******
This is a hack to get genType to work!

In order for genType to produce recursive types, it needs to be at the 
root module of a file. If it's defined in a nested module it does not 
work. So all the MockDb types and internal functions are defined in TestHelpers_MockDb
and only public functions are recreated and exported from this module.

the following module:
```rescript
module MyModule = {
  @genType
  type rec a = {fieldB: b}
  @genType and b = {fieldA: a}
}
```

produces the following in ts:
```ts
// tslint:disable-next-line:interface-over-type-literal
export type MyModule_a = { readonly fieldB: b };

// tslint:disable-next-line:interface-over-type-literal
export type MyModule_b = { readonly fieldA: MyModule_a };
```

fieldB references type b which doesn't exist because it's defined
as MyModule_b
*/

module MockDb = {
  @genType
  let createMockDb = TestHelpers_MockDb.createMockDb
}

@genType
module Addresses = {
  include TestHelpers_MockAddresses
}

module EventFunctions = {
  //Note these are made into a record to make operate in the same way
  //for Res, JS and TS.

  /**
  The arguements that get passed to a "processEvent" helper function
  */
  @genType
  type eventProcessorArgs<'event> = {
    event: 'event,
    mockDb: TestHelpers_MockDb.t,
    @deprecated("Set the chainId for the event instead")
    chainId?: int,
  }

  @genType
  type eventProcessor<'event> = eventProcessorArgs<'event> => promise<TestHelpers_MockDb.t>

  /**
  A function composer to help create individual processEvent functions
  */
  let makeEventProcessor = (~register) => args => {
    let {event, mockDb, ?chainId} =
      args->(Utils.magic: eventProcessorArgs<'event> => eventProcessorArgs<Internal.event>)

    // Have the line here, just in case the function is called with
    // a manually created event. We don't want to break the existing tests here.
    let _ =
      TestHelpers_MockDb.mockEventRegisters->Utils.WeakMap.set(event, register)
    TestHelpers_MockDb.makeProcessEvents(mockDb, ~chainId=?chainId)([event->(Utils.magic: Internal.event => Types.eventLog<unknown>)])
  }

  module MockBlock = {
    @genType
    type t = {
      @as("hash") hash?: string,
      @as("number") number?: int,
      @as("timestamp") timestamp?: int,
    }

    let toBlock = (_mock: t) => {
      hash: _mock.hash->Belt.Option.getWithDefault("foo"),
      number: _mock.number->Belt.Option.getWithDefault(0),
      timestamp: _mock.timestamp->Belt.Option.getWithDefault(0),
    }->(Utils.magic: Types.AggregatedBlock.t => Internal.eventBlock)
  }

  module MockTransaction = {
    @genType
    type t = {
    }

    let toTransaction = (_mock: t) => {
    }->(Utils.magic: Types.AggregatedTransaction.t => Internal.eventTransaction)
  }

  @genType
  type mockEventData = {
    chainId?: int,
    srcAddress?: Address.t,
    logIndex?: int,
    block?: MockBlock.t,
    transaction?: MockTransaction.t,
  }

  /**
  Applies optional paramters with defaults for all common eventLog field
  */
  let makeEventMocker = (
    ~params: Internal.eventParams,
    ~mockEventData: option<mockEventData>,
    ~register: unit => Internal.eventConfig,
  ): Internal.event => {
    let {?block, ?transaction, ?srcAddress, ?chainId, ?logIndex} =
      mockEventData->Belt.Option.getWithDefault({})
    let block = block->Belt.Option.getWithDefault({})->MockBlock.toBlock
    let transaction = transaction->Belt.Option.getWithDefault({})->MockTransaction.toTransaction
    let event: Internal.event = {
      params,
      transaction,
      chainId: switch chainId {
      | Some(chainId) => chainId
      | None =>
        switch Generated.configWithoutRegistrations.defaultChain {
        | Some(chainConfig) => chainConfig.id
        | None =>
          Js.Exn.raiseError(
            "No default chain Id found, please add at least 1 chain to your config.yaml",
          )
        }
      },
      block,
      srcAddress: srcAddress->Belt.Option.getWithDefault(Addresses.defaultAddress),
      logIndex: logIndex->Belt.Option.getWithDefault(0),
    }
    // Since currently it's not possible to figure out the event config from the event
    // we store a reference to the register function by event in a weak map
    let _ = TestHelpers_MockDb.mockEventRegisters->Utils.WeakMap.set(event, register)
    event
  }
}


module PredictionMarket = {
  module Mint = {
    @genType
    let processEvent: EventFunctions.eventProcessor<Types.PredictionMarket.Mint.event> = EventFunctions.makeEventProcessor(
      ~register=(Types.PredictionMarket.Mint.register :> unit => Internal.eventConfig),
    )

    @genType
    type createMockArgs = {
      @as("user")
      user?: Address.t,
      @as("amount")
      amount?: bigint,
      mockEventData?: EventFunctions.mockEventData,
    }

    @genType
    let createMockEvent = args => {
      let {
        ?user,
        ?amount,
        ?mockEventData,
      } = args

      let params = 
      {
       user: user->Belt.Option.getWithDefault(TestHelpers_MockAddresses.defaultAddress),
       amount: amount->Belt.Option.getWithDefault(0n),
      }
->(Utils.magic: Types.PredictionMarket.Mint.eventArgs => Internal.eventParams)

      EventFunctions.makeEventMocker(
        ~params,
        ~mockEventData,
        ~register=(Types.PredictionMarket.Mint.register :> unit => Internal.eventConfig),
      )->(Utils.magic: Internal.event => Types.PredictionMarket.Mint.event)
    }
  }

  module Burn = {
    @genType
    let processEvent: EventFunctions.eventProcessor<Types.PredictionMarket.Burn.event> = EventFunctions.makeEventProcessor(
      ~register=(Types.PredictionMarket.Burn.register :> unit => Internal.eventConfig),
    )

    @genType
    type createMockArgs = {
      @as("user")
      user?: Address.t,
      @as("amount")
      amount?: bigint,
      mockEventData?: EventFunctions.mockEventData,
    }

    @genType
    let createMockEvent = args => {
      let {
        ?user,
        ?amount,
        ?mockEventData,
      } = args

      let params = 
      {
       user: user->Belt.Option.getWithDefault(TestHelpers_MockAddresses.defaultAddress),
       amount: amount->Belt.Option.getWithDefault(0n),
      }
->(Utils.magic: Types.PredictionMarket.Burn.eventArgs => Internal.eventParams)

      EventFunctions.makeEventMocker(
        ~params,
        ~mockEventData,
        ~register=(Types.PredictionMarket.Burn.register :> unit => Internal.eventConfig),
      )->(Utils.magic: Internal.event => Types.PredictionMarket.Burn.event)
    }
  }

  module Settle = {
    @genType
    let processEvent: EventFunctions.eventProcessor<Types.PredictionMarket.Settle.event> = EventFunctions.makeEventProcessor(
      ~register=(Types.PredictionMarket.Settle.register :> unit => Internal.eventConfig),
    )

    @genType
    type createMockArgs = {
      @as("user")
      user?: Address.t,
      @as("winningOutcome")
      winningOutcome?: bigint,
      @as("amount")
      amount?: bigint,
      mockEventData?: EventFunctions.mockEventData,
    }

    @genType
    let createMockEvent = args => {
      let {
        ?user,
        ?winningOutcome,
        ?amount,
        ?mockEventData,
      } = args

      let params = 
      {
       user: user->Belt.Option.getWithDefault(TestHelpers_MockAddresses.defaultAddress),
       winningOutcome: winningOutcome->Belt.Option.getWithDefault(0n),
       amount: amount->Belt.Option.getWithDefault(0n),
      }
->(Utils.magic: Types.PredictionMarket.Settle.eventArgs => Internal.eventParams)

      EventFunctions.makeEventMocker(
        ~params,
        ~mockEventData,
        ~register=(Types.PredictionMarket.Settle.register :> unit => Internal.eventConfig),
      )->(Utils.magic: Internal.event => Types.PredictionMarket.Settle.event)
    }
  }

  module Resolved = {
    @genType
    let processEvent: EventFunctions.eventProcessor<Types.PredictionMarket.Resolved.event> = EventFunctions.makeEventProcessor(
      ~register=(Types.PredictionMarket.Resolved.register :> unit => Internal.eventConfig),
    )

    @genType
    type createMockArgs = {
      @as("resolver")
      resolver?: Address.t,
      @as("outcome")
      outcome?: bigint,
      @as("evidenceUri")
      evidenceUri?: string,
      mockEventData?: EventFunctions.mockEventData,
    }

    @genType
    let createMockEvent = args => {
      let {
        ?resolver,
        ?outcome,
        ?evidenceUri,
        ?mockEventData,
      } = args

      let params = 
      {
       resolver: resolver->Belt.Option.getWithDefault(TestHelpers_MockAddresses.defaultAddress),
       outcome: outcome->Belt.Option.getWithDefault(0n),
       evidenceUri: evidenceUri->Belt.Option.getWithDefault("foo"),
      }
->(Utils.magic: Types.PredictionMarket.Resolved.eventArgs => Internal.eventParams)

      EventFunctions.makeEventMocker(
        ~params,
        ~mockEventData,
        ~register=(Types.PredictionMarket.Resolved.register :> unit => Internal.eventConfig),
      )->(Utils.magic: Internal.event => Types.PredictionMarket.Resolved.event)
    }
  }

  module Finalized = {
    @genType
    let processEvent: EventFunctions.eventProcessor<Types.PredictionMarket.Finalized.event> = EventFunctions.makeEventProcessor(
      ~register=(Types.PredictionMarket.Finalized.register :> unit => Internal.eventConfig),
    )

    @genType
    type createMockArgs = {
      @as("outcome")
      outcome?: bigint,
      mockEventData?: EventFunctions.mockEventData,
    }

    @genType
    let createMockEvent = args => {
      let {
        ?outcome,
        ?mockEventData,
      } = args

      let params = 
      {
       outcome: outcome->Belt.Option.getWithDefault(0n),
      }
->(Utils.magic: Types.PredictionMarket.Finalized.eventArgs => Internal.eventParams)

      EventFunctions.makeEventMocker(
        ~params,
        ~mockEventData,
        ~register=(Types.PredictionMarket.Finalized.register :> unit => Internal.eventConfig),
      )->(Utils.magic: Internal.event => Types.PredictionMarket.Finalized.event)
    }
  }

  module Expired = {
    @genType
    let processEvent: EventFunctions.eventProcessor<Types.PredictionMarket.Expired.event> = EventFunctions.makeEventProcessor(
      ~register=(Types.PredictionMarket.Expired.register :> unit => Internal.eventConfig),
    )

    @genType
    type createMockArgs = {
      @as("defaultOutcome")
      defaultOutcome?: bigint,
      mockEventData?: EventFunctions.mockEventData,
    }

    @genType
    let createMockEvent = args => {
      let {
        ?defaultOutcome,
        ?mockEventData,
      } = args

      let params = 
      {
       defaultOutcome: defaultOutcome->Belt.Option.getWithDefault(0n),
      }
->(Utils.magic: Types.PredictionMarket.Expired.eventArgs => Internal.eventParams)

      EventFunctions.makeEventMocker(
        ~params,
        ~mockEventData,
        ~register=(Types.PredictionMarket.Expired.register :> unit => Internal.eventConfig),
      )->(Utils.magic: Internal.event => Types.PredictionMarket.Expired.event)
    }
  }

  module ChallengeSubmitted = {
    @genType
    let processEvent: EventFunctions.eventProcessor<Types.PredictionMarket.ChallengeSubmitted.event> = EventFunctions.makeEventProcessor(
      ~register=(Types.PredictionMarket.ChallengeSubmitted.register :> unit => Internal.eventConfig),
    )

    @genType
    type createMockArgs = {
      @as("challenger")
      challenger?: Address.t,
      @as("proposedOutcome")
      proposedOutcome?: bigint,
      @as("bondAmount")
      bondAmount?: bigint,
      mockEventData?: EventFunctions.mockEventData,
    }

    @genType
    let createMockEvent = args => {
      let {
        ?challenger,
        ?proposedOutcome,
        ?bondAmount,
        ?mockEventData,
      } = args

      let params = 
      {
       challenger: challenger->Belt.Option.getWithDefault(TestHelpers_MockAddresses.defaultAddress),
       proposedOutcome: proposedOutcome->Belt.Option.getWithDefault(0n),
       bondAmount: bondAmount->Belt.Option.getWithDefault(0n),
      }
->(Utils.magic: Types.PredictionMarket.ChallengeSubmitted.eventArgs => Internal.eventParams)

      EventFunctions.makeEventMocker(
        ~params,
        ~mockEventData,
        ~register=(Types.PredictionMarket.ChallengeSubmitted.register :> unit => Internal.eventConfig),
      )->(Utils.magic: Internal.event => Types.PredictionMarket.ChallengeSubmitted.event)
    }
  }

  module ChallengeResolved = {
    @genType
    let processEvent: EventFunctions.eventProcessor<Types.PredictionMarket.ChallengeResolved.event> = EventFunctions.makeEventProcessor(
      ~register=(Types.PredictionMarket.ChallengeResolved.register :> unit => Internal.eventConfig),
    )

    @genType
    type createMockArgs = {
      @as("fallbackResolver")
      fallbackResolver?: Address.t,
      @as("finalOutcome")
      finalOutcome?: bigint,
      @as("slashedParty")
      slashedParty?: Address.t,
      @as("slashedAmount")
      slashedAmount?: bigint,
      mockEventData?: EventFunctions.mockEventData,
    }

    @genType
    let createMockEvent = args => {
      let {
        ?fallbackResolver,
        ?finalOutcome,
        ?slashedParty,
        ?slashedAmount,
        ?mockEventData,
      } = args

      let params = 
      {
       fallbackResolver: fallbackResolver->Belt.Option.getWithDefault(TestHelpers_MockAddresses.defaultAddress),
       finalOutcome: finalOutcome->Belt.Option.getWithDefault(0n),
       slashedParty: slashedParty->Belt.Option.getWithDefault(TestHelpers_MockAddresses.defaultAddress),
       slashedAmount: slashedAmount->Belt.Option.getWithDefault(0n),
      }
->(Utils.magic: Types.PredictionMarket.ChallengeResolved.eventArgs => Internal.eventParams)

      EventFunctions.makeEventMocker(
        ~params,
        ~mockEventData,
        ~register=(Types.PredictionMarket.ChallengeResolved.register :> unit => Internal.eventConfig),
      )->(Utils.magic: Internal.event => Types.PredictionMarket.ChallengeResolved.event)
    }
  }

}


module PredictionMarketFactory = {
  module MarketCreated = {
    @genType
    let processEvent: EventFunctions.eventProcessor<Types.PredictionMarketFactory.MarketCreated.event> = EventFunctions.makeEventProcessor(
      ~register=(Types.PredictionMarketFactory.MarketCreated.register :> unit => Internal.eventConfig),
    )

    @genType
    type createMockArgs = {
      @as("market")
      market?: Address.t,
      @as("creator")
      creator?: Address.t,
      @as("resolver")
      resolver?: Address.t,
      @as("collateralToken")
      collateralToken?: Address.t,
      @as("numOutcomes")
      numOutcomes?: bigint,
      @as("outcomeTokens")
      outcomeTokens?: array<Address.t>,
      @as("orderbooks")
      orderbooks?: array<Address.t>,
      @as("resolutionBlock")
      resolutionBlock?: bigint,
      @as("allowChallenge")
      allowChallenge?: bool,
      @as("insuranceBond")
      insuranceBond?: bigint,
      @as("metadata")
      metadata?: string,
      mockEventData?: EventFunctions.mockEventData,
    }

    @genType
    let createMockEvent = args => {
      let {
        ?market,
        ?creator,
        ?resolver,
        ?collateralToken,
        ?numOutcomes,
        ?outcomeTokens,
        ?orderbooks,
        ?resolutionBlock,
        ?allowChallenge,
        ?insuranceBond,
        ?metadata,
        ?mockEventData,
      } = args

      let params = 
      {
       market: market->Belt.Option.getWithDefault(TestHelpers_MockAddresses.defaultAddress),
       creator: creator->Belt.Option.getWithDefault(TestHelpers_MockAddresses.defaultAddress),
       resolver: resolver->Belt.Option.getWithDefault(TestHelpers_MockAddresses.defaultAddress),
       collateralToken: collateralToken->Belt.Option.getWithDefault(TestHelpers_MockAddresses.defaultAddress),
       numOutcomes: numOutcomes->Belt.Option.getWithDefault(0n),
       outcomeTokens: outcomeTokens->Belt.Option.getWithDefault([]),
       orderbooks: orderbooks->Belt.Option.getWithDefault([]),
       resolutionBlock: resolutionBlock->Belt.Option.getWithDefault(0n),
       allowChallenge: allowChallenge->Belt.Option.getWithDefault(false),
       insuranceBond: insuranceBond->Belt.Option.getWithDefault(0n),
       metadata: metadata->Belt.Option.getWithDefault("foo"),
      }
->(Utils.magic: Types.PredictionMarketFactory.MarketCreated.eventArgs => Internal.eventParams)

      EventFunctions.makeEventMocker(
        ~params,
        ~mockEventData,
        ~register=(Types.PredictionMarketFactory.MarketCreated.register :> unit => Internal.eventConfig),
      )->(Utils.magic: Internal.event => Types.PredictionMarketFactory.MarketCreated.event)
    }
  }

}

