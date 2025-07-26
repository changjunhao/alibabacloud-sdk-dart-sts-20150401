import 'package:test/test.dart';
import 'package:alibabacloud_sts20150401/alibabacloud_sts20150401.dart';

void main() {
  group('STS Models Tests', () {
    test('AssumeRoleRequest toJson', () {
      final request = AssumeRoleRequest(
        durationSeconds: 3600,
        externalId: 'external-id',
        policy: '{"Version":"1"}',
        roleArn: 'acs:ram::123456789012****:role/test',
        roleSessionName: 'test-session',
        sourceIdentity: 'source-identity',
      );

      final json = request.toJson();

      expect(json['DurationSeconds'], equals(3600));
      expect(json['ExternalId'], equals('external-id'));
      expect(json['Policy'], equals('{"Version":"1"}'));
      expect(json['RoleArn'], equals('acs:ram::123456789012****:role/test'));
      expect(json['RoleSessionName'], equals('test-session'));
      expect(json['SourceIdentity'], equals('source-identity'));
    });

    test('AssumeRoleResponse fromJson', () {
      final json = {
        'RequestId': 'test-request-id',
        'SourceIdentity': 'test-source-identity',
        'AssumedRoleUser': {
          'Arn': 'acs:ram::123456789012****:assumed-role/test/session',
          'AssumedRoleId': 'test-assumed-role-id',
        },
        'Credentials': {
          'AccessKeyId': 'test-access-key-id',
          'AccessKeySecret': 'test-access-key-secret',
          'SecurityToken': 'test-security-token',
          'Expiration': '2023-12-31T23:59:59Z',
        },
      };

      final response = AssumeRoleResponse.fromJson(json);

      expect(response.requestId, equals('test-request-id'));
      expect(response.sourceIdentity, equals('test-source-identity'));
      expect(response.assumedRoleUser?.arn,
          equals('acs:ram::123456789012****:assumed-role/test/session'));
      expect(response.assumedRoleUser?.assumedRoleId,
          equals('test-assumed-role-id'));
      expect(response.credentials?.accessKeyId, equals('test-access-key-id'));
      expect(response.credentials?.accessKeySecret,
          equals('test-access-key-secret'));
      expect(
          response.credentials?.securityToken, equals('test-security-token'));
      expect(response.credentials?.expiration, equals('2023-12-31T23:59:59Z'));
    });

    test('AssumeRoleWithOIDCRequest toJson', () {
      final request = AssumeRoleWithOIDCRequest(
        durationSeconds: 3600,
        oidcProviderArn: 'acs:ram::123456789012****:oidc-provider/test',
        oidcToken: 'test-oidc-token',
        policy: '{"Version":"1"}',
        roleArn: 'acs:ram::123456789012****:role/test',
        roleSessionName: 'oidc-session',
      );

      final json = request.toJson();

      expect(json['DurationSeconds'], equals(3600));
      expect(json['OIDCProviderArn'],
          equals('acs:ram::123456789012****:oidc-provider/test'));
      expect(json['OIDCToken'], equals('test-oidc-token'));
      expect(json['Policy'], equals('{"Version":"1"}'));
      expect(json['RoleArn'], equals('acs:ram::123456789012****:role/test'));
      expect(json['RoleSessionName'], equals('oidc-session'));
    });

    test('AssumeRoleWithSAMLRequest toJson', () {
      final request = AssumeRoleWithSAMLRequest(
        durationSeconds: 3600,
        policy: '{"Version":"1"}',
        roleArn: 'acs:ram::123456789012****:role/test',
        samlAssertion: 'base64-encoded-saml-assertion',
        samlProviderArn: 'acs:ram::123456789012****:saml-provider/test',
      );

      final json = request.toJson();

      expect(json['DurationSeconds'], equals(3600));
      expect(json['Policy'], equals('{"Version":"1"}'));
      expect(json['RoleArn'], equals('acs:ram::123456789012****:role/test'));
      expect(json['SAMLAssertion'], equals('base64-encoded-saml-assertion'));
      expect(json['SAMLProviderArn'],
          equals('acs:ram::123456789012****:saml-provider/test'));
    });

    test('GetCallerIdentityResponse fromJson', () {
      final json = {
        'AccountId': '123456789012',
        'Arn': 'acs:ram::123456789012****:user/test',
        'IdentityType': 'RAMUser',
        'PrincipalId': 'test-principal-id',
        'RequestId': 'test-request-id',
        'RoleId': 'test-role-id',
        'UserId': 'test-user-id',
      };

      final response = GetCallerIdentityResponse.fromJson(json);

      expect(response.accountId, equals('123456789012'));
      expect(response.arn, equals('acs:ram::123456789012****:user/test'));
      expect(response.identityType, equals('RAMUser'));
      expect(response.principalId, equals('test-principal-id'));
      expect(response.requestId, equals('test-request-id'));
      expect(response.roleId, equals('test-role-id'));
      expect(response.userId, equals('test-user-id'));
    });

    test('Credentials toJson and fromJson', () {
      final credentials = Credentials(
        accessKeyId: 'test-access-key-id',
        accessKeySecret: 'test-access-key-secret',
        securityToken: 'test-security-token',
        expiration: '2023-12-31T23:59:59Z',
      );

      final json = credentials.toJson();
      final fromJson = Credentials.fromJson(json);

      expect(fromJson.accessKeyId, equals(credentials.accessKeyId));
      expect(fromJson.accessKeySecret, equals(credentials.accessKeySecret));
      expect(fromJson.securityToken, equals(credentials.securityToken));
      expect(fromJson.expiration, equals(credentials.expiration));
    });

    test('AssumedRoleUser toJson and fromJson', () {
      final assumedRoleUser = AssumedRoleUser(
        arn: 'acs:ram::123456789012****:assumed-role/test/session',
        assumedRoleId: 'test-assumed-role-id',
      );

      final json = assumedRoleUser.toJson();
      final fromJson = AssumedRoleUser.fromJson(json);

      expect(fromJson.arn, equals(assumedRoleUser.arn));
      expect(fromJson.assumedRoleId, equals(assumedRoleUser.assumedRoleId));
    });

    test('OIDCTokenInfo toJson and fromJson', () {
      final oidcTokenInfo = OIDCTokenInfo(
        clientIds: 'client1,client2',
        expirationTime: '2023-12-31T23:59:59Z',
        issuanceTime: '2023-12-31T00:00:00Z',
        issuer: 'https://example.com',
        subject: 'test-subject',
        verificationInfo: 'test-verification-info',
      );

      final json = oidcTokenInfo.toJson();
      final fromJson = OIDCTokenInfo.fromJson(json);

      expect(fromJson.clientIds, equals(oidcTokenInfo.clientIds));
      expect(fromJson.expirationTime, equals(oidcTokenInfo.expirationTime));
      expect(fromJson.issuanceTime, equals(oidcTokenInfo.issuanceTime));
      expect(fromJson.issuer, equals(oidcTokenInfo.issuer));
      expect(fromJson.subject, equals(oidcTokenInfo.subject));
      expect(fromJson.verificationInfo, equals(oidcTokenInfo.verificationInfo));
    });

    test('SAMLAssertionInfo toJson and fromJson', () {
      final samlAssertionInfo = SAMLAssertionInfo(
        issuer: 'https://example.com',
        recipient: 'https://recipient.com',
        subject: 'test-subject',
        subjectType: 'persistent',
      );

      final json = samlAssertionInfo.toJson();
      final fromJson = SAMLAssertionInfo.fromJson(json);

      expect(fromJson.issuer, equals(samlAssertionInfo.issuer));
      expect(fromJson.recipient, equals(samlAssertionInfo.recipient));
      expect(fromJson.subject, equals(samlAssertionInfo.subject));
      expect(fromJson.subjectType, equals(samlAssertionInfo.subjectType));
    });
  });

  group('STS Client Tests', () {
    test('StsClient constructor', () {
      final client = StsClient(
        accessKeyId: 'test-access-key-id',
        accessKeySecret: 'test-access-key-secret',
        regionId: 'cn-hangzhou',
      );

      expect(client, isNotNull);
    });

    test('StsException', () {
      final exception = StsException('Test error message');

      expect(exception.message, equals('Test error message'));
      expect(exception.toString(), equals('StsException: Test error message'));
    });
  });
}
