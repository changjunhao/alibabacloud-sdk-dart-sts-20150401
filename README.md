# Alibaba Cloud STS SDK for Dart

[![pub package](https://img.shields.io/pub/v/alibabacloud_sts20150401.svg)](https://pub.dev/packages/alibabacloud_sts20150401)
[![License](https://img.shields.io/badge/license-Apache%202.0-blue.svg)](LICENSE)

Alibaba Cloud Security Token Service (STS) SDK for Dart — request temporary, limited-privilege credentials for accessing cloud resources.

## Features

- **AssumeRole** — Obtain temporary credentials by assuming a RAM role
- **AssumeRoleWithOIDC** — Assume a role using an OpenID Connect (OIDC) identity provider
- **AssumeRoleWithSAML** — Assume a role using a SAML identity provider
- **GetCallerIdentity** — Retrieve the identity of the current caller
- **Automatic retry** with configurable backoff policies
- **Configurable timeouts** and runtime options

## Requirements

- Dart SDK: `>=2.17.0 <4.0.0`

## Installation

Add the dependency to your `pubspec.yaml`:

```yaml
dependencies:
  alibabacloud_sts20150401: ^1.1.0
```

Then run:

```bash
dart pub get
```

## Quick Start

```dart
import 'package:alibabacloud_sts20150401/alibabacloud_sts20150401.dart';

void main() async {
  final client = StsClient(
    accessKeyId: 'your-access-key-id',
    accessKeySecret: 'your-access-key-secret',
  );

  final response = await client.getCallerIdentity();
  print('Account ID: ${response.body?.accountId}');
  print('ARN: ${response.body?.arn}');
  print('Identity Type: ${response.body?.identityType}');
}
```

## Usage

### AssumeRole

```dart
final request = AssumeRoleRequest(
  roleArn: 'acs:ram::123456789012****:role/adminrole',
  roleSessionName: 'my-session',
  durationSeconds: 3600,
  policy: '{"Version":"1","Statement":[{"Effect":"Allow","Action":"oss:GetObject","Resource":"acs:oss:*:*:mybucket/*"}]}',
  externalId: 'external-id',       // optional
  sourceIdentity: 'source-id',     // optional
);

final response = await client.assumeRole(request);
print('AccessKeyId: ${response.body?.credentials?.accessKeyId}');
print('AccessKeySecret: ${response.body?.credentials?.accessKeySecret}');
print('SecurityToken: ${response.body?.credentials?.securityToken}');
print('Expiration: ${response.body?.credentials?.expiration}');
print('Assumed Role ARN: ${response.body?.assumedRoleUser?.arn}');
```

### AssumeRole with OIDC

```dart
// OIDC does not require AccessKey credentials
final client = StsClient(
  accessKeyId: '',
  accessKeySecret: '',
);

final request = AssumeRoleWithOIDCRequest(
  roleArn: 'acs:ram::123456789012****:role/oidcrole',
  roleSessionName: 'oidc-session',
  oidcProviderArn: 'acs:ram::123456789012****:oidc-provider/my-provider',
  oidcToken: 'your-oidc-token',
  durationSeconds: 3600,
);

final response = await client.assumeRoleWithOIDC(request);
print('AccessKeyId: ${response.body?.credentials?.accessKeyId}');
print('Issuer: ${response.body?.oidcTokenInfo?.issuer}');
print('Subject: ${response.body?.oidcTokenInfo?.subject}');
```

### AssumeRole with SAML

```dart
// SAML does not require AccessKey credentials
final client = StsClient(
  accessKeyId: '',
  accessKeySecret: '',
);

final request = AssumeRoleWithSAMLRequest(
  roleArn: 'acs:ram::123456789012****:role/samlrole',
  samlProviderArn: 'acs:ram::123456789012****:saml-provider/my-provider',
  samlAssertion: 'base64-encoded-saml-assertion',
  durationSeconds: 3600,
);

final response = await client.assumeRoleWithSAML(request);
print('AccessKeyId: ${response.body?.credentials?.accessKeyId}');
print('Issuer: ${response.body?.samlAssertionInfo?.issuer}');
print('Subject: ${response.body?.samlAssertionInfo?.subject}');
```

### GetCallerIdentity

```dart
final response = await client.getCallerIdentity();
print('Account ID: ${response.body?.accountId}');
print('User ID: ${response.body?.userId}');
print('ARN: ${response.body?.arn}');
print('Identity Type: ${response.body?.identityType}');
print('Principal ID: ${response.body?.principalId}');
```

### RuntimeOptions (Timeout & Retry)

Every API method has a `*WithOptions` variant that accepts `RuntimeOptions`:

```dart
final runtime = RuntimeOptions(
  autoretry: true,
  maxAttempts: 3,
  backoffPolicy: 'exponential', // 'no', 'equal', or 'exponential'
  backoffPeriod: 1000,          // milliseconds
  connectTimeout: 5000,         // milliseconds
  readTimeout: 10000,           // milliseconds
);

final response = await client.assumeRoleWithOptions(request, runtime);
// Also available:
// client.assumeRoleWithOIDCWithOptions(request, runtime)
// client.assumeRoleWithSAMLWithOptions(request, runtime)
// client.getCallerIdentityWithOptions(runtime)
```

## Error Handling

The SDK throws `StsException` on API errors:

```dart
try {
  final response = await client.assumeRole(request);
} on StsException catch (e) {
  print('Code: ${e.code}');
  print('Message: ${e.message}');
  print('Request ID: ${e.requestId}');
  print('HTTP Status: ${e.statusCode}');
}
```

## API Reference

### StsClient

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `accessKeyId` | `String` | Yes | — | Alibaba Cloud AccessKey ID |
| `accessKeySecret` | `String` | Yes | — | Alibaba Cloud AccessKey Secret |
| `securityToken` | `String?` | No | `null` | STS token for temporary credentials |
| `regionId` | `String` | No | `'cn-hangzhou'` | Region ID |
| `endpoint` | `String?` | No | `null` | Custom endpoint (overrides default resolution) |

#### Methods

| Method | Returns |
|--------|---------|
| `assumeRole(AssumeRoleRequest)` | `Future<AssumeRoleResponse>` |
| `assumeRoleWithOptions(AssumeRoleRequest, RuntimeOptions)` | `Future<AssumeRoleResponse>` |
| `assumeRoleWithOIDC(AssumeRoleWithOIDCRequest)` | `Future<AssumeRoleWithOIDCResponse>` |
| `assumeRoleWithOIDCWithOptions(AssumeRoleWithOIDCRequest, RuntimeOptions)` | `Future<AssumeRoleWithOIDCResponse>` |
| `assumeRoleWithSAML(AssumeRoleWithSAMLRequest)` | `Future<AssumeRoleWithSAMLResponse>` |
| `assumeRoleWithSAMLWithOptions(AssumeRoleWithSAMLRequest, RuntimeOptions)` | `Future<AssumeRoleWithSAMLResponse>` |
| `getCallerIdentity()` | `Future<GetCallerIdentityResponse>` |
| `getCallerIdentityWithOptions(RuntimeOptions)` | `Future<GetCallerIdentityResponse>` |

### Models

#### AssumeRoleRequest

| Field | Type | Description |
|-------|------|-------------|
| `roleArn` | `String?` | ARN of the RAM role |
| `roleSessionName` | `String?` | Custom name of the role session |
| `durationSeconds` | `int?` | Token validity period in seconds |
| `policy` | `String?` | Permission policy (JSON) to limit the token |
| `externalId` | `String?` | External ID of the RAM role |
| `sourceIdentity` | `String?` | Source identity |

#### AssumeRoleWithOIDCRequest

| Field | Type | Description |
|-------|------|-------------|
| `roleArn` | `String?` | ARN of the RAM role |
| `roleSessionName` | `String?` | Custom name of the role session |
| `oidcProviderArn` | `String?` | ARN of the OIDC identity provider |
| `oidcToken` | `String?` | OIDC token |
| `durationSeconds` | `int?` | Token validity period in seconds |
| `policy` | `String?` | Permission policy (JSON) to limit the token |

#### AssumeRoleWithSAMLRequest

| Field | Type | Description |
|-------|------|-------------|
| `roleArn` | `String?` | ARN of the RAM role |
| `samlProviderArn` | `String?` | ARN of the SAML identity provider |
| `samlAssertion` | `String?` | Base64-encoded SAML assertion |
| `durationSeconds` | `int?` | Token validity period in seconds |
| `policy` | `String?` | Permission policy (JSON) to limit the token |

#### Credentials

| Field | Type | Description |
|-------|------|-------------|
| `accessKeyId` | `String?` | Temporary AccessKey ID |
| `accessKeySecret` | `String?` | Temporary AccessKey Secret |
| `securityToken` | `String?` | Security token |
| `expiration` | `String?` | Token expiration time (UTC) |

#### GetCallerIdentityResponseBody

| Field | Type | Description |
|-------|------|-------------|
| `accountId` | `String?` | Alibaba Cloud account ID |
| `arn` | `String?` | ARN of the caller |
| `identityType` | `String?` | Caller identity type |
| `principalId` | `String?` | Principal ID |
| `userId` | `String?` | RAM user ID |
| `roleId` | `String?` | RAM role ID |
| `requestId` | `String?` | Request ID |

#### RuntimeOptions

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `autoretry` | `bool?` | `null` | Enable automatic retry |
| `maxAttempts` | `int?` | `3` | Maximum retry attempts |
| `backoffPolicy` | `String?` | `null` | `'no'`, `'equal'`, or `'exponential'` |
| `backoffPeriod` | `int?` | `null` | Backoff period in milliseconds |
| `connectTimeout` | `int?` | `5000` | Connection timeout in milliseconds |
| `readTimeout` | `int?` | `10000` | Read timeout in milliseconds |

## License

[Apache 2.0](LICENSE)
