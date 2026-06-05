// ignore_for_file: avoid_print
import 'dart:io';

import 'package:alibabacloud_sts20150401/alibabacloud_sts20150401.dart';

void main() async {
  // Read credentials from environment variables
  final accessKeyId = Platform.environment['ALIYUN_ACCESS_KEY_ID'];
  final accessKeySecret = Platform.environment['ALIYUN_ACCESS_KEY_SECRET'];
  final roleArn = Platform.environment['ALIYUN_STS_ROLE_ARN'];

  if (accessKeyId == null || accessKeyId.isEmpty) {
    print('Error: Environment variable ALIYUN_ACCESS_KEY_ID is not set.');
    exit(1);
  }
  if (accessKeySecret == null || accessKeySecret.isEmpty) {
    print('Error: Environment variable ALIYUN_ACCESS_KEY_SECRET is not set.');
    exit(1);
  }
  if (roleArn == null || roleArn.isEmpty) {
    print('Error: Environment variable ALIYUN_STS_ROLE_ARN is not set.');
    exit(1);
  }

  // Create STS client
  final client = StsClient(
    accessKeyId: accessKeyId,
    accessKeySecret: accessKeySecret,
    regionId: 'cn-beijing',
  );

  print('=== Alibaba Cloud STS SDK for Dart Example ===\n');

  // Example 1: Get caller identity
  await getCallerIdentityExample(client);

  // Example 2: Assume role
  await assumeRoleExample(client, roleArn);

  // Example 3: Assume role with policy
  await assumeRoleWithPolicyExample(client, roleArn);
}

/// Example: Get caller identity
Future<void> getCallerIdentityExample(StsClient client) async {
  print('1. Getting caller identity...');

  try {
    final response = await client.getCallerIdentity();

    print('✓ Success!');
    print('  Status Code: ${response.statusCode}');
    print('  Account ID: ${response.body?.accountId}');
    print('  User ID: ${response.body?.userId}');
    print('  ARN: ${response.body?.arn}');
    print('  Identity Type: ${response.body?.identityType}');
    print('  Principal ID: ${response.body?.principalId}');
    print('  Request ID: ${response.body?.requestId}');
  } catch (e) {
    print('✗ Error: $e');
  }

  print('');
}

/// Example: Assume role
Future<void> assumeRoleExample(StsClient client, String roleArn) async {
  print('2. Assuming role...');

  final request = AssumeRoleRequest(
    roleArn: roleArn,
    roleSessionName: 'dart-sdk-example-session',
    durationSeconds: 3600, // 1 hour
    externalId: 'external-id-example',
  );

  try {
    final response = await client.assumeRole(request);

    print('✓ Success!');
    print('  Status Code: ${response.statusCode}');
    print('  Request ID: ${response.body?.requestId}');

    if (response.body?.credentials != null) {
      print('  Temporary Credentials:');
      print('    AccessKeyId: ${response.body!.credentials!.accessKeyId}');
      print(
          '    AccessKeySecret: ${response.body!.credentials!.accessKeySecret?.substring(0, 8)}...');
      print(
          '    SecurityToken: ${response.body!.credentials!.securityToken?.substring(0, 20)}...');
      print('    Expiration: ${response.body!.credentials!.expiration}');
    }

    if (response.body?.assumedRoleUser != null) {
      print('  Assumed Role User:');
      print('    ARN: ${response.body!.assumedRoleUser!.arn}');
      print('    AssumedRoleId: ${response.body!.assumedRoleUser!.assumedRoleId}');
    }

    if (response.body?.sourceIdentity != null) {
      print('  Source Identity: ${response.body!.sourceIdentity}');
    }
  } catch (e) {
    print('✗ Error: $e');
  }

  print('');
}

