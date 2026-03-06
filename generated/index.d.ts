export {
  PredictionMarket,
  PredictionMarketFactory,
  onBlock
} from "./src/Indexer.gen";
export type * from "./src/Types.gen";
export type * from "./src/Types.ts";

import type { Indexer, TestIndexer } from "./src/Types.ts";
export const indexer: Indexer;
export const createTestIndexer: () => TestIndexer;
import {
  PredictionMarket,
  PredictionMarketFactory,
  MockDb,
  Addresses
} from "./src/TestHelpers.gen";

export const TestHelpers = {
  PredictionMarket,
  PredictionMarketFactory,
  MockDb,
  Addresses
};

export {
} from "./src/Enum.gen";

export {default as BigDecimal} from 'bignumber.js';
