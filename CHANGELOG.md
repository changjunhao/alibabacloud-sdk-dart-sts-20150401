# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
