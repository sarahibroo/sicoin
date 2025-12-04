# sicoin

A simple fungible token smart contract implemented in [Clarity](https://docs.stacks.co/write-smart-contracts/clarity-overview) and managed with [Clarinet](https://github.com/hirosystems/clarinet).

## Project structure

- `Clarinet.toml` – Clarinet project configuration
- `contracts/` – Clarity smart contracts
  - `sicoin.clar` – SIP-010–style fungible token implementation for SICOIN
- `settings/` – Clarinet environment and network settings
- `tests/` – JavaScript/TypeScript tests for Clarinet (currently empty)

## Prerequisites

- Node.js and npm
- Clarinet CLI (`clarinet`)

You can verify that Clarinet is installed with:

```bash path=null start=null
clarinet --version
```

## Common workflows

### Check the contract for errors

From the project root:

```bash path=null start=null
clarinet check
```

This runs Clarinet’s static analysis and checker passes defined in `Clarinet.toml`.

### Open a local REPL

```bash path=null start=null
clarinet console
```

This starts an interactive console where you can call read-only and public functions from `sicoin.clar`.

### Run tests (if/when added)

Clarinet supports writing tests in JavaScript/TypeScript using the Clarinet test runner. Once you add tests under the `tests/` directory, you can run them with:

```bash path=null start=null
clarinet test
```

## sicoin token overview

The `sicoin.clar` contract defines:

- A fungible token named `Sicoin` with symbol `SIC`
- Read-only functions to query metadata and balances (name, symbol, decimals, total supply, balance, token URI)
- An admin principal (initialized to `contract-owner`) that can mint new tokens
- Public functions to:
  - `mint` new tokens to a recipient (admin-only)
  - `transfer` tokens between principals, enforcing balances and authorization
  - `transfer-from-tx-sender` as a convenience wrapper for transfers initiated by `tx-sender`

These functions are designed to align with the SIP-010 fungible token standard so that wallets and other tooling can integrate with the token.
