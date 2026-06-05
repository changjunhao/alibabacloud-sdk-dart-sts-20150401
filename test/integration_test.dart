@Tags(['integration'])
library integration_test;

import 'dart:io';
import 'package:test/test.dart';
import 'package:alibabacloud_sts20150401/alibabacloud_sts20150401.dart';

void main() {
  final accessKeyId = Platform.environment['ALIYUN_ACCESS_KEY_ID'];
  final accessKeySecret = Platform.environment['ALIYUN_ACCESS_KEY_SECRET'];
  final roleArn = Platform.environment['ALIYUN_STS_ROLE_ARN'];

  final hasCredentials = accessKeyId != null &&
      accessKeySecret != null &&
      accessKeyId.isNotEmpty &&
      accessKeySecret.isNotEmpty;

  final hasRoleArn = roleArn != null && roleArn.isNotEmpty;

  group('getCallerIdentity real API call', () {
    test('returns valid caller identity', () async {
      final client = StsClient(
        accessKeyId: accessKeyId!,
        accessKeySecret: accessKeySecret!,
      );

      final response = await client.getCallerIdentity();

      expect(response.body, isNotNull);
      expect(response.body!.accountId, isNotNull);
      expect(response.body!.accountId, isNotEmpty);
      expect(response.body!.arn, isNotNull);
      expect(response.body!.arn, isNotEmpty);
      expect(response.body!.identityType, isNotNull);
      expect(response.body!.identityType, isNotEmpty);
      expect(response.body!.requestId, isNotNull);
      expect(response.body!.requestId, isNotEmpty);
    },
        skip: hasCredentials
            ? null
            : 'ALIYUN_ACCESS_KEY_ID and ALIYUN_ACCESS_KEY_SECRET not set');
  });

  group('assumeRole real API call', () {
    test('returns valid temporary credentials', () async {
      final client = StsClient(
        accessKeyId: accessKeyId!,
        accessKeySecret: accessKeySecret!,
      );

      final request = AssumeRoleRequest(
        roleArn: roleArn!,
        roleSessionName: 'dart-sdk-integration-test',
        durationSeconds: 900,
      );

      final response = await client.assumeRole(request);

      expect(response.body, isNotNull);
      expect(response.body!.credentials, isNotNull);
      expect(response.body!.credentials!.accessKeyId, isNotNull);
      expect(response.body!.credentials!.accessKeyId, isNotEmpty);
      expect(response.body!.credentials!.accessKeySecret, isNotNull);
      expect(response.body!.credentials!.accessKeySecret, isNotEmpty);
      expect(response.body!.credentials!.securityToken, isNotNull);
      expect(response.body!.credentials!.securityToken, isNotEmpty);
      expect(response.body!.credentials!.expiration, isNotNull);
      expect(response.body!.credentials!.expiration, isNotEmpty);
      expect(response.body!.assumedRoleUser, isNotNull);
      expect(response.body!.assumedRoleUser!.arn, isNotNull);
      expect(response.body!.assumedRoleUser!.arn, isNotEmpty);
      expect(response.body!.assumedRoleUser!.assumedRoleId, isNotNull);
      expect(response.body!.assumedRoleUser!.assumedRoleId, isNotEmpty);
    },
        skip: (hasCredentials && hasRoleArn)
            ? null
            : 'ALIYUN_ACCESS_KEY_ID, ALIYUN_ACCESS_KEY_SECRET, or ALIYUN_STS_ROLE_ARN not set');
  });

  group('assumeRole with RuntimeOptions', () {
    test('works with custom timeout options', () async {
      final client = StsClient(
        accessKeyId: accessKeyId!,
        accessKeySecret: accessKeySecret!,
      );

      final request = AssumeRoleRequest(
        roleArn: roleArn!,
        roleSessionName: 'dart-sdk-integration-test-options',
        durationSeconds: 900,
      );

      final response = await client.assumeRoleWithOptions(
        request,
        const RuntimeOptions(connectTimeout: 30000, readTimeout: 30000),
      );

      expect(response.body, isNotNull);
      expect(response.body!.credentials, isNotNull);
      expect(response.body!.credentials!.accessKeyId, isNotNull);
      expect(response.body!.credentials!.accessKeyId, isNotEmpty);
    },
        skip: (hasCredentials && hasRoleArn)
            ? null
            : 'ALIYUN_ACCESS_KEY_ID, ALIYUN_ACCESS_KEY_SECRET, or ALIYUN_STS_ROLE_ARN not set');
  });

  group('Error handling - invalid role ARN', () {
    test('throws StsException for invalid roleArn', () async {
      final client = StsClient(
        accessKeyId: accessKeyId!,
        accessKeySecret: accessKeySecret!,
      );

      final request = AssumeRoleRequest(
        roleArn: 'invalid-arn',
        roleSessionName: 'dart-sdk-integration-test-error',
        durationSeconds: 900,
      );

      expect(
        () => client.assumeRole(request),
        throwsA(isA<StsException>()),
      );
    },
        skip: hasCredentials
            ? null
            : 'ALIYUN_ACCESS_KEY_ID and ALIYUN_ACCESS_KEY_SECRET not set');
  });
}
