/**
 * EventHandlers.ts
 *
 * Handlers for:
 *   PredictionMarketFactory → MarketCreated
 *   PredictionMarket        → Mint | Burn | Settle | Resolved | Finalized |
 *                             Expired | ChallengeSubmitted | ChallengeResolved
 *
 * MarketCreated triggers dynamic registration of the new PredictionMarket clone
 * so that all subsequent lifecycle events on that address are automatically indexed.
 */

import {
  PredictionMarketFactory,
  PredictionMarket,
} from "../generated/index.js";

// ---------------------------------------------------------------------------
// PredictionMarketFactory.MarketCreated
// ---------------------------------------------------------------------------
PredictionMarketFactory.MarketCreated.handler(async ({ event, context }) => {
  const marketAddr = event.params.market.toLowerCase();
  const factoryAddr = event.srcAddress.toLowerCase();

  context.Market.set({
    id: marketAddr,
    factory: factoryAddr,
    creator: event.params.creator.toLowerCase(),
    resolver: event.params.resolver.toLowerCase(),
    collateralToken: event.params.collateralToken.toLowerCase(),
    numOutcomes: Number(event.params.numOutcomes),
    outcomeTokens: JSON.stringify(
      event.params.outcomeTokens.map((a: string) => a.toLowerCase())
    ),
    orderbooks: JSON.stringify(
      event.params.orderbooks.map((a: string) => a.toLowerCase())
    ),
    resolutionBlock: event.params.resolutionBlock,
    allowChallenge: event.params.allowChallenge,
    insuranceBond: event.params.insuranceBond,
    metadata: event.params.metadata,
    status: "ACTIVE",
    resolvedOutcome: undefined,
    resolvedBlock: undefined,
    totalCollateral: 0n,
    challenger: undefined,
    challengerBond: undefined,
    challengerProposedOutcome: undefined,
    challengeStatus: "NONE",
    createdAt: BigInt(event.block.timestamp),
    createdAtBlock: BigInt(event.block.number),
  });
});

// Dynamically register new market contracts so their events are indexed.
PredictionMarketFactory.MarketCreated.contractRegister(({ event, context }) => {
  context.addPredictionMarket(event.params.market);
});

// ---------------------------------------------------------------------------
// PredictionMarket.Mint
// ---------------------------------------------------------------------------
PredictionMarket.Mint.handler(async ({ event, context }) => {
  const marketAddr = event.srcAddress.toLowerCase();
  const userAddr = event.params.user.toLowerCase();
  const amount = event.params.amount;

  const market = await context.Market.get(marketAddr);
  if (market) {
    context.Market.set({
      ...market,
      totalCollateral: market.totalCollateral + amount,
    });
  }

  context.MarketActivity.set({
    id: `Mint-${event.block.number}-${event.logIndex}`,
    market_id: marketAddr,
    type: "Mint",
    user: userAddr,
    amount,
    outcome: undefined,
    timestamp: BigInt(event.block.timestamp),
    blockNumber: BigInt(event.block.number),
  });
});

// ---------------------------------------------------------------------------
// PredictionMarket.Burn
// ---------------------------------------------------------------------------
PredictionMarket.Burn.handler(async ({ event, context }) => {
  const marketAddr = event.srcAddress.toLowerCase();
  const userAddr = event.params.user.toLowerCase();
  const amount = event.params.amount;

  const market = await context.Market.get(marketAddr);
  if (market) {
    const prev = market.totalCollateral;
    context.Market.set({
      ...market,
      totalCollateral: prev >= amount ? prev - amount : 0n,
    });
  }

  context.MarketActivity.set({
    id: `Burn-${event.block.number}-${event.logIndex}`,
    market_id: marketAddr,
    type: "Burn",
    user: userAddr,
    amount,
    outcome: undefined,
    timestamp: BigInt(event.block.timestamp),
    blockNumber: BigInt(event.block.number),
  });
});

// ---------------------------------------------------------------------------
// PredictionMarket.Settle
// ---------------------------------------------------------------------------
PredictionMarket.Settle.handler(async ({ event, context }) => {
  const marketAddr = event.srcAddress.toLowerCase();
  const userAddr = event.params.user.toLowerCase();
  const amount = event.params.amount;
  const outcome = event.params.winningOutcome;

  const market = await context.Market.get(marketAddr);
  if (market) {
    const prev = market.totalCollateral;
    context.Market.set({
      ...market,
      totalCollateral: prev >= amount ? prev - amount : 0n,
    });
  }

  context.MarketActivity.set({
    id: `Settle-${event.block.number}-${event.logIndex}`,
    market_id: marketAddr,
    type: "Settle",
    user: userAddr,
    amount,
    outcome: Number(outcome),
    timestamp: BigInt(event.block.timestamp),
    blockNumber: BigInt(event.block.number),
  });
});

// ---------------------------------------------------------------------------
// PredictionMarket.Resolved
// ---------------------------------------------------------------------------
PredictionMarket.Resolved.handler(async ({ event, context }) => {
  const marketAddr = event.srcAddress.toLowerCase();
  const market = await context.Market.get(marketAddr);
  if (market) {
    context.Market.set({
      ...market,
      status: "RESOLVED",
      resolvedOutcome: Number(event.params.outcome),
      resolvedBlock: BigInt(event.block.number),
    });
  }
});

// ---------------------------------------------------------------------------
// PredictionMarket.Finalized
// ---------------------------------------------------------------------------
PredictionMarket.Finalized.handler(async ({ event, context }) => {
  const marketAddr = event.srcAddress.toLowerCase();
  const market = await context.Market.get(marketAddr);
  if (market) {
    context.Market.set({
      ...market,
      status: "FINALIZED",
      resolvedOutcome: Number(event.params.outcome),
    });
  }
});

// ---------------------------------------------------------------------------
// PredictionMarket.Expired
// ---------------------------------------------------------------------------
PredictionMarket.Expired.handler(async ({ event, context }) => {
  const marketAddr = event.srcAddress.toLowerCase();
  const market = await context.Market.get(marketAddr);
  if (market) {
    context.Market.set({
      ...market,
      status: "EXPIRED",
      resolvedOutcome: Number(event.params.defaultOutcome),
    });
  }
});

// ---------------------------------------------------------------------------
// PredictionMarket.ChallengeSubmitted
// ---------------------------------------------------------------------------
PredictionMarket.ChallengeSubmitted.handler(async ({ event, context }) => {
  const marketAddr = event.srcAddress.toLowerCase();
  const market = await context.Market.get(marketAddr);
  if (market) {
    context.Market.set({
      ...market,
      challenger: event.params.challenger.toLowerCase(),
      challengerBond: event.params.bondAmount,
      challengerProposedOutcome: Number(event.params.proposedOutcome),
      challengeStatus: "CHALLENGED",
    });
  }
});

// ---------------------------------------------------------------------------
// PredictionMarket.ChallengeResolved
// ---------------------------------------------------------------------------
PredictionMarket.ChallengeResolved.handler(async ({ event, context }) => {
  const marketAddr = event.srcAddress.toLowerCase();
  const market = await context.Market.get(marketAddr);
  if (market) {
    context.Market.set({
      ...market,
      resolvedOutcome: Number(event.params.finalOutcome),
      challengeStatus: "SETTLED",
    });
  }
});

export {};
