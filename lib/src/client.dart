import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'models.dart';

/// Alibaba Cloud STS Client for Dart
class StsClient {
  final String _accessKeyId;
  final String _accessKeySecret;
  final String _securityToken;
  final String _regionId;
  final String _endpoint;
  final Map<String, String> _endpointMap;

  /// Creates a new STS client instance
  StsClient({
    required String accessKeyId,
    required String accessKeySecret,
    String? securityToken,
    String regionId = 'cn-hangzhou',
    String? endpoint,
  })  : _accessKeyId = accessKeyId,
        _accessKeySecret = accessKeySecret,
        _securityToken = securityToken ?? '',
        _regionId = regionId,
        _endpoint = endpoint ?? '',
        _endpointMap = {
          'ap-northeast-2-pop': 'sts.aliyuncs.com',
          'cn-beijing-finance-1': 'sts.aliyuncs.com',
          'cn-beijing-finance-pop': 'sts.aliyuncs.com',
          'cn-beijing-gov-1': 'sts.aliyuncs.com',
          'cn-beijing-nu16-b01': 'sts.aliyuncs.com',
          'cn-edge-1': 'sts.aliyuncs.com',
          'cn-fujian': 'sts.aliyuncs.com',
          'cn-haidian-cm12-c01': 'sts.aliyuncs.com',
          'cn-hangzhou-bj-b01': 'sts.aliyuncs.com',
          'cn-hangzhou-finance': 'sts.aliyuncs.com',
          'cn-hangzhou-internal-prod-1': 'sts.aliyuncs.com',
          'cn-hangzhou-internal-test-1': 'sts.aliyuncs.com',
          'cn-hangzhou-internal-test-2': 'sts.aliyuncs.com',
          'cn-hangzhou-internal-test-3': 'sts.aliyuncs.com',
          'cn-hangzhou-test-306': 'sts.aliyuncs.com',
          'cn-hongkong-finance-pop': 'sts.aliyuncs.com',
          'cn-huhehaote-nebula-1': 'sts.aliyuncs.com',
          'cn-north-2-gov-1': 'sts-vpc.cn-north-2-gov-1.aliyuncs.com',
          'cn-qingdao-nebula': 'sts.aliyuncs.com',
          'cn-shanghai-et15-b01': 'sts.aliyuncs.com',
          'cn-shanghai-et2-b01': 'sts.aliyuncs.com',
          'cn-shanghai-inner': 'sts.aliyuncs.com',
          'cn-shanghai-internal-test-1': 'sts.aliyuncs.com',
          'cn-shenzhen-finance-1': 'sts-vpc.cn-shenzhen-finance-1.aliyuncs.com',
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

  /// Get the endpoint URL for the STS service
  String _getEndpoint() {
    if (_endpoint.isNotEmpty) {
      return _endpoint;
    }

    if (_endpointMap.containsKey(_regionId)) {
      return _endpointMap[_regionId]!;
    }

    return 'sts.aliyuncs.com';
  }

  /// URL encode according to Alibaba Cloud API requirements
  String _percentEncode(String str) {
    return Uri.encodeComponent(str)
        .replaceAll('+', '%20')
        .replaceAll('*', '%2A')
        .replaceAll('%7E', '~');
  }

  /// Generate signature for the request
  String _generateSignature(String method, Map<String, String> parameters) {
    // Sort parameters
    final sortedParams = Map.fromEntries(
        parameters.entries.toList()..sort((a, b) => a.key.compareTo(b.key)));

    // Create canonical query string
    final queryString = sortedParams.entries
        .map((e) => '${_percentEncode(e.key)}=${_percentEncode(e.value)}')
        .join('&');

    // Create string to sign
    final stringToSign =
        '$method&${_percentEncode('/')}&${_percentEncode(queryString)}';

    // Generate signature
    final key = utf8.encode('$_accessKeySecret&');
    final bytes = utf8.encode(stringToSign);
    final hmacSha1 = Hmac(sha1, key);
    final digest = hmacSha1.convert(bytes);

    return base64Encode(digest.bytes);
  }

  /// Make API request
  Future<Map<String, dynamic>> _makeRequest(
      String action, Map<String, String> parameters) async {
    final endpoint = _getEndpoint();
    final now = DateTime.now().toUtc();
    final timestamp =
        '${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}T${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}Z';
    final nonce = DateTime.now().millisecondsSinceEpoch.toString();

    // Common parameters
    final commonParams = {
      'Format': 'JSON',
      'Version': '2015-04-01',
      'AccessKeyId': _accessKeyId,
      'SignatureMethod': 'HMAC-SHA1',
      'Timestamp': timestamp,
      'SignatureVersion': '1.0',
      'SignatureNonce': nonce,
      'Action': action,
    };

    if (_securityToken.isNotEmpty) {
      commonParams['SecurityToken'] = _securityToken;
    }

    // Merge parameters
    final allParams = {...commonParams, ...parameters};

    // Generate signature
    final signature = _generateSignature('POST', allParams);
    allParams['Signature'] = signature;

    // Make request
    final uri = Uri.https(endpoint, '/');
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'User-Agent': 'alibabacloud-dart-sdk/1.0.0',
      },
      body: allParams.entries
          .map((e) => '${_percentEncode(e.key)}=${_percentEncode(e.value)}')
          .join('&'),
    );

    if (response.statusCode != 200) {
      throw StsException('HTTP ${response.statusCode}: ${response.body}');
    }

    final responseData = json.decode(response.body) as Map<String, dynamic>;

    if (responseData.containsKey('Code')) {
      throw StsException('${responseData['Code']}: ${responseData['Message']}');
    }

    return responseData;
  }

  /// Assume a RAM role
  Future<AssumeRoleResponse> assumeRole(AssumeRoleRequest request) async {
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

    final response = await _makeRequest('AssumeRole', parameters);
    return AssumeRoleResponse.fromJson(response);
  }

  /// Assume a role with OIDC
  Future<AssumeRoleWithOIDCResponse> assumeRoleWithOIDC(
      AssumeRoleWithOIDCRequest request) async {
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

    final response = await _makeRequest('AssumeRoleWithOIDC', parameters);
    return AssumeRoleWithOIDCResponse.fromJson(response);
  }

  /// Assume a role with SAML
  Future<AssumeRoleWithSAMLResponse> assumeRoleWithSAML(
      AssumeRoleWithSAMLRequest request) async {
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

    final response = await _makeRequest('AssumeRoleWithSAML', parameters);
    return AssumeRoleWithSAMLResponse.fromJson(response);
  }

  /// Get caller identity
  Future<GetCallerIdentityResponse> getCallerIdentity() async {
    final response = await _makeRequest('GetCallerIdentity', {});
    return GetCallerIdentityResponse.fromJson(response);
  }
}

/// STS Exception class
class StsException implements Exception {
  final String message;

  StsException(this.message);

  @override
  String toString() => 'StsException: $message';
}