/// Example: Assume role with custom policy
Future<void> assumeRoleWithPolicyExample(
    StsClient client, String roleArn) async {
  print('3. Assuming role with custom policy...');

  // Custom policy that only allows reading from a specific OSS bucket
  const customPolicy = '''{
  "Version": "1",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "oss:GetObject",
        "oss:ListObjects"
      ],
      "Resource": [
        "acs:oss:*:*:my-bucket/*",
        "acs:oss:*:*:my-bucket"
      ]
    }
  ]
}''';

  final request = AssumeRoleRequest(
    roleArn: roleArn,
    roleSessionName: 'dart-sdk-limited-session',
    durationSeconds: 1800, // 30 minutes
    policy: customPolicy,
  );

  try {
    final response = await client.assumeRole(request);

    print('✓ Success!');
    print('  Status Code: ${response.statusCode}');
    print('  Request ID: ${response.body?.requestId}');
    print(
        '  Applied custom policy to limit permissions to OSS bucket access only');

    if (response.body?.credentials != null) {
      print('  Limited Credentials:');
      print('    AccessKeyId: ${response.body!.credentials!.accessKeyId}');
      print('    Expiration: ${response.body!.credentials!.expiration}');
    }
  } catch (e) {
    print('✗ Error: $e');
  }

  print('');
}

/// Example: Assume role with OIDC (commented out as it requires OIDC setup)
/*
Future<void> assumeRoleWithOIDCExample() async {
  print('4. Assuming role with OIDC...');
  
  // Note: For OIDC, you don't need AccessKey credentials
  final client = StsClient(
    accessKeyId: '',
    accessKeySecret: '',
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
    
    print('✓ Success!');
    print('  Status Code: ${response.statusCode}');
    print('  Request ID: ${response.body?.requestId}');
    
    if (response.body?.credentials != null) {
      print('  OIDC Credentials:');
      print('    AccessKeyId: ${response.body!.credentials!.accessKeyId}');
      print('    Expiration: ${response.body!.credentials!.expiration}');
    }
    
    if (response.body?.oidcTokenInfo != null) {
      print('  OIDC Token Info:');
      print('    Issuer: ${response.body!.oidcTokenInfo!.issuer}');
      print('    Subject: ${response.body!.oidcTokenInfo!.subject}');
      print('    Client IDs: ${response.body!.oidcTokenInfo!.clientIds}');
    }
  } catch (e) {
    print('✗ Error: $e');
  }
  
  print('');
}
*/

/// Example: Assume role with SAML (commented out as it requires SAML setup)
/*
Future<void> assumeRoleWithSAMLExample() async {
  print('5. Assuming role with SAML...');
  
  // Note: For SAML, you don't need AccessKey credentials
  final client = StsClient(
    accessKeyId: '',
    accessKeySecret: '',
  );
  
  final request = AssumeRoleWithSAMLRequest(
    roleArn: 'acs:ram::123456789012****:role/samlrole',
    samlProviderArn: 'acs:ram::123456789012****:saml-provider/provider-name',
    samlAssertion: 'base64-encoded-saml-assertion',
    durationSeconds: 3600,
  );
  
  try {
    final response = await client.assumeRoleWithSAML(request);
    
    print('✓ Success!');
    print('  Status Code: ${response.statusCode}');
    print('  Request ID: ${response.body?.requestId}');
    
    if (response.body?.credentials != null) {
      print('  SAML Credentials:');
      print('    AccessKeyId: ${response.body!.credentials!.accessKeyId}');
      print('    Expiration: ${response.body!.credentials!.expiration}');
    }
    
    if (response.body?.samlAssertionInfo != null) {
      print('  SAML Assertion Info:');
      print('    Issuer: ${response.body!.samlAssertionInfo!.issuer}');
      print('    Subject: ${response.body!.samlAssertionInfo!.subject}');
      print('    Recipient: ${response.body!.samlAssertionInfo!.recipient}');
    }
  } catch (e) {
    print('✗ Error: $e');
  }
  
  print('');
}
*/
