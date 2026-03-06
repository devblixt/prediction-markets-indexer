@genType
module PredictionMarket = {
  module Mint = Types.MakeRegister(Types.PredictionMarket.Mint)
  module Burn = Types.MakeRegister(Types.PredictionMarket.Burn)
  module Settle = Types.MakeRegister(Types.PredictionMarket.Settle)
  module Resolved = Types.MakeRegister(Types.PredictionMarket.Resolved)
  module Finalized = Types.MakeRegister(Types.PredictionMarket.Finalized)
  module Expired = Types.MakeRegister(Types.PredictionMarket.Expired)
  module ChallengeSubmitted = Types.MakeRegister(Types.PredictionMarket.ChallengeSubmitted)
  module ChallengeResolved = Types.MakeRegister(Types.PredictionMarket.ChallengeResolved)
}

@genType
module PredictionMarketFactory = {
  module MarketCreated = Types.MakeRegister(Types.PredictionMarketFactory.MarketCreated)
}

@genType.import(("./Types.ts", "EvmChainId"))
type chainId = [#143]

/** Contract configuration with name and ABI. */
type indexerContract = {
  /** The contract name. */
  name: string,
  /** The contract ABI. */
  abi: unknown,
  /** The contract addresses. */
  addresses: array<Address.t>,
}

/** Per-chain configuration for the indexer. */
type indexerChain = {
  /** The chain ID. */
  id: chainId,
  /** The chain name. */
  name: string,
  /** The block number to start indexing from. */
  startBlock: int,
  /** The block number to stop indexing at (if specified). */
  endBlock: option<int>,
  /** Whether the chain has completed initial sync and is processing live events. */
  isLive: bool,
  \"PredictionMarket": indexerContract,
  \"PredictionMarketFactory": indexerContract,
}

/** Strongly-typed record of chain configurations keyed by chain ID. */
type indexerChains = {
  @as("143") chain143: indexerChain,
  monad: indexerChain,
}

/** Metadata and configuration for the indexer. */
type indexer = {
  /** The name of the indexer from config.yaml. */
  name: string,
  /** The description of the indexer from config.yaml. */
  description: option<string>,
  /** Array of all chain IDs this indexer operates on. */
  chainIds: array<chainId>,
  /** Per-chain configuration keyed by chain ID. */
  chains: indexerChains,
}

let indexer: indexer = Main.getGlobalIndexer(~config=Generated.configWithoutRegistrations)

/** Get chain configuration by chain ID with exhaustive pattern matching. */
let getChainById = (indexer: indexer, chainId: chainId): indexerChain => {
switch chainId {
  | #143 => indexer.chains.chain143
}
}

@genType /** Register a Block Handler. It'll be called for every block by default. */
let onBlock: (
Envio.onBlockOptions<chainId>,
Envio.onBlockArgs<Envio.blockEvent, Types.handlerContext> => promise<unit>,
) => unit = (
EventRegister.onBlock: (unknown, Internal.onBlockArgs => promise<unit>) => unit
)->Utils.magic

type testIndexerProcessConfigChains = {
  @as("143") chain143?: TestIndexer.chainConfig,
}

type testIndexerProcessConfig = {
  chains: testIndexerProcessConfigChains,
}

let createTestIndexer: unit => TestIndexer.t<testIndexerProcessConfig> = TestIndexer.makeCreateTestIndexer(~config=Generated.configWithoutRegistrations, ~workerPath=NodeJs.Path.join(NodeJs.Path.dirname(NodeJs.Url.fileURLToPath(NodeJs.ImportMeta.importMeta.url)), "TestIndexerWorker.res.mjs")->NodeJs.Path.toString, ~allEntities=Generated.codegenPersistence.allEntities)