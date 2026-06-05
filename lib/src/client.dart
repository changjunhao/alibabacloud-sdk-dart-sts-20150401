import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'models.dart';
import 'utils.dart';

/// Alibaba Cloud STS (Security Token Service) client.
///
/// Provides methods to assume roles and get caller identity
/// through the STS API (version 2015-04-01).
///
/// Example:
/// ```dart
/// final client = StsClient(
///   accessKeyId: 'your-access-key-id',
///   accessKeySecret: 'your-access-key-secret',
/// );
/// final response = await client.getCallerIdentity();
/// print('AccountId: ${response.body?.accountId}');
/// ```
class StsClient {
  final String _accessKeyId;
  final String _accessKeySecret;
  final String _securityToken;
  final String _regionId;
  final String _endpoint;
  final Map<String, String> _endpointMap;
  final http.Client? _httpClient;

  /// Creates a new STS client instance.
  ///
  /// [accessKeyId] and [accessKeySecret] are required Alibaba Cloud credentials.
  /// [securityToken] is an optional STS token for temporary credentials.
  /// [regionId] defaults to `'cn-hangzhou'`.
  /// [endpoint] overrides the default endpoint resolution.
  /// [httpClient] is intended for testing purposes only.
  StsClient({
    required String accessKeyId,
    required String accessKeySecret,
    String? securityToken,
    String regionId = 'cn-hangzhou',
    String? endpoint,
    @visibleForTesting http.Client? httpClient,
  })  : _accessKeyId = accessKeyId,
        _accessKeySecret = accessKeySecret,
        _securityToken = securityToken ?? '',
        _regionId = regionId,
        _endpoint = endpoint ?? '',
        _httpClient = httpClient,
        _endpointMap = {
          'ap-northeast-2-pop': 'sts.aliyuncs.com',
          'ap-south-1': 'sts.aliyuncs.com',
          'ap-southeast-2': 'sts.aliyuncs.com',
          'cn-beijing-finance-pop': 'sts.aliyuncs.com',
          'cn-beijing-gov-1': 'sts.aliyuncs.com',
          'cn-beijing-nu16-b01': 'sts.aliyuncs.com',
          'cn-edge-1': 'sts.aliyuncs.com',
          'cn-fujian': 'sts.aliyuncs.com',
          'cn-haidian-cm12-c01': 'sts.aliyuncs.com',
          'cn-hangzhou-bj-b01': 'sts.aliyuncs.com',
          'cn-hangzhou-internal-prod-1': 'sts.aliyuncs.com',
          'cn-hangzhou-internal-test-1': 'sts.aliyuncs.com',
          'cn-hangzhou-internal-test-2': 'sts.aliyuncs.com',
          'cn-hangzhou-internal-test-3': 'sts.aliyuncs.com',
          'cn-hangzhou-test-306': 'sts.aliyuncs.com',
          'cn-hongkong-finance-pop': 'sts.aliyuncs.com',
          'cn-huhehaote-nebula-1': 'sts.aliyuncs.com',
          'cn-shanghai-et15-b01': 'sts.aliyuncs.com',
          'cn-shanghai-et2-b01': 'sts.aliyuncs.com',
          'cn-shanghai-inner': 'sts.aliyuncs.com',
          'cn-shanghai-internal-test-1': 'sts.aliyuncs.com',
          'cn-shenzhen-inner': 'sts.aliyuncs.com',
          'cn-shenzhen-st4-d01': 'sts.aliyuncs.com',
          'cn-shenzhen-su18-b01': 'sts.aliyuncs.com',
          'cn-wuhan': 'sts.aliyuncs.com',
          'cn-yushanfang': 'sts.aliyuncs.com',
          'cn-zhangbei': 'sts.aliyuncs.com',
          'cn-zhangbei-na61-b01': 'sts.aliyuncs.com',
          'cn-zhangjiakou-na62-a01': 'sts.aliyuncs.com',
          'cn-zhengzhou-nebula-1': 'sts.aliyuncs.com',
          'eu-west-1-oxs': 'sts.aliyuncs.com',
          'rus-west-1-pop': 'sts.aliyuncs.com',
        };

