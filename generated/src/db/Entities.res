open Table
type id = string

type internalEntity = Internal.entity
module type Entity = {
  type t
  let index: int
  let name: string
  let schema: S.t<t>
  let rowsSchema: S.t<array<t>>
  let table: Table.table
}
external entityModToInternal: module(Entity with type t = 'a) => Internal.entityConfig = "%identity"
external entityModsToInternal: array<module(Entity)> => array<Internal.entityConfig> = "%identity"
external entitiesToInternal: array<'a> => array<Internal.entity> = "%identity"

@get
external getEntityId: internalEntity => string = "id"

// Use InMemoryTable.Entity.getEntityIdUnsafe instead of duplicating the logic
let getEntityIdUnsafe = InMemoryTable.Entity.getEntityIdUnsafe

//shorthand for punning
let isPrimaryKey = true
let isNullable = true
let isArray = true
let isIndex = true


module Market = {
  let name = "Market"
  let index = 0
  @genType
  type t = {id: id, factory: string, creator: string, resolver: string, collateralToken: string, numOutcomes: int, outcomeTokens: string, orderbooks: string, resolutionBlock: bigint, allowChallenge: bool, insuranceBond: bigint, metadata: string, status: string, resolvedOutcome: option<int>, resolvedBlock: option<bigint>, totalCollateral: bigint, challenger: option<string>, challengerBond: option<bigint>, challengerProposedOutcome: option<int>, challengeStatus: string, createdAt: bigint, createdAtBlock: bigint}

  let schema = S.object((s): t => {id: s.field("id", S.string), factory: s.field("factory", S.string), creator: s.field("creator", S.string), resolver: s.field("resolver", S.string), collateralToken: s.field("collateralToken", S.string), numOutcomes: s.field("numOutcomes", S.int), outcomeTokens: s.field("outcomeTokens", S.string), orderbooks: s.field("orderbooks", S.string), resolutionBlock: s.field("resolutionBlock", BigInt.schema), allowChallenge: s.field("allowChallenge", S.bool), insuranceBond: s.field("insuranceBond", BigInt.schema), metadata: s.field("metadata", S.string), status: s.field("status", S.string), resolvedOutcome: s.field("resolvedOutcome", S.null(S.int)), resolvedBlock: s.field("resolvedBlock", S.null(BigInt.schema)), totalCollateral: s.field("totalCollateral", BigInt.schema), challenger: s.field("challenger", S.null(S.string)), challengerBond: s.field("challengerBond", S.null(BigInt.schema)), challengerProposedOutcome: s.field("challengerProposedOutcome", S.null(S.int)), challengeStatus: s.field("challengeStatus", S.string), createdAt: s.field("createdAt", BigInt.schema), createdAtBlock: s.field("createdAtBlock", BigInt.schema)})

  let rowsSchema = S.array(schema)

  @genType
  type indexedFieldOperations = {
    
  }

  let table = mkTable(
    name,
    ~fields=[
      mkField(
      "id", 
      String,
      ~fieldSchema=S.string,
      ~isPrimaryKey,
      
      
      
      
      ),
      mkField(
      "factory", 
      String,
      ~fieldSchema=S.string,
      
      
      
      
      
      ),
      mkField(
      "creator", 
      String,
      ~fieldSchema=S.string,
      
      
      
      
      
      ),
      mkField(
      "resolver", 
      String,
      ~fieldSchema=S.string,
      
      
      
      
      
      ),
      mkField(
      "collateralToken", 
      String,
      ~fieldSchema=S.string,
      
      
      
      
      
      ),
      mkField(
      "numOutcomes", 
      Int32,
      ~fieldSchema=S.int,
      
      
      
      
      
      ),
      mkField(
      "outcomeTokens", 
      String,
      ~fieldSchema=S.string,
      
      
      
      
      
      ),
      mkField(
      "orderbooks", 
      String,
      ~fieldSchema=S.string,
      
      
      
      
      
      ),
      mkField(
      "resolutionBlock", 
      BigInt({}),
      ~fieldSchema=BigInt.schema,
      
      
      
      
      
      ),
      mkField(
      "allowChallenge", 
      Boolean,
      ~fieldSchema=S.bool,
      
      
      
      
      
      ),
      mkField(
      "insuranceBond", 
      BigInt({}),
      ~fieldSchema=BigInt.schema,
      
      
      
      
      
      ),
      mkField(
      "metadata", 
      String,
      ~fieldSchema=S.string,
      
      
      
      
      
      ),
      mkField(
      "status", 
      String,
      ~fieldSchema=S.string,
      
      
      
      
      
      ),
      mkField(
      "resolvedOutcome", 
      Int32,
      ~fieldSchema=S.null(S.int),
      
      ~isNullable,
      
      
      
      ),
      mkField(
      "resolvedBlock", 
      BigInt({}),
      ~fieldSchema=S.null(BigInt.schema),
      
      ~isNullable,
      
      
      
      ),
      mkField(
      "totalCollateral", 
      BigInt({}),
      ~fieldSchema=BigInt.schema,
      
      
      
      
      
      ),
      mkField(
      "challenger", 
      String,
      ~fieldSchema=S.null(S.string),
      
      ~isNullable,
      
      
      
      ),
      mkField(
      "challengerBond", 
      BigInt({}),
      ~fieldSchema=S.null(BigInt.schema),
      
      ~isNullable,
      
      
      
      ),
      mkField(
      "challengerProposedOutcome", 
      Int32,
      ~fieldSchema=S.null(S.int),
      
      ~isNullable,
      
      
      
      ),
      mkField(
      "challengeStatus", 
      String,
      ~fieldSchema=S.string,
      
      
      
      
      
      ),
      mkField(
      "createdAt", 
      BigInt({}),
      ~fieldSchema=BigInt.schema,
      
      
      
      
      
      ),
      mkField(
      "createdAtBlock", 
      BigInt({}),
      ~fieldSchema=BigInt.schema,
      
      
      
      
      
      ),
    ],
  )

  external castToInternal: t => Internal.entity = "%identity"
}

module MarketActivity = {
  let name = "MarketActivity"
  let index = 1
  @genType
  type t = {id: id, market_id: id, @as("type") type_: string, user: string, amount: bigint, outcome: option<int>, timestamp: bigint, blockNumber: bigint}

  let schema = S.object((s): t => {id: s.field("id", S.string), market_id: s.field("market_id", S.string), type_: s.field("type", S.string), user: s.field("user", S.string), amount: s.field("amount", BigInt.schema), outcome: s.field("outcome", S.null(S.int)), timestamp: s.field("timestamp", BigInt.schema), blockNumber: s.field("blockNumber", BigInt.schema)})

  let rowsSchema = S.array(schema)

  @genType
  type indexedFieldOperations = {
    
  }

  let table = mkTable(
    name,
    ~fields=[
      mkField(
      "id", 
      String,
      ~fieldSchema=S.string,
      ~isPrimaryKey,
      
      
      
      
      ),
      mkField(
      "market", 
      Entity({name: "Market"}),
      ~fieldSchema=S.string,
      
      
      
      
      ~linkedEntity="Market",
      ),
      mkField(
      "type", 
      String,
      ~fieldSchema=S.string,
      
      
      
      
      
      ),
      mkField(
      "user", 
      String,
      ~fieldSchema=S.string,
      
      
      
      
      
      ),
      mkField(
      "amount", 
      BigInt({}),
      ~fieldSchema=BigInt.schema,
      
      
      
      
      
      ),
      mkField(
      "outcome", 
      Int32,
      ~fieldSchema=S.null(S.int),
      
      ~isNullable,
      
      
      
      ),
      mkField(
      "timestamp", 
      BigInt({}),
      ~fieldSchema=BigInt.schema,
      
      
      
      
      
      ),
      mkField(
      "blockNumber", 
      BigInt({}),
      ~fieldSchema=BigInt.schema,
      
      
      
      
      
      ),
    ],
  )

  external castToInternal: t => Internal.entity = "%identity"
}

let userEntities = [
  module(Market),
  module(MarketActivity),
]->entityModsToInternal

let allEntities =
  userEntities->Js.Array2.concat(
    [module(InternalTable.DynamicContractRegistry)]->entityModsToInternal,
  )
