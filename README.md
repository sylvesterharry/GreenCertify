# GreenCertify

GreenCertify is a blockchain-based renewable energy certificate verification platform built on Stacks blockchain, enabling transparent tracking and verification of renewable energy production and environmental impact.

## Features

- **Certificate Registration**: Energy producers can register renewable energy certificates with generation details
- **Verification System**: Certified auditors can verify renewable energy production claims
- **Transparency**: Complete visibility of energy generation methods and facility information
- **Immutable Records**: Blockchain-based records ensure renewable energy certificate authenticity

## Smart Contract Functions

### Administration
- `add-energy-auditor`: Register certified energy auditors for certificate verification

### Producer Functions
- `register-energy-certificate`: Register new renewable energy certificate with production details
- `get-producer-certificates`: View all certificates registered by an energy producer

### Verification
- `verify-energy-certificate`: Energy auditors can verify renewable energy production
- `is-energy-auditor`: Check if an address is a certified energy auditor

### Data Access
- `get-energy-certificate`: Retrieve complete certificate information and verification status

## Getting Started

1. Clone this repository
2. Install [Clarinet](https://github.com/hirosystems/clarinet)
3. Run `clarinet check` to verify the contract
4. Deploy using Clarinet or Stacks CLI

## For Energy Producers

Register renewable energy certificates by providing:
- Energy source type (solar, wind, hydro, etc.)
- Generation details and capacity
- Production period
- Facility location

## For Energy Auditors

Certified auditors can review and verify energy certificates, ensuring renewable energy standards compliance.