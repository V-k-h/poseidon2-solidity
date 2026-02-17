
# Poseidon2 Solidity (BN254)

A Solidity implementation of the Poseidon2 hash function over the BN254 scalar field, 
with conformance tests against Barretenberg (bb.js) — the same implementation used by Noir stdlib.

## Overview

- `t=4`, `d=5`, `rounds_f=8`, `rounds_p=56`
- Supports hashing 1–9 field elements (`hash1` through `hash9`)
- Parameters match Barretenberg exactly, making it compatible with Noir circuits

## Project Structure

```
contracts/
  Poseidon2T4.sol       # Core library
  Poseidon2Harness.sol  # Test harness exposing internal functions
test/
  Poseidon2.t.sol       # Conformance tests against bb.js via FFI
bb_out.cjs              # Node.js oracle script (calls @aztec/foundation)
```

## Requirements

- [Foundry](https://getfoundry.sh/)
- Node.js + npm
- `@aztec/foundation` package

```bash
npm install @aztec/foundation
```

## Running Tests

FFI must be enabled since tests call the Barretenberg JS oracle:

```bash
forge test --ffi -vvv
```

## What the Tests Prove

All 20 tests verify that this Solidity implementation produces **bit-for-bit identical output** 
to Barretenberg's `poseidon2Hash` for:

- All arities 1–9
- Zero inputs
- Boundary values (PRIME-1, uint256.max)
- 10 random vectors per arity

This means any Noir circuit using `poseidon2Hash` will produce the same hash as this Solidity verifier.
