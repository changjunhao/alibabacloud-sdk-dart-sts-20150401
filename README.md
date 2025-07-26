# Alibaba Cloud STS SDK for Dart

[![pub package](https://img.shields.io/pub/v/alibabacloud_sts20150401.svg)](https://pub.dev/packages/alibabacloud_sts20150401)
[![License](https://img.shields.io/badge/license-Apache%202.0-blue.svg)](LICENSE)

Alibaba Cloud Security Token Service (STS) SDK for Dart. This SDK allows you to request temporary, limited-privilege credentials for users or applications.

## Features

- **AssumeRole**: Obtain temporary credentials by assuming a RAM role
- **AssumeRoleWithOIDC**: Assume a role using OpenID Connect (OIDC) identity provider
- **AssumeRoleWithSAML**: Assume a role using Security Assertion Markup Language (SAML) identity provider
- **GetCallerIdentity**: Get information about the current caller identity

## Installation

Add this package to your `pubspec.yaml`:

```yaml
dependencies:
  alibabacloud_sts20150401: ^1.0.0
```

Then run:

```bash
dart pub get
```

## Quick Start

### Basic Usage

```dart
import 'package:alibabacloud_sts20150401/alibabacloud_sts20150401.dart';

void main() async {
  // Create STS client
  final client = StsClient(
    accessKeyId: 'your-access-key-id',
    accessKeySecret: 'your-access-key-secret',
    regionId: 'cn-hangzhou', // Optional, defaults to 'cn-hangzhou'
  );

  try {
    // Get caller identity
    final identity = await client.getCallerIdentity();
    print('Account ID: ${identity.accountId}');
    print('User ID: ${identity.userId}');
    print('ARN: ${identity.arn}');
  } catch (e) {
    print('Error: $e');
  }
}
```

### Assume Role

```dart
import 'package:alibabacloud_sts20150401/alibabacloud_sts20150401.dart';

void main() async {
  final client = StsClient(
    accessKeyId: 'your-access-key-id',
    accessKeySecret: 'your-access-key-secret',
  );

  final request = AssumeRoleRequest(
    roleArn: 'acs:ram::123456789012****:role/adminrole',
    roleSessionName: 'session-name',
    durationSeconds: 3600, // 1 hour
    policy: '''{
      "Version": "1",
      "Statement": [
        {
          "Effect": "Allow",
          "Action": "oss:GetObject",
          "Resource": "acs:oss:*:*:mybucket/*"
        }
      ]
    }''', // Optional: limit permissions
  );

  try {
    final response = await client.assumeRole(request);
    
    print('Temporary credentials:');
    print('AccessKeyId: ${response.credentials?.accessKeyId}');
    print('AccessKeySecret: ${response.credentials?.accessKeySecret}');
    print('SecurityToken: ${response.credentials?.securityToken}');
    print('Expiration: ${response.credentials?.expiration}');
    
    print('Assumed role user:');
    print('ARN: ${response.assumedRoleUser?.arn}');
    print('AssumedRoleId: ${response.assumedRoleUser?.assumedRoleId}');
  } catch (e) {
    print('Error: $e');
  }
}
```

### Assume Role with OIDC

```dart
import 'package:alibabacloud_sts20150401/alibabacloud_sts20150401.dart';

void main() async {
  // Note: For OIDC, you don't need AccessKey credentials
  final client = StsClient(
    accessKeyId: '', // Empty for OIDC
    accessKeySecret: '', // Empty for OIDC
  );

  final request = AssumeRoleWithOIDCRequest(
    roleArn: 'acs:ram::123456789012****:role/oidcrole',
    roleSessionName: 'oidc-session',
    oidcProviderArn: 'acs:ram::123456789012****:oidc-provider/provider-name',
    oidcToken: 'your-oidc-token',
    durationSeconds: 3600,
  );

  try {
    final response = await client.assumeRoleWithOIDC(request);
    
    print('Temporary credentials:');
    print('AccessKeyId: ${response.credentials?.accessKeyId}');
    print('AccessKeySecret: ${response.credentials?.accessKeySecret}');
    print('SecurityToken: ${response.credentials?.securityToken}');
    
    print('OIDC token info:');
    print('Issuer: ${response.oidcTokenInfo?.issuer}');
    print('Subject: ${response.oidcTokenInfo?.subject}');
  } catch (e) {
    print('Error: $e');
  }
}
```

### Assume Role with SAML

```dart
import 'package:alibabacloud_sts20150401/alibabacloud_sts20150401.dart';

void main() async {
  // Note: For SAML, you don't need AccessKey credentials
  final client = StsClient(
    accessKeyId: '', // Empty for SAML
    accessKeySecret: '', // Empty for SAML
  );

  final request = AssumeRoleWithSAMLRequest(
    roleArn: 'acs:ram::123456789012****:role/samlrole',
    samlProviderArn: 'acs:ram::123456789012****:saml-provider/provider-name',
    samlAssertion: 'base64-encoded-saml-assertion',
    durationSeconds: 3600,
  );

  try {
    final response = await client.assumeRoleWithSAML(request);
    
    print('Temporary credentials:');
    print('AccessKeyId: ${response.credentials?.accessKeyId}');
    print('AccessKeySecret: ${response.credentials?.accessKeySecret}');
    print('SecurityToken: ${response.credentials?.securityToken}');
    
    print('SAML assertion info:');
    print('Issuer: ${response.samlAssertionInfo?.issuer}');
    print('Subject: ${response.samlAssertionInfo?.subject}');
  } catch (e) {
    print('Error: $e');
  }
}
```

## Configuration

### Client Configuration

```dart
final client = StsClient(
  accessKeyId: 'your-access-key-id',
  accessKeySecret: 'your-access-key-secret',
  securityToken: 'your-security-token', // Optional: for temporary credentials
  regionId: 'cn-hangzhou', // Optional: defaults to 'cn-hangzhou'
  endpoint: 'sts.cn-hangzhou.aliyuncs.com', // Optional: custom endpoint
);
```

### Supported Regions

The SDK supports all Alibaba Cloud regions. Some commonly used regions:

- `cn-hangzhou` (China East 1)
- `cn-shanghai` (China East 2)
- `cn-beijing` (China North 2)
- `cn-shenzhen` (China South 1)
- `ap-southeast-1` (Singapore)
- `us-west-1` (US West 1)
- `eu-central-1` (Germany Frankfurt)

## Error Handling

The SDK throws `StsException` for API errors:

```dart
try {
  final response = await client.assumeRole(request);
  // Handle success
} on StsException catch (e) {
  print('STS Error: ${e.message}');
} catch (e) {
  print('Other Error: $e');
}
```

## API Reference

### StsClient

#### Methods

- `Future<AssumeRoleResponse> assumeRole(AssumeRoleRequest request)`
- `Future<AssumeRoleWithOIDCResponse> assumeRoleWithOIDC(AssumeRoleWithOIDCRequest request)`
- `Future<AssumeRoleWithSAMLResponse> assumeRoleWithSAML(AssumeRoleWithSAMLRequest request)`
- `Future<GetCallerIdentityResponse> getCallerIdentity()`

### Request Models

- `AssumeRoleRequest`
- `AssumeRoleWithOIDCRequest`
- `AssumeRoleWithSAMLRequest`

### Response Models

- `AssumeRoleResponse`
- `AssumeRoleWithOIDCResponse`
- `AssumeRoleWithSAMLResponse`
- `GetCallerIdentityResponse`

### Common Models

- `Credentials`
- `AssumedRoleUser`
- `OIDCTokenInfo`
- `SAMLAssertionInfo`

## Requirements

- Dart SDK: >=2.17.0 <4.0.0

## Dependencies

- `http`: For making HTTP requests
- `crypto`: For signature generation
- `convert`: For encoding/decoding

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the Apache 2.0 License - see the [LICENSE](LICENSE) file for details.

## Links

- [Alibaba Cloud STS Documentation](https://www.alibabacloud.com/help/en/ram/developer-reference/api-sts-2015-04-01-assumerole)
- [Alibaba Cloud Console](https://ecs.console.aliyun.com/)
- [Dart Package](https://pub.dev/packages/alibabacloud_sts20150401)