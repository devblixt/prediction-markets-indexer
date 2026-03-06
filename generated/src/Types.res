//*************
//***ENTITIES**
//*************
@genType.as("Id")
type id = string

@genType
type contractRegistrations = {
  log: Envio.logger,
  // TODO: only add contracts we've registered for the event in the config
  addPredictionMarket: (Address.t) => unit,
  addPredictionMarketFactory: (Address.t) => unit,
}

@genType
type entityHandlerContext<'entity, 'indexedFieldOperations> = {
  get: id => promise<option<'entity>>,
  getOrThrow: (id, ~message: string=?) => promise<'entity>,
  getWhere: 'indexedFieldOperations,
  getOrCreate: ('entity) => promise<'entity>,
  set: 'entity => unit,
  deleteUnsafe: id => unit,
}

@genType.import(("./Types.ts", "HandlerContext"))
type handlerContext = {
  log: Envio.logger,
  effect: 'input 'output. (Envio.effect<'input, 'output>, 'input) => promise<'output>,
  isPreload: bool,
  chain: Internal.chainInfo,
  @as("Market") market: entityHandlerContext<Entities.Market.t, Entities.Market.indexedFieldOperations>,
  @as("MarketActivity") marketActivity: entityHandlerContext<Entities.MarketActivity.t, Entities.MarketActivity.indexedFieldOperations>,
}

//*************
//**CONTRACTS**
//*************

module Transaction = {
  @genType
  type t = {}

  let schema = S.object((_): t => {})
}

module Block = {
  @genType
  type t = {number: int, timestamp: int, hash: string}

  let schema = S.object((s): t => {number: s.field("number", S.int), timestamp: s.field("timestamp", S.int), hash: s.field("hash", S.string)})
}

module AggregatedBlock = {
  @genType
  type t = {hash: string, number: int, timestamp: int}
}
module AggregatedTransaction = {
  @genType
  type t = {}
}

@genType.as("EventLog")
type eventLog<'params> = Internal.genericEvent<'params, Block.t, Transaction.t>

module SingleOrMultiple: {
  @genType.import(("./bindings/OpaqueTypes", "SingleOrMultiple"))
  type t<'a>
  let normalizeOrThrow: (t<'a>, ~nestedArrayDepth: int=?) => array<'a>
  let single: 'a => t<'a>
  let multiple: array<'a> => t<'a>
} = {
  type t<'a> = Js.Json.t

  external single: 'a => t<'a> = "%identity"
  external multiple: array<'a> => t<'a> = "%identity"
  external castMultiple: t<'a> => array<'a> = "%identity"
  external castSingle: t<'a> => 'a = "%identity"

  exception AmbiguousEmptyNestedArray

  let rec isMultiple = (t: t<'a>, ~nestedArrayDepth): bool =>
    switch t->Js.Json.decodeArray {
    | None => false
    | Some(_arr) if nestedArrayDepth == 0 => true
    | Some([]) if nestedArrayDepth > 0 =>
      AmbiguousEmptyNestedArray->ErrorHandling.mkLogAndRaise(
        ~msg="The given empty array could be interperated as a flat array (value) or nested array. Since it's ambiguous,
        please pass in a nested empty array if the intention is to provide an empty array as a value",
      )
    | Some(arr) => arr->Utils.Array.firstUnsafe->isMultiple(~nestedArrayDepth=nestedArrayDepth - 1)
    }

  let normalizeOrThrow = (t: t<'a>, ~nestedArrayDepth=0): array<'a> => {
    if t->isMultiple(~nestedArrayDepth) {
      t->castMultiple
    } else {
      [t->castSingle]
    }
  }
}

module HandlerTypes = {
  @genType
  type args<'eventArgs, 'context> = {
    event: eventLog<'eventArgs>,
    context: 'context,
  }

  @genType
  type contractRegisterArgs<'eventArgs> = Internal.genericContractRegisterArgs<eventLog<'eventArgs>, contractRegistrations>
  @genType
  type contractRegister<'eventArgs> = Internal.genericContractRegister<contractRegisterArgs<'eventArgs>>

  @genType
  type eventConfig<'eventFilters> = Internal.eventOptions<'eventFilters>
}

module type Event = {
  type event

  let handlerRegister: EventRegister.t

  type eventFilters
}

@genType.import(("./bindings/OpaqueTypes.ts", "HandlerWithOptions"))
type fnWithEventConfig<'fn, 'eventConfig> = ('fn, ~eventConfig: 'eventConfig=?) => unit

type handlerWithOptions<'eventArgs, 'eventFilters> = fnWithEventConfig<
  Internal.genericHandler<'eventArgs>,
  HandlerTypes.eventConfig<'eventFilters>,
>

@genType
type contractRegisterWithOptions<'eventArgs, 'eventFilters> = fnWithEventConfig<
  HandlerTypes.contractRegister<'eventArgs>,
  HandlerTypes.eventConfig<'eventFilters>,
>

module MakeRegister = (Event: Event) => {
  let contractRegister: fnWithEventConfig<
    Internal.genericContractRegister<
      Internal.genericContractRegisterArgs<Event.event, contractRegistrations>,
    >,
    HandlerTypes.eventConfig<Event.eventFilters>,
  > = (contractRegister, ~eventConfig=?) =>
    Event.handlerRegister->EventRegister.setContractRegister(
      contractRegister,
      ~eventOptions=eventConfig,
    )

  let handler: fnWithEventConfig<
    Internal.genericHandler<Internal.genericHandlerArgs<Event.event, handlerContext>>,
    HandlerTypes.eventConfig<Event.eventFilters>,
  > = (handler, ~eventConfig=?) => {
    Event.handlerRegister->EventRegister.setHandler(
      handler->(
        Utils.magic: Internal.genericHandler<
          Internal.genericHandlerArgs<Event.event, handlerContext>,
        > => Internal.genericHandler<
          Internal.genericHandlerArgs<Event.event, Internal.handlerContext>,
        >
      ),
      ~eventOptions=eventConfig,
    )
  }
}

module PredictionMarket = {
let abi = (%raw(`[{"type":"event","name":"Burn","inputs":[{"name":"user","type":"address","indexed":true},{"name":"amount","type":"uint256","indexed":false}],"anonymous":false},{"type":"event","name":"ChallengeResolved","inputs":[{"name":"fallbackResolver","type":"address","indexed":true},{"name":"finalOutcome","type":"uint8","indexed":true},{"name":"slashedParty","type":"address","indexed":false},{"name":"slashedAmount","type":"uint256","indexed":false}],"anonymous":false},{"type":"event","name":"ChallengeSubmitted","inputs":[{"name":"challenger","type":"address","indexed":true},{"name":"proposedOutcome","type":"uint8","indexed":true},{"name":"bondAmount","type":"uint256","indexed":false}],"anonymous":false},{"type":"event","name":"Expired","inputs":[{"name":"defaultOutcome","type":"uint8","indexed":true}],"anonymous":false},{"type":"event","name":"Finalized","inputs":[{"name":"outcome","type":"uint8","indexed":true}],"anonymous":false},{"type":"event","name":"Mint","inputs":[{"name":"user","type":"address","indexed":true},{"name":"amount","type":"uint256","indexed":false}],"anonymous":false},{"type":"event","name":"Resolved","inputs":[{"name":"resolver","type":"address","indexed":true},{"name":"outcome","type":"uint8","indexed":true},{"name":"evidenceUri","type":"string","indexed":false}],"anonymous":false},{"type":"event","name":"Settle","inputs":[{"name":"user","type":"address","indexed":true},{"name":"winningOutcome","type":"uint8","indexed":true},{"name":"amount","type":"uint256","indexed":false}],"anonymous":false}]`): EvmTypes.Abi.t)
let eventSignatures = ["Burn(address indexed user, uint256 amount)", "ChallengeResolved(address indexed fallbackResolver, uint8 indexed finalOutcome, address slashedParty, uint256 slashedAmount)", "ChallengeSubmitted(address indexed challenger, uint8 indexed proposedOutcome, uint256 bondAmount)", "Expired(uint8 indexed defaultOutcome)", "Finalized(uint8 indexed outcome)", "Mint(address indexed user, uint256 amount)", "Resolved(address indexed resolver, uint8 indexed outcome, string evidenceUri)", "Settle(address indexed user, uint8 indexed winningOutcome, uint256 amount)"]
@genType type chainId = [#143]
let contractName = "PredictionMarket"

module Mint = {

let id = "0x0f6798a560793a54c3bcfe86a93cde1e73087d944c0ea20544137d4121396885_2"
let sighash = "0x0f6798a560793a54c3bcfe86a93cde1e73087d944c0ea20544137d4121396885"
let name = "Mint"
let contractName = contractName

@genType
type eventArgs = {user: Address.t, amount: bigint}
@genType
type block = Block.t
@genType
type transaction = Transaction.t

@genType
type event = {
/** The parameters or arguments associated with this event. */
params: eventArgs,
/** The unique identifier of the blockchain network where this event occurred. */
chainId: chainId,
/** The address of the contract that emitted this event. */
srcAddress: Address.t,
/** The index of this event's log within the block. */
logIndex: int,
/** The transaction that triggered this event. Configurable in `config.yaml` via the `field_selection` option. */
transaction: transaction,
/** The block in which this event was recorded. Configurable in `config.yaml` via the `field_selection` option. */
block: block,
}

@genType
type handlerArgs = Internal.genericHandlerArgs<event, handlerContext>
@genType
type handler = Internal.genericHandler<handlerArgs>
@genType
type contractRegister = Internal.genericContractRegister<Internal.genericContractRegisterArgs<event, contractRegistrations>>

let paramsRawEventSchema = S.object((s): eventArgs => {user: s.field("user", Address.schema), amount: s.field("amount", BigInt.schema)})
let blockSchema = Block.schema
let transactionSchema = Transaction.schema

let handlerRegister: EventRegister.t = EventRegister.make(
~contractName,
~eventName=name,
)

@genType
type eventFilter = {@as("user") user?: SingleOrMultiple.t<Address.t>}

@genType type eventFiltersArgs = {/** The unique identifier of the blockchain network where this event occurred. */ chainId: chainId, /** Addresses of the contracts indexing the event. */ addresses: array<Address.t>}

@genType @unboxed type eventFiltersDefinition = Single(eventFilter) | Multiple(array<eventFilter>) | @as(false) Skip | @as(true) Keep

@genType @unboxed type eventFilters = | ...eventFiltersDefinition | Dynamic(eventFiltersArgs => eventFiltersDefinition)

let register = (): Internal.evmEventConfig => {
let {getEventFiltersOrThrow, filterByAddresses} = LogSelection.parseEventFiltersOrThrow(~eventFilters=handlerRegister->EventRegister.getEventFilters, ~sighash, ~params=["user",], ~topic1=(_eventFilter) => _eventFilter->Utils.Dict.dangerouslyGetNonOption("user")->Belt.Option.mapWithDefault([], topicFilters => topicFilters->Obj.magic->SingleOrMultiple.normalizeOrThrow->Belt.Array.map(TopicFilter.fromAddress)))
{
  getEventFiltersOrThrow,
  filterByAddresses,
  dependsOnAddresses: !(handlerRegister->EventRegister.isWildcard) || filterByAddresses,
  blockSchema: blockSchema->(Utils.magic: S.t<block> => S.t<Internal.eventBlock>),
  transactionSchema: transactionSchema->(Utils.magic: S.t<transaction> => S.t<Internal.eventTransaction>),
  convertHyperSyncEventArgs: (decodedEvent: HyperSyncClient.Decoder.decodedEvent) => {user: decodedEvent.indexed->Utils.Array.firstUnsafe->HyperSyncClient.Decoder.toUnderlying->Utils.magic, amount: decodedEvent.body->Utils.Array.firstUnsafe->HyperSyncClient.Decoder.toUnderlying->Utils.magic, }->(Utils.magic: eventArgs => Internal.eventParams),
  id,
name,
contractName,
isWildcard: (handlerRegister->EventRegister.isWildcard),
handler: handlerRegister->EventRegister.getHandler,
contractRegister: handlerRegister->EventRegister.getContractRegister,
paramsRawEventSchema: paramsRawEventSchema->(Utils.magic: S.t<eventArgs> => S.t<Internal.eventParams>),
}
}
}

module Burn = {

let id = "0xcc16f5dbb4873280815c1ee09dbd06736cffcc184412cf7a71a0fdb75d397ca5_2"
let sighash = "0xcc16f5dbb4873280815c1ee09dbd06736cffcc184412cf7a71a0fdb75d397ca5"
let name = "Burn"
let contractName = contractName

@genType
type eventArgs = {user: Address.t, amount: bigint}
@genType
type block = Block.t
@genType
type transaction = Transaction.t

@genType
type event = {
/** The parameters or arguments associated with this event. */
params: eventArgs,
/** The unique identifier of the blockchain network where this event occurred. */
chainId: chainId,
/** The address of the contract that emitted this event. */
srcAddress: Address.t,
/** The index of this event's log within the block. */
logIndex: int,
/** The transaction that triggered this event. Configurable in `config.yaml` via the `field_selection` option. */
transaction: transaction,
/** The block in which this event was recorded. Configurable in `config.yaml` via the `field_selection` option. */
block: block,
}

@genType
type handlerArgs = Internal.genericHandlerArgs<event, handlerContext>
@genType
type handler = Internal.genericHandler<handlerArgs>
@genType
type contractRegister = Internal.genericContractRegister<Internal.genericContractRegisterArgs<event, contractRegistrations>>

let paramsRawEventSchema = S.object((s): eventArgs => {user: s.field("user", Address.schema), amount: s.field("amount", BigInt.schema)})
let blockSchema = Block.schema
let transactionSchema = Transaction.schema

let handlerRegister: EventRegister.t = EventRegister.make(
~contractName,
~eventName=name,
)

@genType
type eventFilter = {@as("user") user?: SingleOrMultiple.t<Address.t>}

@genType type eventFiltersArgs = {/** The unique identifier of the blockchain network where this event occurred. */ chainId: chainId, /** Addresses of the contracts indexing the event. */ addresses: array<Address.t>}

@genType @unboxed type eventFiltersDefinition = Single(eventFilter) | Multiple(array<eventFilter>) | @as(false) Skip | @as(true) Keep

@genType @unboxed type eventFilters = | ...eventFiltersDefinition | Dynamic(eventFiltersArgs => eventFiltersDefinition)

let register = (): Internal.evmEventConfig => {
let {getEventFiltersOrThrow, filterByAddresses} = LogSelection.parseEventFiltersOrThrow(~eventFilters=handlerRegister->EventRegister.getEventFilters, ~sighash, ~params=["user",], ~topic1=(_eventFilter) => _eventFilter->Utils.Dict.dangerouslyGetNonOption("user")->Belt.Option.mapWithDefault([], topicFilters => topicFilters->Obj.magic->SingleOrMultiple.normalizeOrThrow->Belt.Array.map(TopicFilter.fromAddress)))
{
  getEventFiltersOrThrow,
  filterByAddresses,
  dependsOnAddresses: !(handlerRegister->EventRegister.isWildcard) || filterByAddresses,
  blockSchema: blockSchema->(Utils.magic: S.t<block> => S.t<Internal.eventBlock>),
  transactionSchema: transactionSchema->(Utils.magic: S.t<transaction> => S.t<Internal.eventTransaction>),
  convertHyperSyncEventArgs: (decodedEvent: HyperSyncClient.Decoder.decodedEvent) => {user: decodedEvent.indexed->Utils.Array.firstUnsafe->HyperSyncClient.Decoder.toUnderlying->Utils.magic, amount: decodedEvent.body->Utils.Array.firstUnsafe->HyperSyncClient.Decoder.toUnderlying->Utils.magic, }->(Utils.magic: eventArgs => Internal.eventParams),
  id,
name,
contractName,
isWildcard: (handlerRegister->EventRegister.isWildcard),
handler: handlerRegister->EventRegister.getHandler,
contractRegister: handlerRegister->EventRegister.getContractRegister,
paramsRawEventSchema: paramsRawEventSchema->(Utils.magic: S.t<eventArgs> => S.t<Internal.eventParams>),
}
}
}

module Settle = {

let id = "0x6d9e2f62051203907692130f604fa8b1dfb29c0ec99a4b3df31d2f7bd62b214a_3"
let sighash = "0x6d9e2f62051203907692130f604fa8b1dfb29c0ec99a4b3df31d2f7bd62b214a"
let name = "Settle"
let contractName = contractName

@genType
type eventArgs = {user: Address.t, winningOutcome: bigint, amount: bigint}
@genType
type block = Block.t
@genType
type transaction = Transaction.t

@genType
type event = {
/** The parameters or arguments associated with this event. */
params: eventArgs,
/** The unique identifier of the blockchain network where this event occurred. */
chainId: chainId,
/** The address of the contract that emitted this event. */
srcAddress: Address.t,
/** The index of this event's log within the block. */
logIndex: int,
/** The transaction that triggered this event. Configurable in `config.yaml` via the `field_selection` option. */
transaction: transaction,
/** The block in which this event was recorded. Configurable in `config.yaml` via the `field_selection` option. */
block: block,
}

@genType
type handlerArgs = Internal.genericHandlerArgs<event, handlerContext>
@genType
type handler = Internal.genericHandler<handlerArgs>
@genType
type contractRegister = Internal.genericContractRegister<Internal.genericContractRegisterArgs<event, contractRegistrations>>

let paramsRawEventSchema = S.object((s): eventArgs => {user: s.field("user", Address.schema), winningOutcome: s.field("winningOutcome", BigInt.schema), amount: s.field("amount", BigInt.schema)})
let blockSchema = Block.schema
let transactionSchema = Transaction.schema

let handlerRegister: EventRegister.t = EventRegister.make(
~contractName,
~eventName=name,
)

@genType
type eventFilter = {@as("user") user?: SingleOrMultiple.t<Address.t>, @as("winningOutcome") winningOutcome?: SingleOrMultiple.t<bigint>}

@genType type eventFiltersArgs = {/** The unique identifier of the blockchain network where this event occurred. */ chainId: chainId, /** Addresses of the contracts indexing the event. */ addresses: array<Address.t>}

@genType @unboxed type eventFiltersDefinition = Single(eventFilter) | Multiple(array<eventFilter>) | @as(false) Skip | @as(true) Keep

@genType @unboxed type eventFilters = | ...eventFiltersDefinition | Dynamic(eventFiltersArgs => eventFiltersDefinition)

let register = (): Internal.evmEventConfig => {
let {getEventFiltersOrThrow, filterByAddresses} = LogSelection.parseEventFiltersOrThrow(~eventFilters=handlerRegister->EventRegister.getEventFilters, ~sighash, ~params=["user","winningOutcome",], ~topic1=(_eventFilter) => _eventFilter->Utils.Dict.dangerouslyGetNonOption("user")->Belt.Option.mapWithDefault([], topicFilters => topicFilters->Obj.magic->SingleOrMultiple.normalizeOrThrow->Belt.Array.map(TopicFilter.fromAddress)), ~topic2=(_eventFilter) => _eventFilter->Utils.Dict.dangerouslyGetNonOption("winningOutcome")->Belt.Option.mapWithDefault([], topicFilters => topicFilters->Obj.magic->SingleOrMultiple.normalizeOrThrow->Belt.Array.map(TopicFilter.fromBigInt)))
{
  getEventFiltersOrThrow,
  filterByAddresses,
  dependsOnAddresses: !(handlerRegister->EventRegister.isWildcard) || filterByAddresses,
  blockSchema: blockSchema->(Utils.magic: S.t<block> => S.t<Internal.eventBlock>),
  transactionSchema: transactionSchema->(Utils.magic: S.t<transaction> => S.t<Internal.eventTransaction>),
  convertHyperSyncEventArgs: (decodedEvent: HyperSyncClient.Decoder.decodedEvent) => {user: decodedEvent.indexed->Utils.Array.firstUnsafe->HyperSyncClient.Decoder.toUnderlying->Utils.magic, winningOutcome: decodedEvent.indexed->Js.Array2.unsafe_get(1)->HyperSyncClient.Decoder.toUnderlying->Utils.magic, amount: decodedEvent.body->Utils.Array.firstUnsafe->HyperSyncClient.Decoder.toUnderlying->Utils.magic, }->(Utils.magic: eventArgs => Internal.eventParams),
  id,
name,
contractName,
isWildcard: (handlerRegister->EventRegister.isWildcard),
handler: handlerRegister->EventRegister.getHandler,
contractRegister: handlerRegister->EventRegister.getContractRegister,
paramsRawEventSchema: paramsRawEventSchema->(Utils.magic: S.t<eventArgs> => S.t<Internal.eventParams>),
}
}
}

module Resolved = {

let id = "0x342665240ad1a2dc2edadb6d467c318ef137b851d98f4890a126aba1c99ebdba_3"
let sighash = "0x342665240ad1a2dc2edadb6d467c318ef137b851d98f4890a126aba1c99ebdba"
let name = "Resolved"
let contractName = contractName

@genType
type eventArgs = {resolver: Address.t, outcome: bigint, evidenceUri: string}
@genType
type block = Block.t
@genType
type transaction = Transaction.t

@genType
type event = {
/** The parameters or arguments associated with this event. */
params: eventArgs,
/** The unique identifier of the blockchain network where this event occurred. */
chainId: chainId,
/** The address of the contract that emitted this event. */
srcAddress: Address.t,
/** The index of this event's log within the block. */
logIndex: int,
/** The transaction that triggered this event. Configurable in `config.yaml` via the `field_selection` option. */
transaction: transaction,
/** The block in which this event was recorded. Configurable in `config.yaml` via the `field_selection` option. */
block: block,
}

@genType
type handlerArgs = Internal.genericHandlerArgs<event, handlerContext>
@genType
type handler = Internal.genericHandler<handlerArgs>
@genType
type contractRegister = Internal.genericContractRegister<Internal.genericContractRegisterArgs<event, contractRegistrations>>

let paramsRawEventSchema = S.object((s): eventArgs => {resolver: s.field("resolver", Address.schema), outcome: s.field("outcome", BigInt.schema), evidenceUri: s.field("evidenceUri", S.string)})
let blockSchema = Block.schema
let transactionSchema = Transaction.schema

let handlerRegister: EventRegister.t = EventRegister.make(
~contractName,
~eventName=name,
)

@genType
type eventFilter = {@as("resolver") resolver?: SingleOrMultiple.t<Address.t>, @as("outcome") outcome?: SingleOrMultiple.t<bigint>}

@genType type eventFiltersArgs = {/** The unique identifier of the blockchain network where this event occurred. */ chainId: chainId, /** Addresses of the contracts indexing the event. */ addresses: array<Address.t>}

@genType @unboxed type eventFiltersDefinition = Single(eventFilter) | Multiple(array<eventFilter>) | @as(false) Skip | @as(true) Keep

@genType @unboxed type eventFilters = | ...eventFiltersDefinition | Dynamic(eventFiltersArgs => eventFiltersDefinition)

let register = (): Internal.evmEventConfig => {
let {getEventFiltersOrThrow, filterByAddresses} = LogSelection.parseEventFiltersOrThrow(~eventFilters=handlerRegister->EventRegister.getEventFilters, ~sighash, ~params=["resolver","outcome",], ~topic1=(_eventFilter) => _eventFilter->Utils.Dict.dangerouslyGetNonOption("resolver")->Belt.Option.mapWithDefault([], topicFilters => topicFilters->Obj.magic->SingleOrMultiple.normalizeOrThrow->Belt.Array.map(TopicFilter.fromAddress)), ~topic2=(_eventFilter) => _eventFilter->Utils.Dict.dangerouslyGetNonOption("outcome")->Belt.Option.mapWithDefault([], topicFilters => topicFilters->Obj.magic->SingleOrMultiple.normalizeOrThrow->Belt.Array.map(TopicFilter.fromBigInt)))
{
  getEventFiltersOrThrow,
  filterByAddresses,
  dependsOnAddresses: !(handlerRegister->EventRegister.isWildcard) || filterByAddresses,
  blockSchema: blockSchema->(Utils.magic: S.t<block> => S.t<Internal.eventBlock>),
  transactionSchema: transactionSchema->(Utils.magic: S.t<transaction> => S.t<Internal.eventTransaction>),
  convertHyperSyncEventArgs: (decodedEvent: HyperSyncClient.Decoder.decodedEvent) => {resolver: decodedEvent.indexed->Utils.Array.firstUnsafe->HyperSyncClient.Decoder.toUnderlying->Utils.magic, outcome: decodedEvent.indexed->Js.Array2.unsafe_get(1)->HyperSyncClient.Decoder.toUnderlying->Utils.magic, evidenceUri: decodedEvent.body->Utils.Array.firstUnsafe->HyperSyncClient.Decoder.toUnderlying->Utils.magic, }->(Utils.magic: eventArgs => Internal.eventParams),
  id,
name,
contractName,
isWildcard: (handlerRegister->EventRegister.isWildcard),
handler: handlerRegister->EventRegister.getHandler,
contractRegister: handlerRegister->EventRegister.getContractRegister,
paramsRawEventSchema: paramsRawEventSchema->(Utils.magic: S.t<eventArgs> => S.t<Internal.eventParams>),
}
}
}

module Finalized = {

let id = "0x59436c8e3d6bc76265d1b5652091955a155c1021c54d77dce73ae3a40ff97f70_2"
let sighash = "0x59436c8e3d6bc76265d1b5652091955a155c1021c54d77dce73ae3a40ff97f70"
let name = "Finalized"
let contractName = contractName

@genType
type eventArgs = {outcome: bigint}
@genType
type block = Block.t
@genType
type transaction = Transaction.t

@genType
type event = {
/** The parameters or arguments associated with this event. */
params: eventArgs,
/** The unique identifier of the blockchain network where this event occurred. */
chainId: chainId,
/** The address of the contract that emitted this event. */
srcAddress: Address.t,
/** The index of this event's log within the block. */
logIndex: int,
/** The transaction that triggered this event. Configurable in `config.yaml` via the `field_selection` option. */
transaction: transaction,
/** The block in which this event was recorded. Configurable in `config.yaml` via the `field_selection` option. */
block: block,
}

@genType
type handlerArgs = Internal.genericHandlerArgs<event, handlerContext>
@genType
type handler = Internal.genericHandler<handlerArgs>
@genType
type contractRegister = Internal.genericContractRegister<Internal.genericContractRegisterArgs<event, contractRegistrations>>

let paramsRawEventSchema = S.object((s): eventArgs => {outcome: s.field("outcome", BigInt.schema)})
let blockSchema = Block.schema
let transactionSchema = Transaction.schema

let handlerRegister: EventRegister.t = EventRegister.make(
~contractName,
~eventName=name,
)

@genType
type eventFilter = {@as("outcome") outcome?: SingleOrMultiple.t<bigint>}

@genType type eventFiltersArgs = {/** The unique identifier of the blockchain network where this event occurred. */ chainId: chainId, /** Addresses of the contracts indexing the event. */ addresses: array<Address.t>}

@genType @unboxed type eventFiltersDefinition = Single(eventFilter) | Multiple(array<eventFilter>) | @as(false) Skip | @as(true) Keep

@genType @unboxed type eventFilters = | ...eventFiltersDefinition | Dynamic(eventFiltersArgs => eventFiltersDefinition)

let register = (): Internal.evmEventConfig => {
let {getEventFiltersOrThrow, filterByAddresses} = LogSelection.parseEventFiltersOrThrow(~eventFilters=handlerRegister->EventRegister.getEventFilters, ~sighash, ~params=["outcome",], ~topic1=(_eventFilter) => _eventFilter->Utils.Dict.dangerouslyGetNonOption("outcome")->Belt.Option.mapWithDefault([], topicFilters => topicFilters->Obj.magic->SingleOrMultiple.normalizeOrThrow->Belt.Array.map(TopicFilter.fromBigInt)))
{
  getEventFiltersOrThrow,
  filterByAddresses,
  dependsOnAddresses: !(handlerRegister->EventRegister.isWildcard) || filterByAddresses,
  blockSchema: blockSchema->(Utils.magic: S.t<block> => S.t<Internal.eventBlock>),
  transactionSchema: transactionSchema->(Utils.magic: S.t<transaction> => S.t<Internal.eventTransaction>),
  convertHyperSyncEventArgs: (decodedEvent: HyperSyncClient.Decoder.decodedEvent) => {outcome: decodedEvent.indexed->Utils.Array.firstUnsafe->HyperSyncClient.Decoder.toUnderlying->Utils.magic, }->(Utils.magic: eventArgs => Internal.eventParams),
  id,
name,
contractName,
isWildcard: (handlerRegister->EventRegister.isWildcard),
handler: handlerRegister->EventRegister.getHandler,
contractRegister: handlerRegister->EventRegister.getContractRegister,
paramsRawEventSchema: paramsRawEventSchema->(Utils.magic: S.t<eventArgs> => S.t<Internal.eventParams>),
}
}
}

module Expired = {

let id = "0x40b0e801790a2ee366ae5cca8068f948ed3b472fb3fe694a80cd23e2a87fc0f5_2"
let sighash = "0x40b0e801790a2ee366ae5cca8068f948ed3b472fb3fe694a80cd23e2a87fc0f5"
let name = "Expired"
let contractName = contractName

@genType
type eventArgs = {defaultOutcome: bigint}
@genType
type block = Block.t
@genType
type transaction = Transaction.t

@genType
type event = {
/** The parameters or arguments associated with this event. */
params: eventArgs,
/** The unique identifier of the blockchain network where this event occurred. */
chainId: chainId,
/** The address of the contract that emitted this event. */
srcAddress: Address.t,
/** The index of this event's log within the block. */
logIndex: int,
/** The transaction that triggered this event. Configurable in `config.yaml` via the `field_selection` option. */
transaction: transaction,
/** The block in which this event was recorded. Configurable in `config.yaml` via the `field_selection` option. */
block: block,
}

@genType
type handlerArgs = Internal.genericHandlerArgs<event, handlerContext>
@genType
type handler = Internal.genericHandler<handlerArgs>
@genType
type contractRegister = Internal.genericContractRegister<Internal.genericContractRegisterArgs<event, contractRegistrations>>

let paramsRawEventSchema = S.object((s): eventArgs => {defaultOutcome: s.field("defaultOutcome", BigInt.schema)})
let blockSchema = Block.schema
let transactionSchema = Transaction.schema

let handlerRegister: EventRegister.t = EventRegister.make(
~contractName,
~eventName=name,
)

@genType
type eventFilter = {@as("defaultOutcome") defaultOutcome?: SingleOrMultiple.t<bigint>}

@genType type eventFiltersArgs = {/** The unique identifier of the blockchain network where this event occurred. */ chainId: chainId, /** Addresses of the contracts indexing the event. */ addresses: array<Address.t>}

@genType @unboxed type eventFiltersDefinition = Single(eventFilter) | Multiple(array<eventFilter>) | @as(false) Skip | @as(true) Keep

@genType @unboxed type eventFilters = | ...eventFiltersDefinition | Dynamic(eventFiltersArgs => eventFiltersDefinition)

let register = (): Internal.evmEventConfig => {
let {getEventFiltersOrThrow, filterByAddresses} = LogSelection.parseEventFiltersOrThrow(~eventFilters=handlerRegister->EventRegister.getEventFilters, ~sighash, ~params=["defaultOutcome",], ~topic1=(_eventFilter) => _eventFilter->Utils.Dict.dangerouslyGetNonOption("defaultOutcome")->Belt.Option.mapWithDefault([], topicFilters => topicFilters->Obj.magic->SingleOrMultiple.normalizeOrThrow->Belt.Array.map(TopicFilter.fromBigInt)))
{
  getEventFiltersOrThrow,
  filterByAddresses,
  dependsOnAddresses: !(handlerRegister->EventRegister.isWildcard) || filterByAddresses,
  blockSchema: blockSchema->(Utils.magic: S.t<block> => S.t<Internal.eventBlock>),
  transactionSchema: transactionSchema->(Utils.magic: S.t<transaction> => S.t<Internal.eventTransaction>),
  convertHyperSyncEventArgs: (decodedEvent: HyperSyncClient.Decoder.decodedEvent) => {defaultOutcome: decodedEvent.indexed->Utils.Array.firstUnsafe->HyperSyncClient.Decoder.toUnderlying->Utils.magic, }->(Utils.magic: eventArgs => Internal.eventParams),
  id,
name,
contractName,
isWildcard: (handlerRegister->EventRegister.isWildcard),
handler: handlerRegister->EventRegister.getHandler,
contractRegister: handlerRegister->EventRegister.getContractRegister,
paramsRawEventSchema: paramsRawEventSchema->(Utils.magic: S.t<eventArgs> => S.t<Internal.eventParams>),
}
}
}

module ChallengeSubmitted = {

let id = "0x98f9e23f32446b8c4d4b2dc1a8f9cb15e3117d3433e7d3fbcb6fefb89d552e35_3"
let sighash = "0x98f9e23f32446b8c4d4b2dc1a8f9cb15e3117d3433e7d3fbcb6fefb89d552e35"
let name = "ChallengeSubmitted"
let contractName = contractName

@genType
type eventArgs = {challenger: Address.t, proposedOutcome: bigint, bondAmount: bigint}
@genType
type block = Block.t
@genType
type transaction = Transaction.t

@genType
type event = {
/** The parameters or arguments associated with this event. */
params: eventArgs,
/** The unique identifier of the blockchain network where this event occurred. */
chainId: chainId,
/** The address of the contract that emitted this event. */
srcAddress: Address.t,
/** The index of this event's log within the block. */
logIndex: int,
/** The transaction that triggered this event. Configurable in `config.yaml` via the `field_selection` option. */
transaction: transaction,
/** The block in which this event was recorded. Configurable in `config.yaml` via the `field_selection` option. */
block: block,
}

@genType
type handlerArgs = Internal.genericHandlerArgs<event, handlerContext>
@genType
type handler = Internal.genericHandler<handlerArgs>
@genType
type contractRegister = Internal.genericContractRegister<Internal.genericContractRegisterArgs<event, contractRegistrations>>

let paramsRawEventSchema = S.object((s): eventArgs => {challenger: s.field("challenger", Address.schema), proposedOutcome: s.field("proposedOutcome", BigInt.schema), bondAmount: s.field("bondAmount", BigInt.schema)})
let blockSchema = Block.schema
let transactionSchema = Transaction.schema

let handlerRegister: EventRegister.t = EventRegister.make(
~contractName,
~eventName=name,
)

@genType
type eventFilter = {@as("challenger") challenger?: SingleOrMultiple.t<Address.t>, @as("proposedOutcome") proposedOutcome?: SingleOrMultiple.t<bigint>}

@genType type eventFiltersArgs = {/** The unique identifier of the blockchain network where this event occurred. */ chainId: chainId, /** Addresses of the contracts indexing the event. */ addresses: array<Address.t>}

@genType @unboxed type eventFiltersDefinition = Single(eventFilter) | Multiple(array<eventFilter>) | @as(false) Skip | @as(true) Keep

@genType @unboxed type eventFilters = | ...eventFiltersDefinition | Dynamic(eventFiltersArgs => eventFiltersDefinition)

let register = (): Internal.evmEventConfig => {
let {getEventFiltersOrThrow, filterByAddresses} = LogSelection.parseEventFiltersOrThrow(~eventFilters=handlerRegister->EventRegister.getEventFilters, ~sighash, ~params=["challenger","proposedOutcome",], ~topic1=(_eventFilter) => _eventFilter->Utils.Dict.dangerouslyGetNonOption("challenger")->Belt.Option.mapWithDefault([], topicFilters => topicFilters->Obj.magic->SingleOrMultiple.normalizeOrThrow->Belt.Array.map(TopicFilter.fromAddress)), ~topic2=(_eventFilter) => _eventFilter->Utils.Dict.dangerouslyGetNonOption("proposedOutcome")->Belt.Option.mapWithDefault([], topicFilters => topicFilters->Obj.magic->SingleOrMultiple.normalizeOrThrow->Belt.Array.map(TopicFilter.fromBigInt)))
{
  getEventFiltersOrThrow,
  filterByAddresses,
  dependsOnAddresses: !(handlerRegister->EventRegister.isWildcard) || filterByAddresses,
  blockSchema: blockSchema->(Utils.magic: S.t<block> => S.t<Internal.eventBlock>),
  transactionSchema: transactionSchema->(Utils.magic: S.t<transaction> => S.t<Internal.eventTransaction>),
  convertHyperSyncEventArgs: (decodedEvent: HyperSyncClient.Decoder.decodedEvent) => {challenger: decodedEvent.indexed->Utils.Array.firstUnsafe->HyperSyncClient.Decoder.toUnderlying->Utils.magic, proposedOutcome: decodedEvent.indexed->Js.Array2.unsafe_get(1)->HyperSyncClient.Decoder.toUnderlying->Utils.magic, bondAmount: decodedEvent.body->Utils.Array.firstUnsafe->HyperSyncClient.Decoder.toUnderlying->Utils.magic, }->(Utils.magic: eventArgs => Internal.eventParams),
  id,
name,
contractName,
isWildcard: (handlerRegister->EventRegister.isWildcard),
handler: handlerRegister->EventRegister.getHandler,
contractRegister: handlerRegister->EventRegister.getContractRegister,
paramsRawEventSchema: paramsRawEventSchema->(Utils.magic: S.t<eventArgs> => S.t<Internal.eventParams>),
}
}
}

module ChallengeResolved = {

let id = "0x534e4556499708456c8fc25075e8c57f01a311b8175c0dfefe2a4b09acf4fce4_3"
let sighash = "0x534e4556499708456c8fc25075e8c57f01a311b8175c0dfefe2a4b09acf4fce4"
let name = "ChallengeResolved"
let contractName = contractName

@genType
type eventArgs = {fallbackResolver: Address.t, finalOutcome: bigint, slashedParty: Address.t, slashedAmount: bigint}
@genType
type block = Block.t
@genType
type transaction = Transaction.t

@genType
type event = {
/** The parameters or arguments associated with this event. */
params: eventArgs,
/** The unique identifier of the blockchain network where this event occurred. */
chainId: chainId,
/** The address of the contract that emitted this event. */
srcAddress: Address.t,
/** The index of this event's log within the block. */
logIndex: int,
/** The transaction that triggered this event. Configurable in `config.yaml` via the `field_selection` option. */
transaction: transaction,
/** The block in which this event was recorded. Configurable in `config.yaml` via the `field_selection` option. */
block: block,
}

@genType
type handlerArgs = Internal.genericHandlerArgs<event, handlerContext>
@genType
type handler = Internal.genericHandler<handlerArgs>
@genType
type contractRegister = Internal.genericContractRegister<Internal.genericContractRegisterArgs<event, contractRegistrations>>

let paramsRawEventSchema = S.object((s): eventArgs => {fallbackResolver: s.field("fallbackResolver", Address.schema), finalOutcome: s.field("finalOutcome", BigInt.schema), slashedParty: s.field("slashedParty", Address.schema), slashedAmount: s.field("slashedAmount", BigInt.schema)})
let blockSchema = Block.schema
let transactionSchema = Transaction.schema

let handlerRegister: EventRegister.t = EventRegister.make(
~contractName,
~eventName=name,
)

@genType
type eventFilter = {@as("fallbackResolver") fallbackResolver?: SingleOrMultiple.t<Address.t>, @as("finalOutcome") finalOutcome?: SingleOrMultiple.t<bigint>}

@genType type eventFiltersArgs = {/** The unique identifier of the blockchain network where this event occurred. */ chainId: chainId, /** Addresses of the contracts indexing the event. */ addresses: array<Address.t>}

@genType @unboxed type eventFiltersDefinition = Single(eventFilter) | Multiple(array<eventFilter>) | @as(false) Skip | @as(true) Keep

@genType @unboxed type eventFilters = | ...eventFiltersDefinition | Dynamic(eventFiltersArgs => eventFiltersDefinition)

let register = (): Internal.evmEventConfig => {
let {getEventFiltersOrThrow, filterByAddresses} = LogSelection.parseEventFiltersOrThrow(~eventFilters=handlerRegister->EventRegister.getEventFilters, ~sighash, ~params=["fallbackResolver","finalOutcome",], ~topic1=(_eventFilter) => _eventFilter->Utils.Dict.dangerouslyGetNonOption("fallbackResolver")->Belt.Option.mapWithDefault([], topicFilters => topicFilters->Obj.magic->SingleOrMultiple.normalizeOrThrow->Belt.Array.map(TopicFilter.fromAddress)), ~topic2=(_eventFilter) => _eventFilter->Utils.Dict.dangerouslyGetNonOption("finalOutcome")->Belt.Option.mapWithDefault([], topicFilters => topicFilters->Obj.magic->SingleOrMultiple.normalizeOrThrow->Belt.Array.map(TopicFilter.fromBigInt)))
{
  getEventFiltersOrThrow,
  filterByAddresses,
  dependsOnAddresses: !(handlerRegister->EventRegister.isWildcard) || filterByAddresses,
  blockSchema: blockSchema->(Utils.magic: S.t<block> => S.t<Internal.eventBlock>),
  transactionSchema: transactionSchema->(Utils.magic: S.t<transaction> => S.t<Internal.eventTransaction>),
  convertHyperSyncEventArgs: (decodedEvent: HyperSyncClient.Decoder.decodedEvent) => {fallbackResolver: decodedEvent.indexed->Utils.Array.firstUnsafe->HyperSyncClient.Decoder.toUnderlying->Utils.magic, finalOutcome: decodedEvent.indexed->Js.Array2.unsafe_get(1)->HyperSyncClient.Decoder.toUnderlying->Utils.magic, slashedParty: decodedEvent.body->Utils.Array.firstUnsafe->HyperSyncClient.Decoder.toUnderlying->Utils.magic, slashedAmount: decodedEvent.body->Js.Array2.unsafe_get(1)->HyperSyncClient.Decoder.toUnderlying->Utils.magic, }->(Utils.magic: eventArgs => Internal.eventParams),
  id,
name,
contractName,
isWildcard: (handlerRegister->EventRegister.isWildcard),
handler: handlerRegister->EventRegister.getHandler,
contractRegister: handlerRegister->EventRegister.getContractRegister,
paramsRawEventSchema: paramsRawEventSchema->(Utils.magic: S.t<eventArgs> => S.t<Internal.eventParams>),
}
}
}
}

module PredictionMarketFactory = {
let abi = (%raw(`[{"type":"event","name":"MarketCreated","inputs":[{"name":"market","type":"address","indexed":true},{"name":"creator","type":"address","indexed":true},{"name":"resolver","type":"address","indexed":true},{"name":"collateralToken","type":"address","indexed":false},{"name":"numOutcomes","type":"uint8","indexed":false},{"name":"outcomeTokens","type":"address[]","indexed":false},{"name":"orderbooks","type":"address[]","indexed":false},{"name":"resolutionBlock","type":"uint256","indexed":false},{"name":"allowChallenge","type":"bool","indexed":false},{"name":"insuranceBond","type":"uint256","indexed":false},{"name":"metadata","type":"bytes","indexed":false}],"anonymous":false}]`): EvmTypes.Abi.t)
let eventSignatures = ["MarketCreated(address indexed market, address indexed creator, address indexed resolver, address collateralToken, uint8 numOutcomes, address[] outcomeTokens, address[] orderbooks, uint256 resolutionBlock, bool allowChallenge, uint256 insuranceBond, bytes metadata)"]
@genType type chainId = [#143]
let contractName = "PredictionMarketFactory"

module MarketCreated = {

let id = "0x57594a5312055dba9d2bebb7646888eb90bde25dd7133df4f720d2db142c0051_4"
let sighash = "0x57594a5312055dba9d2bebb7646888eb90bde25dd7133df4f720d2db142c0051"
let name = "MarketCreated"
let contractName = contractName

@genType
type eventArgs = {market: Address.t, creator: Address.t, resolver: Address.t, collateralToken: Address.t, numOutcomes: bigint, outcomeTokens: array<Address.t>, orderbooks: array<Address.t>, resolutionBlock: bigint, allowChallenge: bool, insuranceBond: bigint, metadata: string}
@genType
type block = Block.t
@genType
type transaction = Transaction.t

@genType
type event = {
/** The parameters or arguments associated with this event. */
params: eventArgs,
/** The unique identifier of the blockchain network where this event occurred. */
chainId: chainId,
/** The address of the contract that emitted this event. */
srcAddress: Address.t,
/** The index of this event's log within the block. */
logIndex: int,
/** The transaction that triggered this event. Configurable in `config.yaml` via the `field_selection` option. */
transaction: transaction,
/** The block in which this event was recorded. Configurable in `config.yaml` via the `field_selection` option. */
block: block,
}

@genType
type handlerArgs = Internal.genericHandlerArgs<event, handlerContext>
@genType
type handler = Internal.genericHandler<handlerArgs>
@genType
type contractRegister = Internal.genericContractRegister<Internal.genericContractRegisterArgs<event, contractRegistrations>>

let paramsRawEventSchema = S.object((s): eventArgs => {market: s.field("market", Address.schema), creator: s.field("creator", Address.schema), resolver: s.field("resolver", Address.schema), collateralToken: s.field("collateralToken", Address.schema), numOutcomes: s.field("numOutcomes", BigInt.schema), outcomeTokens: s.field("outcomeTokens", S.array(Address.schema)), orderbooks: s.field("orderbooks", S.array(Address.schema)), resolutionBlock: s.field("resolutionBlock", BigInt.schema), allowChallenge: s.field("allowChallenge", S.bool), insuranceBond: s.field("insuranceBond", BigInt.schema), metadata: s.field("metadata", S.string)})
let blockSchema = Block.schema
let transactionSchema = Transaction.schema

let handlerRegister: EventRegister.t = EventRegister.make(
~contractName,
~eventName=name,
)

@genType
type eventFilter = {@as("market") market?: SingleOrMultiple.t<Address.t>, @as("creator") creator?: SingleOrMultiple.t<Address.t>, @as("resolver") resolver?: SingleOrMultiple.t<Address.t>}

@genType type eventFiltersArgs = {/** The unique identifier of the blockchain network where this event occurred. */ chainId: chainId, /** Addresses of the contracts indexing the event. */ addresses: array<Address.t>}

@genType @unboxed type eventFiltersDefinition = Single(eventFilter) | Multiple(array<eventFilter>) | @as(false) Skip | @as(true) Keep

@genType @unboxed type eventFilters = | ...eventFiltersDefinition | Dynamic(eventFiltersArgs => eventFiltersDefinition)

let register = (): Internal.evmEventConfig => {
let {getEventFiltersOrThrow, filterByAddresses} = LogSelection.parseEventFiltersOrThrow(~eventFilters=handlerRegister->EventRegister.getEventFilters, ~sighash, ~params=["market","creator","resolver",], ~topic1=(_eventFilter) => _eventFilter->Utils.Dict.dangerouslyGetNonOption("market")->Belt.Option.mapWithDefault([], topicFilters => topicFilters->Obj.magic->SingleOrMultiple.normalizeOrThrow->Belt.Array.map(TopicFilter.fromAddress)), ~topic2=(_eventFilter) => _eventFilter->Utils.Dict.dangerouslyGetNonOption("creator")->Belt.Option.mapWithDefault([], topicFilters => topicFilters->Obj.magic->SingleOrMultiple.normalizeOrThrow->Belt.Array.map(TopicFilter.fromAddress)), ~topic3=(_eventFilter) => _eventFilter->Utils.Dict.dangerouslyGetNonOption("resolver")->Belt.Option.mapWithDefault([], topicFilters => topicFilters->Obj.magic->SingleOrMultiple.normalizeOrThrow->Belt.Array.map(TopicFilter.fromAddress)))
{
  getEventFiltersOrThrow,
  filterByAddresses,
  dependsOnAddresses: !(handlerRegister->EventRegister.isWildcard) || filterByAddresses,
  blockSchema: blockSchema->(Utils.magic: S.t<block> => S.t<Internal.eventBlock>),
  transactionSchema: transactionSchema->(Utils.magic: S.t<transaction> => S.t<Internal.eventTransaction>),
  convertHyperSyncEventArgs: (decodedEvent: HyperSyncClient.Decoder.decodedEvent) => {market: decodedEvent.indexed->Utils.Array.firstUnsafe->HyperSyncClient.Decoder.toUnderlying->Utils.magic, creator: decodedEvent.indexed->Js.Array2.unsafe_get(1)->HyperSyncClient.Decoder.toUnderlying->Utils.magic, resolver: decodedEvent.indexed->Js.Array2.unsafe_get(2)->HyperSyncClient.Decoder.toUnderlying->Utils.magic, collateralToken: decodedEvent.body->Utils.Array.firstUnsafe->HyperSyncClient.Decoder.toUnderlying->Utils.magic, numOutcomes: decodedEvent.body->Js.Array2.unsafe_get(1)->HyperSyncClient.Decoder.toUnderlying->Utils.magic, outcomeTokens: decodedEvent.body->Js.Array2.unsafe_get(2)->HyperSyncClient.Decoder.toUnderlying->Utils.magic, orderbooks: decodedEvent.body->Js.Array2.unsafe_get(3)->HyperSyncClient.Decoder.toUnderlying->Utils.magic, resolutionBlock: decodedEvent.body->Js.Array2.unsafe_get(4)->HyperSyncClient.Decoder.toUnderlying->Utils.magic, allowChallenge: decodedEvent.body->Js.Array2.unsafe_get(5)->HyperSyncClient.Decoder.toUnderlying->Utils.magic, insuranceBond: decodedEvent.body->Js.Array2.unsafe_get(6)->HyperSyncClient.Decoder.toUnderlying->Utils.magic, metadata: decodedEvent.body->Js.Array2.unsafe_get(7)->HyperSyncClient.Decoder.toUnderlying->Utils.magic, }->(Utils.magic: eventArgs => Internal.eventParams),
  id,
name,
contractName,
isWildcard: (handlerRegister->EventRegister.isWildcard),
handler: handlerRegister->EventRegister.getHandler,
contractRegister: handlerRegister->EventRegister.getContractRegister,
paramsRawEventSchema: paramsRawEventSchema->(Utils.magic: S.t<eventArgs> => S.t<Internal.eventParams>),
}
}
}
}

