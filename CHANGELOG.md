# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.0] - 2026-06-05

### Added
- RuntimeOptions support for all API methods (timeout, retry, proxy configuration)
- Auto-retry mechanism with exponential, equal, and no-backoff strategies
- `*WithOptions` variants for all API methods (assumeRoleWithOptions, etc.)
- Integration tests with real Alibaba Cloud API calls
- HTTP mock-based unit tests for request format, auth, retry, and error handling
- Comprehensive dartdoc comments for all public APIs

### Fixed
- SignatureNonce generation now uses UUID v4 + timestamp + MD5 for proper uniqueness and security
- Anonymous auth (OIDC/SAML) no longer sends unnecessary SignatureMethod/SignatureVersion params

### Changed
- Enhanced StsException with `code`, `requestId`, and `statusCode` fields
- Extracted internal utilities to `src/utils.dart` (not exported to library consumers)
- Added `@visibleForTesting` annotation for test-only httpClient injection
- Updated all dependencies to latest versions
- Configured stricter lint rules (prefer_final_locals, prefer_const_constructors, etc.)
- Rewritten README with complete API reference and usage examples

### Dependencies
- http: ^1.6.0
- crypto: ^3.0.7
- convert: ^3.1.2
- meta: ^1.18.0
- uuid: ^4.5.0

---

## [1.0.0] - 2025-07-26

### Added
- Initial release of Alibaba Cloud STS SDK for Dart
- Support for AssumeRole operation
- Support for AssumeRoleWithOIDC operation
- Support for AssumeRoleWithSAML operation
- Support for GetCallerIdentity operation
- Comprehensive request and response models
- Built-in signature generation and authentication
- Support for all Alibaba Cloud regions
- Error handling with custom StsException
- Complete documentation and examples

### Features
- **Client**: StsClient class for making STS API calls
- **Models**: Complete data models for all STS operations
- **Authentication**: Automatic signature generation using AccessKey
- **Regions**: Support for all Alibaba Cloud regions with automatic endpoint resolution
- **Error Handling**: Custom exception handling for API errors
- **Serialization**: JSON serialization/deserialization for all models

### Dependencies
- http: ^1.1.0
- crypto: ^3.0.3
- convert: ^3.1.1
