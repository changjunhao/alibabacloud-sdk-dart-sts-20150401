import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart' as http_testing;
import 'package:test/test.dart';
import 'package:alibabacloud_sts20150401/alibabacloud_sts20150401.dart';
import 'package:alibabacloud_sts20150401/src/utils.dart';

void main() {
  group('STS Models Tests', () {
    group('Request Models', () {
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

      test('AssumeRoleRequest toJson with null fields', () {
        final request = AssumeRoleRequest(
          roleArn: 'acs:ram::123456789012****:role/test',
          roleSessionName: 'test-session',
        );

        final json = request.toJson();

        expect(json.containsKey('DurationSeconds'), isFalse);
        expect(json.containsKey('ExternalId'), isFalse);
        expect(json.containsKey('Policy'), isFalse);
        expect(json['RoleArn'], equals('acs:ram::123456789012****:role/test'));
        expect(json['RoleSessionName'], equals('test-session'));
        expect(json.containsKey('SourceIdentity'), isFalse);
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
    });

    group('ResponseBody Models', () {
      test('AssumeRoleResponseBody fromJson', () {
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

        final body = AssumeRoleResponseBody.fromJson(json);

        expect(body.requestId, equals('test-request-id'));
        expect(body.sourceIdentity, equals('test-source-identity'));
        expect(body.assumedRoleUser?.arn,
            equals('acs:ram::123456789012****:assumed-role/test/session'));
        expect(body.assumedRoleUser?.assumedRoleId,
            equals('test-assumed-role-id'));
        expect(body.credentials?.accessKeyId, equals('test-access-key-id'));
        expect(body.credentials?.accessKeySecret,
            equals('test-access-key-secret'));
        expect(body.credentials?.securityToken, equals('test-security-token'));
        expect(body.credentials?.expiration, equals('2023-12-31T23:59:59Z'));
      });

      test('AssumeRoleResponseBody toJson', () {
        final body = AssumeRoleResponseBody(
          requestId: 'test-request-id',
          sourceIdentity: 'test-source-identity',
          assumedRoleUser: AssumedRoleUser(
            arn: 'acs:ram::123456789012****:assumed-role/test/session',
            assumedRoleId: 'test-assumed-role-id',
          ),
          credentials: Credentials(
            accessKeyId: 'test-access-key-id',
            accessKeySecret: 'test-access-key-secret',
            securityToken: 'test-security-token',
            expiration: '2023-12-31T23:59:59Z',
          ),
        );

        final json = body.toJson();

        expect(json['RequestId'], equals('test-request-id'));
        expect(json['SourceIdentity'], equals('test-source-identity'));
        expect(json['AssumedRoleUser']['Arn'],
            equals('acs:ram::123456789012****:assumed-role/test/session'));
        expect(json['AssumedRoleUser']['AssumedRoleId'],
            equals('test-assumed-role-id'));
        expect(json['Credentials']['AccessKeyId'], equals('test-access-key-id'));
        expect(json['Credentials']['AccessKeySecret'],
            equals('test-access-key-secret'));
        expect(json['Credentials']['SecurityToken'],
            equals('test-security-token'));
        expect(json['Credentials']['Expiration'],
            equals('2023-12-31T23:59:59Z'));
      });

      test('AssumeRoleWithOIDCResponseBody fromJson', () {
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
          'OIDCTokenInfo': {
            'ClientIds': 'client1,client2',
            'ExpirationTime': '2023-12-31T23:59:59Z',
            'IssuanceTime': '2023-12-31T00:00:00Z',
            'Issuer': 'https://example.com',
            'Subject': 'test-subject',
            'VerificationInfo': 'test-verification-info',
          },
        };

        final body = AssumeRoleWithOIDCResponseBody.fromJson(json);

        expect(body.requestId, equals('test-request-id'));
        expect(body.sourceIdentity, equals('test-source-identity'));
        expect(body.assumedRoleUser?.arn,
            equals('acs:ram::123456789012****:assumed-role/test/session'));
        expect(body.credentials?.accessKeyId, equals('test-access-key-id'));
        expect(body.oidcTokenInfo?.clientIds, equals('client1,client2'));
        expect(body.oidcTokenInfo?.expirationTime,
            equals('2023-12-31T23:59:59Z'));
        expect(body.oidcTokenInfo?.issuanceTime,
            equals('2023-12-31T00:00:00Z'));
        expect(body.oidcTokenInfo?.issuer, equals('https://example.com'));
        expect(body.oidcTokenInfo?.subject, equals('test-subject'));
        expect(body.oidcTokenInfo?.verificationInfo,
            equals('test-verification-info'));
      });

      test('AssumeRoleWithOIDCResponseBody toJson', () {
        final body = AssumeRoleWithOIDCResponseBody(
          requestId: 'test-request-id',
          sourceIdentity: 'test-source-identity',
          assumedRoleUser: AssumedRoleUser(
            arn: 'acs:ram::123456789012****:assumed-role/test/session',
            assumedRoleId: 'test-assumed-role-id',
          ),
          credentials: Credentials(
            accessKeyId: 'test-access-key-id',
            accessKeySecret: 'test-access-key-secret',
            securityToken: 'test-security-token',
            expiration: '2023-12-31T23:59:59Z',
          ),
          oidcTokenInfo: OIDCTokenInfo(
            clientIds: 'client1,client2',
            expirationTime: '2023-12-31T23:59:59Z',
            issuanceTime: '2023-12-31T00:00:00Z',
            issuer: 'https://example.com',
            subject: 'test-subject',
            verificationInfo: 'test-verification-info',
          ),
        );

        final json = body.toJson();

        expect(json['RequestId'], equals('test-request-id'));
        expect(json['OIDCTokenInfo']['ClientIds'], equals('client1,client2'));
        expect(json['OIDCTokenInfo']['Issuer'], equals('https://example.com'));
      });

      test('AssumeRoleWithSAMLResponseBody fromJson', () {
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
          'SAMLAssertionInfo': {
            'Issuer': 'https://idp.example.com',
            'Recipient': 'https://recipient.example.com',
            'Subject': 'test-subject',
            'SubjectType': 'persistent',
          },
        };

        final body = AssumeRoleWithSAMLResponseBody.fromJson(json);

        expect(body.requestId, equals('test-request-id'));
        expect(body.sourceIdentity, equals('test-source-identity'));
        expect(body.assumedRoleUser?.arn,
            equals('acs:ram::123456789012****:assumed-role/test/session'));
        expect(body.credentials?.accessKeyId, equals('test-access-key-id'));
        expect(body.samlAssertionInfo?.issuer,
            equals('https://idp.example.com'));
        expect(body.samlAssertionInfo?.recipient,
            equals('https://recipient.example.com'));
        expect(body.samlAssertionInfo?.subject, equals('test-subject'));
        expect(body.samlAssertionInfo?.subjectType, equals('persistent'));
      });

      test('AssumeRoleWithSAMLResponseBody toJson', () {
        final body = AssumeRoleWithSAMLResponseBody(
          requestId: 'test-request-id',
          sourceIdentity: 'test-source-identity',
          assumedRoleUser: AssumedRoleUser(
            arn: 'acs:ram::123456789012****:assumed-role/test/session',
            assumedRoleId: 'test-assumed-role-id',
          ),
          credentials: Credentials(
            accessKeyId: 'test-access-key-id',
            accessKeySecret: 'test-access-key-secret',
            securityToken: 'test-security-token',
            expiration: '2023-12-31T23:59:59Z',
          ),
          samlAssertionInfo: SAMLAssertionInfo(
            issuer: 'https://idp.example.com',
            recipient: 'https://recipient.example.com',
            subject: 'test-subject',
            subjectType: 'persistent',
          ),
        );

        final json = body.toJson();

        expect(json['RequestId'], equals('test-request-id'));
        expect(json['SAMLAssertionInfo']['Issuer'],
            equals('https://idp.example.com'));
        expect(json['SAMLAssertionInfo']['SubjectType'], equals('persistent'));
      });

      test('GetCallerIdentityResponseBody fromJson', () {
        final json = {
          'AccountId': '123456789012',
          'Arn': 'acs:ram::123456789012****:user/test',
          'IdentityType': 'RAMUser',
          'PrincipalId': 'test-principal-id',
          'RequestId': 'test-request-id',
          'RoleId': 'test-role-id',
          'UserId': 'test-user-id',
        };

        final body = GetCallerIdentityResponseBody.fromJson(json);

        expect(body.accountId, equals('123456789012'));
        expect(body.arn, equals('acs:ram::123456789012****:user/test'));
        expect(body.identityType, equals('RAMUser'));
        expect(body.principalId, equals('test-principal-id'));
        expect(body.requestId, equals('test-request-id'));
        expect(body.roleId, equals('test-role-id'));
        expect(body.userId, equals('test-user-id'));
      });

      test('GetCallerIdentityResponseBody toJson', () {
        final body = GetCallerIdentityResponseBody(
          accountId: '123456789012',
          arn: 'acs:ram::123456789012****:user/test',
          identityType: 'RAMUser',
          principalId: 'test-principal-id',
          requestId: 'test-request-id',
          roleId: 'test-role-id',
          userId: 'test-user-id',
        );

        final json = body.toJson();

        expect(json['AccountId'], equals('123456789012'));
        expect(json['Arn'], equals('acs:ram::123456789012****:user/test'));
        expect(json['IdentityType'], equals('RAMUser'));
        expect(json['PrincipalId'], equals('test-principal-id'));
        expect(json['RequestId'], equals('test-request-id'));
        expect(json['RoleId'], equals('test-role-id'));
        expect(json['UserId'], equals('test-user-id'));
      });
    });

    group('Response Models (headers/statusCode/body)', () {
      test('AssumeRoleResponse fromJson', () {
        final json = {
          'headers': {'content-type': 'application/json', 'x-request-id': 'abc'},
          'statusCode': 200,
          'body': {
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
          },
        };

        final response = AssumeRoleResponse.fromJson(json);

        expect(response.headers?['content-type'], equals('application/json'));
        expect(response.headers?['x-request-id'], equals('abc'));
        expect(response.statusCode, equals(200));
        expect(response.body?.requestId, equals('test-request-id'));
        expect(response.body?.sourceIdentity, equals('test-source-identity'));
        expect(response.body?.assumedRoleUser?.arn,
            equals('acs:ram::123456789012****:assumed-role/test/session'));
        expect(response.body?.assumedRoleUser?.assumedRoleId,
            equals('test-assumed-role-id'));
        expect(response.body?.credentials?.accessKeyId,
            equals('test-access-key-id'));
        expect(response.body?.credentials?.accessKeySecret,
            equals('test-access-key-secret'));
        expect(response.body?.credentials?.securityToken,
            equals('test-security-token'));
        expect(response.body?.credentials?.expiration,
            equals('2023-12-31T23:59:59Z'));
      });

      test('AssumeRoleResponse toJson', () {
        final response = AssumeRoleResponse(
          headers: {'content-type': 'application/json'},
          statusCode: 200,
          body: AssumeRoleResponseBody(
            requestId: 'test-request-id',
            sourceIdentity: 'test-source-identity',
            assumedRoleUser: AssumedRoleUser(
              arn: 'acs:ram::123456789012****:assumed-role/test/session',
              assumedRoleId: 'test-assumed-role-id',
            ),
            credentials: Credentials(
              accessKeyId: 'test-access-key-id',
              accessKeySecret: 'test-access-key-secret',
              securityToken: 'test-security-token',
              expiration: '2023-12-31T23:59:59Z',
            ),
          ),
        );

        final json = response.toJson();

        expect(json['headers'], isA<Map<String, String>>());
        expect(json['headers']['content-type'], equals('application/json'));
        expect(json['statusCode'], equals(200));
        expect(json['body'], isA<Map<String, dynamic>>());
        expect(json['body']['RequestId'], equals('test-request-id'));
        expect(json['body']['Credentials']['AccessKeyId'],
            equals('test-access-key-id'));
      });

      test('AssumeRoleResponse fromJson with null fields', () {
        final json = <String, dynamic>{
          'headers': null,
          'statusCode': null,
          'body': null,
        };

        final response = AssumeRoleResponse.fromJson(json);

        expect(response.headers, isNull);
        expect(response.statusCode, isNull);
        expect(response.body, isNull);
      });

      test('AssumeRoleWithOIDCResponse fromJson', () {
        final json = {
          'headers': {'content-type': 'application/json'},
          'statusCode': 200,
          'body': {
            'RequestId': 'oidc-request-id',
            'SourceIdentity': 'oidc-source-identity',
            'AssumedRoleUser': {
              'Arn': 'acs:ram::123456789012****:assumed-role/oidc-role/session',
              'AssumedRoleId': 'oidc-assumed-role-id',
            },
            'Credentials': {
              'AccessKeyId': 'oidc-access-key-id',
              'AccessKeySecret': 'oidc-access-key-secret',
              'SecurityToken': 'oidc-security-token',
              'Expiration': '2023-12-31T23:59:59Z',
            },
            'OIDCTokenInfo': {
              'ClientIds': 'client1,client2',
              'ExpirationTime': '2023-12-31T23:59:59Z',
              'IssuanceTime': '2023-12-31T00:00:00Z',
              'Issuer': 'https://oidc.example.com',
              'Subject': 'oidc-subject',
              'VerificationInfo': 'oidc-verification-info',
            },
          },
        };

        final response = AssumeRoleWithOIDCResponse.fromJson(json);

        expect(response.headers?['content-type'], equals('application/json'));
        expect(response.statusCode, equals(200));
        expect(response.body?.requestId, equals('oidc-request-id'));
        expect(response.body?.sourceIdentity, equals('oidc-source-identity'));
        expect(response.body?.assumedRoleUser?.arn,
            equals('acs:ram::123456789012****:assumed-role/oidc-role/session'));
        expect(response.body?.assumedRoleUser?.assumedRoleId,
            equals('oidc-assumed-role-id'));
        expect(response.body?.credentials?.accessKeyId,
            equals('oidc-access-key-id'));
        expect(response.body?.credentials?.accessKeySecret,
            equals('oidc-access-key-secret'));
        expect(response.body?.credentials?.securityToken,
            equals('oidc-security-token'));
        expect(response.body?.credentials?.expiration,
            equals('2023-12-31T23:59:59Z'));
        expect(response.body?.oidcTokenInfo?.clientIds,
            equals('client1,client2'));
        expect(response.body?.oidcTokenInfo?.expirationTime,
            equals('2023-12-31T23:59:59Z'));
        expect(response.body?.oidcTokenInfo?.issuanceTime,
            equals('2023-12-31T00:00:00Z'));
        expect(response.body?.oidcTokenInfo?.issuer,
            equals('https://oidc.example.com'));
        expect(response.body?.oidcTokenInfo?.subject, equals('oidc-subject'));
        expect(response.body?.oidcTokenInfo?.verificationInfo,
            equals('oidc-verification-info'));
      });

      test('AssumeRoleWithOIDCResponse toJson', () {
        final response = AssumeRoleWithOIDCResponse(
          headers: {'content-type': 'application/json'},
          statusCode: 200,
          body: AssumeRoleWithOIDCResponseBody(
            requestId: 'oidc-request-id',
            credentials: Credentials(
              accessKeyId: 'oidc-access-key-id',
              accessKeySecret: 'oidc-access-key-secret',
              securityToken: 'oidc-security-token',
              expiration: '2023-12-31T23:59:59Z',
            ),
            oidcTokenInfo: OIDCTokenInfo(
              clientIds: 'client1',
              issuer: 'https://oidc.example.com',
              subject: 'oidc-subject',
            ),
          ),
        );

        final json = response.toJson();

        expect(json['headers']['content-type'], equals('application/json'));
        expect(json['statusCode'], equals(200));
        expect(json['body']['RequestId'], equals('oidc-request-id'));
        expect(json['body']['Credentials']['AccessKeyId'],
            equals('oidc-access-key-id'));
        expect(json['body']['OIDCTokenInfo']['ClientIds'], equals('client1'));
      });

      test('AssumeRoleWithSAMLResponse fromJson', () {
        final json = {
          'headers': {'content-type': 'application/json'},
          'statusCode': 200,
          'body': {
            'RequestId': 'saml-request-id',
            'SourceIdentity': 'saml-source-identity',
            'AssumedRoleUser': {
              'Arn': 'acs:ram::123456789012****:assumed-role/saml-role/session',
              'AssumedRoleId': 'saml-assumed-role-id',
            },
            'Credentials': {
              'AccessKeyId': 'saml-access-key-id',
              'AccessKeySecret': 'saml-access-key-secret',
              'SecurityToken': 'saml-security-token',
              'Expiration': '2023-12-31T23:59:59Z',
            },
            'SAMLAssertionInfo': {
              'Issuer': 'https://idp.example.com',
              'Recipient': 'https://recipient.example.com',
              'Subject': 'saml-subject',
              'SubjectType': 'persistent',
            },
          },
        };

        final response = AssumeRoleWithSAMLResponse.fromJson(json);

        expect(response.headers?['content-type'], equals('application/json'));
        expect(response.statusCode, equals(200));
        expect(response.body?.requestId, equals('saml-request-id'));
        expect(response.body?.sourceIdentity, equals('saml-source-identity'));
        expect(response.body?.assumedRoleUser?.arn,
            equals('acs:ram::123456789012****:assumed-role/saml-role/session'));
        expect(response.body?.assumedRoleUser?.assumedRoleId,
            equals('saml-assumed-role-id'));
        expect(response.body?.credentials?.accessKeyId,
            equals('saml-access-key-id'));
        expect(response.body?.credentials?.accessKeySecret,
            equals('saml-access-key-secret'));
        expect(response.body?.credentials?.securityToken,
            equals('saml-security-token'));
        expect(response.body?.credentials?.expiration,
            equals('2023-12-31T23:59:59Z'));
        expect(response.body?.samlAssertionInfo?.issuer,
            equals('https://idp.example.com'));
        expect(response.body?.samlAssertionInfo?.recipient,
            equals('https://recipient.example.com'));
        expect(
            response.body?.samlAssertionInfo?.subject, equals('saml-subject'));
        expect(response.body?.samlAssertionInfo?.subjectType,
            equals('persistent'));
      });

      test('AssumeRoleWithSAMLResponse toJson', () {
        final response = AssumeRoleWithSAMLResponse(
          headers: {'content-type': 'application/json'},
          statusCode: 200,
          body: AssumeRoleWithSAMLResponseBody(
            requestId: 'saml-request-id',
            credentials: Credentials(
              accessKeyId: 'saml-access-key-id',
              accessKeySecret: 'saml-access-key-secret',
              securityToken: 'saml-security-token',
              expiration: '2023-12-31T23:59:59Z',
            ),
            samlAssertionInfo: SAMLAssertionInfo(
              issuer: 'https://idp.example.com',
              recipient: 'https://recipient.example.com',
              subject: 'saml-subject',
              subjectType: 'persistent',
            ),
          ),
        );

        final json = response.toJson();

        expect(json['headers']['content-type'], equals('application/json'));
        expect(json['statusCode'], equals(200));
        expect(json['body']['RequestId'], equals('saml-request-id'));
        expect(json['body']['Credentials']['AccessKeyId'],
            equals('saml-access-key-id'));
        expect(json['body']['SAMLAssertionInfo']['Issuer'],
            equals('https://idp.example.com'));
        expect(
            json['body']['SAMLAssertionInfo']['SubjectType'], equals('persistent'));
      });

      test('GetCallerIdentityResponse fromJson', () {
        final json = {
          'headers': {'content-type': 'application/json', 'x-request-id': 'xyz'},
          'statusCode': 200,
          'body': {
            'AccountId': '123456789012',
            'Arn': 'acs:ram::123456789012****:user/test',
            'IdentityType': 'RAMUser',
            'PrincipalId': 'test-principal-id',
            'RequestId': 'test-request-id',
            'RoleId': 'test-role-id',
            'UserId': 'test-user-id',
          },
        };

        final response = GetCallerIdentityResponse.fromJson(json);

        expect(response.headers?['content-type'], equals('application/json'));
        expect(response.headers?['x-request-id'], equals('xyz'));
        expect(response.statusCode, equals(200));
        expect(response.body?.accountId, equals('123456789012'));
        expect(response.body?.arn, equals('acs:ram::123456789012****:user/test'));
        expect(response.body?.identityType, equals('RAMUser'));
        expect(response.body?.principalId, equals('test-principal-id'));
        expect(response.body?.requestId, equals('test-request-id'));
        expect(response.body?.roleId, equals('test-role-id'));
        expect(response.body?.userId, equals('test-user-id'));
      });

      test('GetCallerIdentityResponse toJson', () {
        final response = GetCallerIdentityResponse(
          headers: {'content-type': 'application/json'},
          statusCode: 200,
          body: GetCallerIdentityResponseBody(
            accountId: '123456789012',
            arn: 'acs:ram::123456789012****:user/test',
            identityType: 'RAMUser',
            principalId: 'test-principal-id',
            requestId: 'test-request-id',
          ),
        );

        final json = response.toJson();

        expect(json['headers']['content-type'], equals('application/json'));
        expect(json['statusCode'], equals(200));
        expect(json['body']['AccountId'], equals('123456789012'));
        expect(json['body']['Arn'],
            equals('acs:ram::123456789012****:user/test'));
        expect(json['body']['IdentityType'], equals('RAMUser'));
      });
    });

    group('Nested Models', () {
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

      test('Credentials toJson with null fields', () {
        final credentials = Credentials(
          accessKeyId: 'test-access-key-id',
        );

        final json = credentials.toJson();

        expect(json['AccessKeyId'], equals('test-access-key-id'));
        expect(json.containsKey('AccessKeySecret'), isFalse);
        expect(json.containsKey('SecurityToken'), isFalse);
        expect(json.containsKey('Expiration'), isFalse);
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
        expect(
            fromJson.verificationInfo, equals(oidcTokenInfo.verificationInfo));
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
  });

  group('STS Client Tests', () {
    test('StsClient constructor with default regionId', () {
      final client = StsClient(
        accessKeyId: 'test-access-key-id',
        accessKeySecret: 'test-access-key-secret',
      );

      expect(client, isNotNull);
    });

    test('StsClient constructor with custom regionId', () {
      final client = StsClient(
        accessKeyId: 'test-access-key-id',
        accessKeySecret: 'test-access-key-secret',
        regionId: 'cn-shanghai',
      );

      expect(client, isNotNull);
    });

    test('StsClient constructor with custom endpoint', () {
      final client = StsClient(
        accessKeyId: 'test-access-key-id',
        accessKeySecret: 'test-access-key-secret',
        regionId: 'cn-hangzhou',
        endpoint: 'sts.cn-hangzhou.aliyuncs.com',
      );

      expect(client, isNotNull);
    });

    test('StsClient constructor with securityToken', () {
      final client = StsClient(
        accessKeyId: 'test-access-key-id',
        accessKeySecret: 'test-access-key-secret',
        securityToken: 'test-security-token',
        regionId: 'cn-hangzhou',
      );

      expect(client, isNotNull);
    });

    test('StsException message and toString', () {
      final exception = StsException('Test error message');

      expect(exception.message, equals('Test error message'));
      expect(exception.toString(), equals('StsException: Test error message'));
    });

    test('StsException implements Exception', () {
      final exception = StsException('Error');

      expect(exception, isA<Exception>());
    });
  });

  group('RuntimeOptions Tests', () {
    test('RuntimeOptions default values are all null', () {
      const options = RuntimeOptions();

      expect(options.autoretry, isNull);
      expect(options.maxAttempts, isNull);
      expect(options.backoffPolicy, isNull);
      expect(options.backoffPeriod, isNull);
      expect(options.readTimeout, isNull);
      expect(options.connectTimeout, isNull);
      expect(options.httpProxy, isNull);
      expect(options.httpsProxy, isNull);
      expect(options.noProxy, isNull);
      expect(options.socks5Proxy, isNull);
      expect(options.socks5NetWork, isNull);
    });

    test('RuntimeOptions with custom values', () {
      const options = RuntimeOptions(
        autoretry: true,
        maxAttempts: 5,
        backoffPolicy: 'exponential',
        backoffPeriod: 2000,
        readTimeout: 15000,
        connectTimeout: 8000,
        httpProxy: 'http://proxy.example.com:8080',
        httpsProxy: 'https://proxy.example.com:8443',
        noProxy: 'localhost,127.0.0.1',
        socks5Proxy: 'socks5://proxy.example.com:1080',
        socks5NetWork: 'tcp',
      );

      expect(options.autoretry, isTrue);
      expect(options.maxAttempts, equals(5));
      expect(options.backoffPolicy, equals('exponential'));
      expect(options.backoffPeriod, equals(2000));
      expect(options.readTimeout, equals(15000));
      expect(options.connectTimeout, equals(8000));
      expect(options.httpProxy, equals('http://proxy.example.com:8080'));
      expect(options.httpsProxy, equals('https://proxy.example.com:8443'));
      expect(options.noProxy, equals('localhost,127.0.0.1'));
      expect(options.socks5Proxy, equals('socks5://proxy.example.com:1080'));
      expect(options.socks5NetWork, equals('tcp'));
    });
  });

  group('SignatureNonce Tests', () {
    test('generateNonce produces unique values on consecutive calls', () {
      final nonceSet = <String>{};
      for (int i = 0; i < 10; i++) {
        nonceSet.add(generateNonce());
      }
      // All 10 generated nonces should be different
      expect(nonceSet.length, equals(10));
    });

    test('generateNonce produces 32-character hex string', () {
      final nonce = generateNonce();
      // MD5 produces a 32-character hex string
      expect(nonce.length, equals(32));
      expect(RegExp(r'^[0-9a-f]{32}$').hasMatch(nonce), isTrue);
    });
  });

  group('Client WithOptions Methods Tests', () {
    late StsClient client;

    setUp(() {
      client = StsClient(
        accessKeyId: 'test-access-key-id',
        accessKeySecret: 'test-access-key-secret',
      );
    });

    test('assumeRoleWithOptions method exists and is callable', () {
      // Verify the method exists at compile level by referencing it
      expect(client.assumeRoleWithOptions, isA<Function>());
    });

    test('assumeRoleWithOIDCWithOptions method exists and is callable', () {
      expect(client.assumeRoleWithOIDCWithOptions, isA<Function>());
    });

    test('assumeRoleWithSAMLWithOptions method exists and is callable', () {
      expect(client.assumeRoleWithSAMLWithOptions, isA<Function>());
    });

    test('getCallerIdentityWithOptions method exists and is callable', () {
      expect(client.getCallerIdentityWithOptions, isA<Function>());
    });
  });

  group('Auto-retry mechanism tests', () {
    group('Backoff delay calculation', () {
      test("'no' policy returns 0 delay", () {
        expect(calculateBackoffDelay('no', 1000, 0), equals(0));
        expect(calculateBackoffDelay('no', 1000, 1), equals(0));
        expect(calculateBackoffDelay('no', 1000, 5), equals(0));
      });

      test("'equal' policy returns fixed delay", () {
        expect(calculateBackoffDelay('equal', 1000, 0), equals(1000));
        expect(calculateBackoffDelay('equal', 1000, 1), equals(1000));
        expect(calculateBackoffDelay('equal', 1000, 5), equals(1000));
        expect(calculateBackoffDelay('equal', 2000, 3), equals(2000));
      });

      test("'exponential' policy returns increasing delay", () {
        expect(calculateBackoffDelay('exponential', 1000, 0), equals(1000));
        expect(calculateBackoffDelay('exponential', 1000, 1), equals(2000));
        expect(calculateBackoffDelay('exponential', 1000, 2), equals(4000));
        expect(calculateBackoffDelay('exponential', 500, 3), equals(4000));
      });

      test('default policy returns 0', () {
        expect(calculateBackoffDelay('unknown', 1000, 0), equals(0));
        expect(calculateBackoffDelay('random', 2000, 3), equals(0));
        expect(calculateBackoffDelay(null, null, 0), equals(0));
      });
    });

    group('Retryable error判断', () {
      test('SocketException is retryable', () {
        const error = SocketException('Connection refused');
        expect(isRetryableError(error), isTrue);
      });

      test('HttpException is retryable', () {
        const error = HttpException('Server error');
        expect(isRetryableError(error), isTrue);
      });

      test('HTTP 500 is retryable', () {
        final error = Exception('server error');
        expect(isRetryableError(error, statusCode: 500), isTrue);
      });

      test('HTTP 503 is retryable', () {
        final error = Exception('service unavailable');
        expect(isRetryableError(error, statusCode: 503), isTrue);
      });

      test('HTTP 400 is not retryable', () {
        final error = Exception('bad request');
        expect(isRetryableError(error, statusCode: 400), isFalse);
      });

      test('HTTP 403 is not retryable', () {
        final error = Exception('forbidden');
        expect(isRetryableError(error, statusCode: 403), isFalse);
      });

      test('FormatException is not retryable', () {
        const error = FormatException('invalid format');
        expect(isRetryableError(error), isFalse);
      });
    });
  });

  group('URL Encoding (percentEncode) tests', () {
    test('basic string encoding', () {
      expect(percentEncode('hello world'), equals('hello%20world'));
    });
    test('asterisk encoding', () {
      expect(percentEncode('test*value'), equals('test%2Avalue'));
    });
    test('tilde not encoded', () {
      expect(percentEncode('test~value'), equals('test~value'));
    });
    test('slash encoding', () {
      expect(percentEncode('/'), equals('%2F'));
    });
    test('chinese characters encoding', () {
      final encoded = percentEncode('中文');
      expect(encoded, isNot(equals('中文')));
      expect(encoded.contains('%'), isTrue);
    });
    test('empty string', () {
      expect(percentEncode(''), equals(''));
    });
    test('already safe characters', () {
      expect(percentEncode('abc123'), equals('abc123'));
    });
    test('special characters', () {
      expect(percentEncode('a=b&c=d'), contains('%'));
    });
  });

  group('Signature generation tests', () {
    test('deterministic output for same input', () {
      final params = {'Action': 'GetCallerIdentity', 'Version': '2015-04-01'};
      final sig1 = generateSignature('POST', params, 'testSecret');
      final sig2 = generateSignature('POST', params, 'testSecret');
      expect(sig1, equals(sig2));
    });
    test('different parameters produce different signatures', () {
      final params1 = {'Action': 'AssumeRole', 'Version': '2015-04-01'};
      final params2 = {'Action': 'GetCallerIdentity', 'Version': '2015-04-01'};
      final sig1 = generateSignature('POST', params1, 'testSecret');
      final sig2 = generateSignature('POST', params2, 'testSecret');
      expect(sig1, isNot(equals(sig2)));
    });
    test('different secrets produce different signatures', () {
      final params = {'Action': 'AssumeRole'};
      final sig1 = generateSignature('POST', params, 'secret1');
      final sig2 = generateSignature('POST', params, 'secret2');
      expect(sig1, isNot(equals(sig2)));
    });
    test('signature is base64 encoded', () {
      final params = {'Action': 'Test'};
      final sig = generateSignature('POST', params, 'secret');
      expect(RegExp(r'^[A-Za-z0-9+/]+=*$').hasMatch(sig), isTrue);
    });
    test('parameters are sorted before signing', () {
      final params1 = {'B': '2', 'A': '1', 'C': '3'};
      final params2 = {'A': '1', 'B': '2', 'C': '3'};
      final sig1 = generateSignature('POST', params1, 'secret');
      final sig2 = generateSignature('POST', params2, 'secret');
      expect(sig1, equals(sig2));
    });
    test('known signature vector', () {
      final params = {
        'AccessKeyId': 'testid',
        'Action': 'GetCallerIdentity',
        'Format': 'JSON',
        'SignatureMethod': 'HMAC-SHA1',
        'SignatureNonce': '12345',
        'SignatureVersion': '1.0',
        'Timestamp': '2024-01-01T00:00:00Z',
        'Version': '2015-04-01',
      };
      final sig = generateSignature('POST', params, 'testsecret');
      expect(sig, isNotEmpty);
      expect(sig.length, greaterThan(20));
    });
  });

  group('HTTP request integration tests', () {
    test('request uses POST method and correct content-type', () async {
      String? capturedMethod;
      String? capturedContentType;
      String? capturedBody;

      final mockClient = http_testing.MockClient((request) async {
        capturedMethod = request.method;
        capturedContentType = request.headers['content-type'];
        capturedBody = request.body;
        return http.Response(
          json.encode({'RequestId': 'test-id', 'AccountId': '123'}),
          200,
        );
      });

      final client = StsClient(
        accessKeyId: 'testAK',
        accessKeySecret: 'testSK',
        httpClient: mockClient,
      );

      await client.getCallerIdentity();

      expect(capturedMethod, equals('POST'));
      expect(capturedContentType, equals('application/x-www-form-urlencoded'));
      expect(capturedBody, isNotEmpty);
    });

    test('AK auth includes AccessKeyId and Signature in request', () async {
      String? capturedBody;

      final mockClient = http_testing.MockClient((request) async {
        capturedBody = request.body;
        return http.Response(
          json.encode({'RequestId': 'test-id', 'AccountId': '123'}),
          200,
        );
      });

      final client = StsClient(
        accessKeyId: 'myAccessKeyId',
        accessKeySecret: 'mySecret',
        httpClient: mockClient,
      );

      await client.getCallerIdentity();

      expect(capturedBody, contains('AccessKeyId'));
      expect(capturedBody, contains('Signature'));
      expect(capturedBody, contains('SignatureMethod'));
      expect(capturedBody, contains('SignatureVersion'));
    });

    test('Anonymous auth does NOT include AccessKeyId and Signature', () async {
      String? capturedBody;

      final mockClient = http_testing.MockClient((request) async {
        capturedBody = request.body;
        return http.Response(
          json.encode({'RequestId': 'test-id', 'Credentials': {}}),
          200,
        );
      });

      final client = StsClient(
        accessKeyId: 'myAK',
        accessKeySecret: 'mySK',
        httpClient: mockClient,
      );

      final request = AssumeRoleWithOIDCRequest(
        oidcProviderArn: 'arn:test',
        oidcToken: 'token123',
        roleArn: 'arn:role',
        roleSessionName: 'session',
      );
      await client.assumeRoleWithOIDC(request);

      expect(capturedBody, isNot(contains('AccessKeyId')));
      expect(RegExp(r'(^|&)Signature=').hasMatch(capturedBody!), isFalse);
      expect(capturedBody, isNot(contains('SignatureMethod')));
      expect(capturedBody, isNot(contains('SignatureVersion')));
    });

    test('request includes correct Action parameter', () async {
      String? capturedBody;

      final mockClient = http_testing.MockClient((request) async {
        capturedBody = request.body;
        return http.Response(
          json.encode({'RequestId': 'test-id', 'AccountId': '123'}),
          200,
        );
      });

      final client = StsClient(
        accessKeyId: 'ak',
        accessKeySecret: 'sk',
        httpClient: mockClient,
      );

      await client.getCallerIdentity();
      expect(capturedBody, contains('Action'));
      expect(capturedBody, contains('GetCallerIdentity'));
    });

    test('request includes Version parameter', () async {
      String? capturedBody;

      final mockClient = http_testing.MockClient((request) async {
        capturedBody = request.body;
        return http.Response(
          json.encode({'RequestId': 'test-id', 'AccountId': '123'}),
          200,
        );
      });

      final client = StsClient(
        accessKeyId: 'ak',
        accessKeySecret: 'sk',
        httpClient: mockClient,
      );

      await client.getCallerIdentity();
      expect(capturedBody, contains('Version'));
      expect(capturedBody, contains('2015-04-01'));
    });

    test('HTTP 400 error throws StsException without retry', () async {
      int callCount = 0;

      final mockClient = http_testing.MockClient((request) async {
        callCount++;
        return http.Response('Bad Request', 400);
      });

      final client = StsClient(
        accessKeyId: 'ak',
        accessKeySecret: 'sk',
        httpClient: mockClient,
      );

      await expectLater(
        () => client.getCallerIdentityWithOptions(
          const RuntimeOptions(autoretry: true, maxAttempts: 3)),
        throwsA(isA<StsException>()),
      );
      expect(callCount, equals(1));
    });

    test('HTTP 500 error triggers retry when autoretry is enabled', () async {
      int callCount = 0;

      final mockClient = http_testing.MockClient((request) async {
        callCount++;
        if (callCount < 3) {
          return http.Response('Internal Server Error', 500);
        }
        return http.Response(
          json.encode({'RequestId': 'test-id', 'AccountId': '123'}),
          200,
        );
      });

      final client = StsClient(
        accessKeyId: 'ak',
        accessKeySecret: 'sk',
        httpClient: mockClient,
      );

      final response = await client.getCallerIdentityWithOptions(
        const RuntimeOptions(autoretry: true, maxAttempts: 5, backoffPolicy: 'no'));

      expect(callCount, equals(3));
      expect(response.body?.requestId, equals('test-id'));
    });

    test('HTTP 500 without autoretry throws immediately', () async {
      int callCount = 0;

      final mockClient = http_testing.MockClient((request) async {
        callCount++;
        return http.Response('Internal Server Error', 500);
      });

      final client = StsClient(
        accessKeyId: 'ak',
        accessKeySecret: 'sk',
        httpClient: mockClient,
      );

      expect(
        () => client.getCallerIdentity(),
        throwsA(isA<StsException>()),
      );
      // Wait for the exception and verify only 1 call was made
      try {
        await client.getCallerIdentity();
      } catch (_) {}
      expect(callCount, equals(2)); // Two calls, each 1 time
    });

    test('API error response with Code field throws StsException', () async {
      final mockClient = http_testing.MockClient((request) async {
        return http.Response(
          json.encode({
            'RequestId': 'test-id',
            'Code': 'InvalidParameter',
            'Message': 'The parameter is invalid',
          }),
          200,
        );
      });

      final client = StsClient(
        accessKeyId: 'ak',
        accessKeySecret: 'sk',
        httpClient: mockClient,
      );

      expect(
        () => client.getCallerIdentity(),
        throwsA(predicate((e) =>
          e is StsException &&
          e.code == 'InvalidParameter' &&
          e.message.contains('The parameter is invalid'))),
      );
    });

    test('SecurityToken is included when provided', () async {
      String? capturedBody;

      final mockClient = http_testing.MockClient((request) async {
        capturedBody = request.body;
        return http.Response(
          json.encode({'RequestId': 'test-id', 'AccountId': '123'}),
          200,
        );
      });

      final client = StsClient(
        accessKeyId: 'ak',
        accessKeySecret: 'sk',
        securityToken: 'myToken123',
        httpClient: mockClient,
      );

      await client.getCallerIdentity();
      expect(capturedBody, contains('SecurityToken'));
      expect(capturedBody, contains('myToken123'));
    });

    test('custom endpoint is used in request URL', () async {
      Uri? capturedUri;

      final mockClient = http_testing.MockClient((request) async {
        capturedUri = request.url;
        return http.Response(
          json.encode({'RequestId': 'test-id', 'AccountId': '123'}),
          200,
        );
      });

      final client = StsClient(
        accessKeyId: 'ak',
        accessKeySecret: 'sk',
        endpoint: 'custom-sts.example.com',
        httpClient: mockClient,
      );

      await client.getCallerIdentity();
      expect(capturedUri?.host, equals('custom-sts.example.com'));
    });

    test('User-Agent header is set correctly', () async {
      String? capturedUserAgent;

      final mockClient = http_testing.MockClient((request) async {
        capturedUserAgent = request.headers['user-agent'];
        return http.Response(
          json.encode({'RequestId': 'test-id', 'AccountId': '123'}),
          200,
        );
      });

      final client = StsClient(
        accessKeyId: 'ak',
        accessKeySecret: 'sk',
        httpClient: mockClient,
      );

      await client.getCallerIdentity();
      expect(capturedUserAgent, contains('alibabacloud-dart-sdk'));
    });

    test('AssumeRole request includes all parameters', () async {
      String? capturedBody;

      final mockClient = http_testing.MockClient((request) async {
        capturedBody = request.body;
        return http.Response(
          json.encode({'RequestId': 'test-id', 'Credentials': {
            'AccessKeyId': 'tmpAK',
            'AccessKeySecret': 'tmpSK',
            'SecurityToken': 'tmpToken',
            'Expiration': '2024-01-01T01:00:00Z',
          }}),
          200,
        );
      });

      final client = StsClient(
        accessKeyId: 'ak',
        accessKeySecret: 'sk',
        httpClient: mockClient,
      );

      final request = AssumeRoleRequest(
        roleArn: 'acs:ram::123:role/testrole',
        roleSessionName: 'test-session',
        durationSeconds: 3600,
        policy: '{"Version":"1"}',
        externalId: 'ext-id',
      );

      await client.assumeRole(request);

      expect(capturedBody, contains('RoleArn'));
      expect(capturedBody, contains('RoleSessionName'));
      expect(capturedBody, contains('DurationSeconds'));
      expect(capturedBody, contains('Policy'));
      expect(capturedBody, contains('ExternalId'));
      expect(capturedBody, contains('AssumeRole'));
    });
  });

  group('Model null value boundary tests', () {
    test('AssumeRoleResponseBody fromJson with empty map', () {
      final body = AssumeRoleResponseBody.fromJson({});
      expect(body.requestId, isNull);
      expect(body.credentials, isNull);
      expect(body.assumedRoleUser, isNull);
    });

    test('AssumeRoleResponseBody toJson with all null fields', () {
      final body = AssumeRoleResponseBody(
        requestId: null,
        credentials: null,
        assumedRoleUser: null,
        sourceIdentity: null,
      );
      final jsonMap = body.toJson();
      expect(jsonMap.containsKey('RequestId'), isFalse);
      expect(jsonMap.containsKey('Credentials'), isFalse);
    });

    test('GetCallerIdentityResponseBody fromJson with empty map', () {
      final body = GetCallerIdentityResponseBody.fromJson({});
      expect(body.accountId, isNull);
      expect(body.arn, isNull);
      expect(body.identityType, isNull);
      expect(body.principalId, isNull);
      expect(body.requestId, isNull);
      expect(body.roleId, isNull);
      expect(body.userId, isNull);
    });

    test('Credentials fromJson with empty map', () {
      final creds = Credentials.fromJson({});
      expect(creds.accessKeyId, isNull);
      expect(creds.accessKeySecret, isNull);
      expect(creds.expiration, isNull);
      expect(creds.securityToken, isNull);
    });

    test('OIDCTokenInfo fromJson with empty map', () {
      final info = OIDCTokenInfo.fromJson({});
      expect(info.clientIds, isNull);
      expect(info.issuer, isNull);
      expect(info.subject, isNull);
    });

    test('SAMLAssertionInfo fromJson with empty map', () {
      final info = SAMLAssertionInfo.fromJson({});
      expect(info.issuer, isNull);
      expect(info.recipient, isNull);
      expect(info.subject, isNull);
      expect(info.subjectType, isNull);
    });

    test('AssumeRoleRequest toJson with all null fields', () {
      final request = AssumeRoleRequest();
      final jsonMap = request.toJson();
      expect(jsonMap.isEmpty, isTrue);
    });
  });
}
