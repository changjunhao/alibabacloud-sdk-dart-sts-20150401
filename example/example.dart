import 'package:alibabacloud_sts20150401/alibabacloud_sts20150401.dart';

void main() async {
  // Replace with your actual credentials
  const accessKeyId = 'your-access-key-id';
  const accessKeySecret = 'your-access-key-secret';
  const roleArn = 'acs:ram::123456789012****:role/adminrole';

  // Create STS client
  final client = StsClient(
    accessKeyId: accessKeyId,
    accessKeySecret: accessKeySecret,
    regionId: 'cn-hangzhou',
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
    print('  Account ID: ${response.accountId}');
    print('  User ID: ${response.userId}');
    print('  ARN: ${response.arn}');
    print('  Identity Type: ${response.identityType}');
    print('  Principal ID: ${response.principalId}');
    print('  Request ID: ${response.requestId}');
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
    print('  Request ID: ${response.requestId}');

    if (response.credentials != null) {
      print('  Temporary Credentials:');
      print('    AccessKeyId: ${response.credentials!.accessKeyId}');
      print(
          '    AccessKeySecret: ${response.credentials!.accessKeySecret?.substring(0, 8)}...');
      print(
          '    SecurityToken: ${response.credentials!.securityToken?.substring(0, 20)}...');
      print('    Expiration: ${response.credentials!.expiration}');
    }

    if (response.assumedRoleUser != null) {
      print('  Assumed Role User:');
      print('    ARN: ${response.assumedRoleUser!.arn}');
      print('    AssumedRoleId: ${response.assumedRoleUser!.assumedRoleId}');
    }

    if (response.sourceIdentity != null) {
      print('  Source Identity: ${response.sourceIdentity}');
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
    print('  Request ID: ${response.requestId}');
    print(
        '  Applied custom policy to limit permissions to OSS bucket access only');

    if (response.credentials != null) {
      print('  Limited Credentials:');
      print('    AccessKeyId: ${response.credentials!.accessKeyId}');
      print('    Expiration: ${response.credentials!.expiration}');
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
    print('  Request ID: ${response.requestId}');
    
    if (response.credentials != null) {
      print('  OIDC Credentials:');
      print('    AccessKeyId: ${response.credentials!.accessKeyId}');
      print('    Expiration: ${response.credentials!.expiration}');
    }
    
    if (response.oidcTokenInfo != null) {
      print('  OIDC Token Info:');
      print('    Issuer: ${response.oidcTokenInfo!.issuer}');
      print('    Subject: ${response.oidcTokenInfo!.subject}');
      print('    Client IDs: ${response.oidcTokenInfo!.clientIds}');
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
    print('  Request ID: ${response.requestId}');
    
    if (response.credentials != null) {
      print('  SAML Credentials:');
      print('    AccessKeyId: ${response.credentials!.accessKeyId}');
      print('    Expiration: ${response.credentials!.expiration}');
    }
    
    if (response.samlAssertionInfo != null) {
      print('  SAML Assertion Info:');
      print('    Issuer: ${response.samlAssertionInfo!.issuer}');
      print('    Subject: ${response.samlAssertionInfo!.subject}');
      print('    Recipient: ${response.samlAssertionInfo!.recipient}');
    }
  } catch (e) {
    print('✗ Error: $e');
  }
  
  print('');
}
*/