  /// Returns the resolved endpoint URL for the STS service.
  String _getEndpoint() {
    if (_endpoint.isNotEmpty) {
      return _endpoint;
    }

    if (_endpointMap.containsKey(_regionId)) {
      return _endpointMap[_regionId]!;
    }

    return 'sts.aliyuncs.com';
  }

  /// Makes an authenticated API request to the STS service.
  ///
  /// [action] is the API action name (e.g., `'AssumeRole'`).
  /// [parameters] are the action-specific request parameters.
  /// [authType] can be `'AK'` (signed with AccessKey) or `'Anonymous'`.
  /// [runtime] provides runtime options like timeout and retry configuration.
  ///
  /// Returns a map with `'headers'`, `'statusCode'`, and `'body'` keys.
  /// Throws [StsException] on API errors or HTTP failures.
  Future<Map<String, dynamic>> _makeRequest(
      String action, Map<String, String> parameters,
      {String authType = 'AK',
      RuntimeOptions runtime = const RuntimeOptions()}) async {
    final maxAttempts =
        (runtime.autoretry == true) ? (runtime.maxAttempts ?? 3) : 1;

    Object? lastError;
    for (int attempt = 0; attempt < maxAttempts; attempt++) {
      // Apply backoff delay for retries
      if (attempt > 0) {
        final delay = calculateBackoffDelay(
            runtime.backoffPolicy, runtime.backoffPeriod, attempt - 1);
        if (delay > 0) {
          await Future.delayed(Duration(milliseconds: delay));
        }
      }

      try {
        final endpoint = _getEndpoint();
        final now = DateTime.now().toUtc();
        final timestamp =
            '${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}T${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}Z';
        final nonce = generateNonce();

        // Common parameters
        final commonParams = <String, String>{
          'Format': 'JSON',
          'Version': '2015-04-01',
          'Timestamp': timestamp,
          'SignatureNonce': nonce,
          'Action': action,
        };

        if (authType == 'AK') {
          commonParams['SignatureMethod'] = 'HMAC-SHA1';
          commonParams['SignatureVersion'] = '1.0';
          commonParams['AccessKeyId'] = _accessKeyId;
          if (_securityToken.isNotEmpty) {
            commonParams['SecurityToken'] = _securityToken;
          }
        }

        // Merge parameters
        final allParams = {...commonParams, ...parameters};

        if (authType == 'AK') {
          // Generate signature only for AK auth type
          final signature =
              generateSignature('POST', allParams, _accessKeySecret);
          allParams['Signature'] = signature;
        }

        // Calculate timeout
        final connectTimeout = runtime.connectTimeout;
        final readTimeout = runtime.readTimeout;
        final timeout = Duration(
          milliseconds: (connectTimeout ?? 5000) + (readTimeout ?? 10000),
        );

        // Make request
        final uri = Uri.https(endpoint, '/');
        final client = _httpClient ?? http.Client();
        final shouldClose = _httpClient == null;
        try {
          final response = await client
              .post(
                uri,
                headers: {
                  'Content-Type': 'application/x-www-form-urlencoded',
                  'User-Agent': 'alibabacloud-dart-sdk/1.0.0',
                },
                body: allParams.entries
                    .map((e) =>
                        '${percentEncode(e.key)}=${percentEncode(e.value)}')
                    .join('&'),
              )
              .timeout(timeout);

          if (response.statusCode >= 500) {
            final error = StsException(
              'HTTP ${response.statusCode}: ${response.body}',
              statusCode: response.statusCode,
            );
            if (isRetryableError(error, statusCode: response.statusCode) &&
                attempt < maxAttempts - 1) {
              lastError = error;
              continue;
            }
            throw error;
          }

          if (response.statusCode != 200) {
            throw StsException(
              'HTTP ${response.statusCode}: ${response.body}',
              statusCode: response.statusCode,
            );
          }

          final responseData =
              json.decode(response.body) as Map<String, dynamic>;

          if (responseData.containsKey('Code')) {
            throw StsException(
              '${responseData['Message'] ?? 'Unknown error'}',
              code: responseData['Code'] as String?,
              requestId: responseData['RequestId'] as String?,
              statusCode: response.statusCode,
            );
          }

          return <String, dynamic>{
            'headers': Map<String, String>.from(response.headers),
            'statusCode': response.statusCode,
            'body': responseData,
          };
        } finally {
          if (shouldClose) {
            client.close();
          }
        }
      } on StsException {
        rethrow;
      } catch (e) {
        if (isRetryableError(e) && attempt < maxAttempts - 1) {
          lastError = e;
          continue;
        }
        rethrow;
      }
    }

    // Should not reach here, but just in case
    throw lastError ??
        StsException('Request failed after $maxAttempts attempts');
  }

  /// Assumes a RAM role and obtains temporary security credentials.
  ///
  /// [request] contains the role ARN, session name, and optional parameters.
  /// [runtime] provides runtime options like timeout and retry configuration.
  ///
  /// Returns [AssumeRoleResponse] with temporary credentials on success.
  /// Throws [StsException] on API errors.
  Future<AssumeRoleResponse> assumeRoleWithOptions(
      AssumeRoleRequest request, RuntimeOptions runtime) async {
    final parameters = <String, String>{};

    if (request.durationSeconds != null) {
      parameters['DurationSeconds'] = request.durationSeconds.toString();
    }
    if (request.externalId != null) {
      parameters['ExternalId'] = request.externalId!;
    }
    if (request.policy != null) {
      parameters['Policy'] = request.policy!;
    }
    if (request.roleArn != null) {
      parameters['RoleArn'] = request.roleArn!;
    }
    if (request.roleSessionName != null) {
      parameters['RoleSessionName'] = request.roleSessionName!;
    }
    if (request.sourceIdentity != null) {
      parameters['SourceIdentity'] = request.sourceIdentity!;
    }

    final response =
        await _makeRequest('AssumeRole', parameters, runtime: runtime);
    return AssumeRoleResponse.fromJson(response);
  }

  /// Assumes a RAM role and obtains temporary security credentials.
  ///
  /// [request] contains the role ARN, session name, and optional parameters.
  /// Returns [AssumeRoleResponse] with temporary credentials on success.
  /// Throws [StsException] on API errors.
  Future<AssumeRoleResponse> assumeRole(AssumeRoleRequest request) async {
    return assumeRoleWithOptions(request, const RuntimeOptions());
  }

  /// Assumes a role with OIDC and obtains temporary security credentials.
  ///
  /// [request] contains the OIDC provider ARN, token, role ARN, and optional parameters.
  /// [runtime] provides runtime options like timeout and retry configuration.
  ///
  /// Returns [AssumeRoleWithOIDCResponse] with temporary credentials on success.
  /// Throws [StsException] on API errors.
  Future<AssumeRoleWithOIDCResponse> assumeRoleWithOIDCWithOptions(
      AssumeRoleWithOIDCRequest request, RuntimeOptions runtime) async {
    final parameters = <String, String>{};

    if (request.durationSeconds != null) {
      parameters['DurationSeconds'] = request.durationSeconds.toString();
    }
    if (request.oidcProviderArn != null) {
      parameters['OIDCProviderArn'] = request.oidcProviderArn!;
    }
    if (request.oidcToken != null) {
      parameters['OIDCToken'] = request.oidcToken!;
    }
    if (request.policy != null) {
      parameters['Policy'] = request.policy!;
    }
    if (request.roleArn != null) {
      parameters['RoleArn'] = request.roleArn!;
    }
    if (request.roleSessionName != null) {
      parameters['RoleSessionName'] = request.roleSessionName!;
    }

    final response = await _makeRequest('AssumeRoleWithOIDC', parameters,
        authType: 'Anonymous', runtime: runtime);
    return AssumeRoleWithOIDCResponse.fromJson(response);
  }

  /// Assumes a role with OIDC and obtains temporary security credentials.
  ///
  /// [request] contains the OIDC provider ARN, token, role ARN, and optional parameters.
  /// Returns [AssumeRoleWithOIDCResponse] with temporary credentials on success.
  /// Throws [StsException] on API errors.
  Future<AssumeRoleWithOIDCResponse> assumeRoleWithOIDC(
      AssumeRoleWithOIDCRequest request) async {
    return assumeRoleWithOIDCWithOptions(request, const RuntimeOptions());
  }

  /// Assumes a role with SAML and obtains temporary security credentials.
  ///
  /// [request] contains the SAML provider ARN, assertion, role ARN, and optional parameters.
  /// [runtime] provides runtime options like timeout and retry configuration.
  ///
  /// Returns [AssumeRoleWithSAMLResponse] with temporary credentials on success.
  /// Throws [StsException] on API errors.
  Future<AssumeRoleWithSAMLResponse> assumeRoleWithSAMLWithOptions(
      AssumeRoleWithSAMLRequest request, RuntimeOptions runtime) async {
    final parameters = <String, String>{};

    if (request.durationSeconds != null) {
      parameters['DurationSeconds'] = request.durationSeconds.toString();
    }
    if (request.policy != null) {
      parameters['Policy'] = request.policy!;
    }
    if (request.roleArn != null) {
      parameters['RoleArn'] = request.roleArn!;
    }
    if (request.samlAssertion != null) {
      parameters['SAMLAssertion'] = request.samlAssertion!;
    }
    if (request.samlProviderArn != null) {
      parameters['SAMLProviderArn'] = request.samlProviderArn!;
    }

    final response = await _makeRequest('AssumeRoleWithSAML', parameters,
        authType: 'Anonymous', runtime: runtime);
    return AssumeRoleWithSAMLResponse.fromJson(response);
  }

  /// Assumes a role with SAML and obtains temporary security credentials.
  ///
  /// [request] contains the SAML provider ARN, assertion, role ARN, and optional parameters.
  /// Returns [AssumeRoleWithSAMLResponse] with temporary credentials on success.
  /// Throws [StsException] on API errors.
  Future<AssumeRoleWithSAMLResponse> assumeRoleWithSAML(
      AssumeRoleWithSAMLRequest request) async {
    return assumeRoleWithSAMLWithOptions(request, const RuntimeOptions());
  }

  /// Retrieves the identity of the caller with runtime options.
  ///
  /// [runtime] provides runtime options like timeout and retry configuration.
  ///
  /// Returns [GetCallerIdentityResponse] containing the caller's account,
  /// ARN, and identity type.
  /// Throws [StsException] on API errors.
  Future<GetCallerIdentityResponse> getCallerIdentityWithOptions(
      RuntimeOptions runtime) async {
    final response =
        await _makeRequest('GetCallerIdentity', {}, runtime: runtime);
    return GetCallerIdentityResponse.fromJson(response);
  }

  /// Retrieves the identity of the caller.
  ///
  /// Returns [GetCallerIdentityResponse] containing the caller's account,
  /// ARN, and identity type.
  /// Throws [StsException] on API errors.
  Future<GetCallerIdentityResponse> getCallerIdentity() async {
    return getCallerIdentityWithOptions(const RuntimeOptions());
  }
}

/// Exception thrown when an STS API request fails.
///
/// Contains detailed error information from the API response including
/// the error [code], [requestId], and HTTP [statusCode].
class StsException implements Exception {
  /// Human-readable error message.
  final String message;

  /// The API error code (e.g., `'InvalidParameter'`), if available.
  final String? code;

  /// The request ID from the API response, if available.
  final String? requestId;

  /// The HTTP status code, if available.
  final int? statusCode;

  /// Creates an [StsException] with the given [message] and optional details.
  StsException(this.message, {this.code, this.requestId, this.statusCode});

  @override
  String toString() => 'StsException: $message'
      '${code != null ? ' (code: $code)' : ''}'
      '${requestId != null ? ' [requestId: $requestId]' : ''}';
}
