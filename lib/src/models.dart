/// Request model for AssumeRole API
class AssumeRoleRequest {
  /// The validity period of the STS token. Unit: seconds.
  final int? durationSeconds;

  /// The external ID of the RAM role.
  final String? externalId;

  /// The policy that specifies the permissions of the returned STS token.
  final String? policy;

  /// The ARN of the RAM role.
  final String? roleArn;

  /// The custom name of the role session.
  final String? roleSessionName;

  /// The source identity.
  final String? sourceIdentity;

  AssumeRoleRequest({
    this.durationSeconds,
    this.externalId,
    this.policy,
    this.roleArn,
    this.roleSessionName,
    this.sourceIdentity,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (durationSeconds != null) map['DurationSeconds'] = durationSeconds;
    if (externalId != null) map['ExternalId'] = externalId;
    if (policy != null) map['Policy'] = policy;
    if (roleArn != null) map['RoleArn'] = roleArn;
    if (roleSessionName != null) map['RoleSessionName'] = roleSessionName;
    if (sourceIdentity != null) map['SourceIdentity'] = sourceIdentity;
    return map;
  }
}

/// Response body model for AssumeRole API
class AssumeRoleResponseBody {
  /// The assumed role user information.
  final AssumedRoleUser? assumedRoleUser;

  /// The STS credentials.
  final Credentials? credentials;

  /// The request ID.
  final String? requestId;

  /// The source identity.
  final String? sourceIdentity;

  AssumeRoleResponseBody({
    this.assumedRoleUser,
    this.credentials,
    this.requestId,
    this.sourceIdentity,
  });

  factory AssumeRoleResponseBody.fromJson(Map<String, dynamic> json) {
    return AssumeRoleResponseBody(
      assumedRoleUser: json['AssumedRoleUser'] != null
          ? AssumedRoleUser.fromJson(json['AssumedRoleUser'])
          : null,
      credentials: json['Credentials'] != null
          ? Credentials.fromJson(json['Credentials'])
          : null,
      requestId: json['RequestId'],
      sourceIdentity: json['SourceIdentity'],
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (assumedRoleUser != null) map['AssumedRoleUser'] = assumedRoleUser!.toJson();
    if (credentials != null) map['Credentials'] = credentials!.toJson();
    if (requestId != null) map['RequestId'] = requestId;
    if (sourceIdentity != null) map['SourceIdentity'] = sourceIdentity;
    return map;
  }
}

/// Response model for AssumeRole API
class AssumeRoleResponse {
  /// The response headers.
  final Map<String, String>? headers;

  /// The HTTP status code.
  final int? statusCode;

  /// The response body.
  final AssumeRoleResponseBody? body;

  AssumeRoleResponse({
    this.headers,
    this.statusCode,
    this.body,
  });

  factory AssumeRoleResponse.fromJson(Map<String, dynamic> json) {
    return AssumeRoleResponse(
      headers: json['headers'] != null
          ? Map<String, String>.from(json['headers'])
          : null,
      statusCode: json['statusCode'],
      body: json['body'] != null
          ? AssumeRoleResponseBody.fromJson(json['body'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (headers != null) map['headers'] = headers;
    if (statusCode != null) map['statusCode'] = statusCode;
    if (body != null) map['body'] = body!.toJson();
    return map;
  }
}

/// Request model for AssumeRoleWithOIDC API
class AssumeRoleWithOIDCRequest {
  /// The validity period of the STS token. Unit: seconds.
  final int? durationSeconds;

  /// The ARN of the OIDC identity provider.
  final String? oidcProviderArn;

  /// The OIDC token.
  final String? oidcToken;

  /// The policy that specifies the permissions of the returned STS token.
  final String? policy;

  /// The ARN of the RAM role.
  final String? roleArn;

  /// The custom name of the role session.
  final String? roleSessionName;

  AssumeRoleWithOIDCRequest({
    this.durationSeconds,
    this.oidcProviderArn,
    this.oidcToken,
    this.policy,
    this.roleArn,
    this.roleSessionName,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (durationSeconds != null) map['DurationSeconds'] = durationSeconds;
    if (oidcProviderArn != null) map['OIDCProviderArn'] = oidcProviderArn;
    if (oidcToken != null) map['OIDCToken'] = oidcToken;
    if (policy != null) map['Policy'] = policy;
    if (roleArn != null) map['RoleArn'] = roleArn;
    if (roleSessionName != null) map['RoleSessionName'] = roleSessionName;
    return map;
  }
}

/// Response body model for AssumeRoleWithOIDC API
class AssumeRoleWithOIDCResponseBody {
  /// The assumed role user information.
  final AssumedRoleUser? assumedRoleUser;

  /// The STS credentials.
  final Credentials? credentials;

  /// The OIDC token information.
  final OIDCTokenInfo? oidcTokenInfo;

  /// The request ID.
  final String? requestId;

  /// The source identity.
  final String? sourceIdentity;

  AssumeRoleWithOIDCResponseBody({
    this.assumedRoleUser,
    this.credentials,
    this.oidcTokenInfo,
    this.requestId,
    this.sourceIdentity,
  });

  factory AssumeRoleWithOIDCResponseBody.fromJson(Map<String, dynamic> json) {
    return AssumeRoleWithOIDCResponseBody(
      assumedRoleUser: json['AssumedRoleUser'] != null
          ? AssumedRoleUser.fromJson(json['AssumedRoleUser'])
          : null,
      credentials: json['Credentials'] != null
          ? Credentials.fromJson(json['Credentials'])
          : null,
      oidcTokenInfo: json['OIDCTokenInfo'] != null
          ? OIDCTokenInfo.fromJson(json['OIDCTokenInfo'])
          : null,
      requestId: json['RequestId'],
      sourceIdentity: json['SourceIdentity'],
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (assumedRoleUser != null) map['AssumedRoleUser'] = assumedRoleUser!.toJson();
    if (credentials != null) map['Credentials'] = credentials!.toJson();
    if (oidcTokenInfo != null) map['OIDCTokenInfo'] = oidcTokenInfo!.toJson();
    if (requestId != null) map['RequestId'] = requestId;
    if (sourceIdentity != null) map['SourceIdentity'] = sourceIdentity;
    return map;
  }
}

/// Response model for AssumeRoleWithOIDC API
class AssumeRoleWithOIDCResponse {
  /// The response headers.
  final Map<String, String>? headers;

  /// The HTTP status code.
  final int? statusCode;

  /// The response body.
  final AssumeRoleWithOIDCResponseBody? body;

  AssumeRoleWithOIDCResponse({
    this.headers,
    this.statusCode,
    this.body,
  });

  factory AssumeRoleWithOIDCResponse.fromJson(Map<String, dynamic> json) {
    return AssumeRoleWithOIDCResponse(
      headers: json['headers'] != null
          ? Map<String, String>.from(json['headers'])
          : null,
      statusCode: json['statusCode'],
      body: json['body'] != null
          ? AssumeRoleWithOIDCResponseBody.fromJson(json['body'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (headers != null) map['headers'] = headers;
    if (statusCode != null) map['statusCode'] = statusCode;
    if (body != null) map['body'] = body!.toJson();
    return map;
  }
}

/// Request model for AssumeRoleWithSAML API
class AssumeRoleWithSAMLRequest {
  /// The validity period of the STS token. Unit: seconds.
  final int? durationSeconds;

  /// The policy that specifies the permissions of the returned STS token.
  final String? policy;

  /// The ARN of the RAM role.
  final String? roleArn;

  /// The Base64-encoded SAML assertion.
  final String? samlAssertion;

  /// The ARN of the SAML identity provider.
  final String? samlProviderArn;

  AssumeRoleWithSAMLRequest({
    this.durationSeconds,
    this.policy,
    this.roleArn,
    this.samlAssertion,
    this.samlProviderArn,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (durationSeconds != null) map['DurationSeconds'] = durationSeconds;
    if (policy != null) map['Policy'] = policy;
    if (roleArn != null) map['RoleArn'] = roleArn;
    if (samlAssertion != null) map['SAMLAssertion'] = samlAssertion;
    if (samlProviderArn != null) map['SAMLProviderArn'] = samlProviderArn;
    return map;
  }
}

/// Response body model for AssumeRoleWithSAML API
class AssumeRoleWithSAMLResponseBody {
  /// The assumed role user information.
  final AssumedRoleUser? assumedRoleUser;

  /// The STS credentials.
  final Credentials? credentials;

  /// The request ID.
  final String? requestId;

  /// The SAML assertion information.
  final SAMLAssertionInfo? samlAssertionInfo;

  /// The source identity.
  final String? sourceIdentity;

  AssumeRoleWithSAMLResponseBody({
    this.assumedRoleUser,
    this.credentials,
    this.requestId,
    this.samlAssertionInfo,
    this.sourceIdentity,
  });

  factory AssumeRoleWithSAMLResponseBody.fromJson(Map<String, dynamic> json) {
    return AssumeRoleWithSAMLResponseBody(
      assumedRoleUser: json['AssumedRoleUser'] != null
          ? AssumedRoleUser.fromJson(json['AssumedRoleUser'])
          : null,
      credentials: json['Credentials'] != null
          ? Credentials.fromJson(json['Credentials'])
          : null,
      requestId: json['RequestId'],
      samlAssertionInfo: json['SAMLAssertionInfo'] != null
          ? SAMLAssertionInfo.fromJson(json['SAMLAssertionInfo'])
          : null,
      sourceIdentity: json['SourceIdentity'],
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (assumedRoleUser != null) map['AssumedRoleUser'] = assumedRoleUser!.toJson();
    if (credentials != null) map['Credentials'] = credentials!.toJson();
    if (requestId != null) map['RequestId'] = requestId;
    if (samlAssertionInfo != null) map['SAMLAssertionInfo'] = samlAssertionInfo!.toJson();
    if (sourceIdentity != null) map['SourceIdentity'] = sourceIdentity;
    return map;
  }
}

/// Response model for AssumeRoleWithSAML API
class AssumeRoleWithSAMLResponse {
  /// The response headers.
  final Map<String, String>? headers;

  /// The HTTP status code.
  final int? statusCode;

  /// The response body.
  final AssumeRoleWithSAMLResponseBody? body;

  AssumeRoleWithSAMLResponse({
    this.headers,
    this.statusCode,
    this.body,
  });

  factory AssumeRoleWithSAMLResponse.fromJson(Map<String, dynamic> json) {
    return AssumeRoleWithSAMLResponse(
      headers: json['headers'] != null
          ? Map<String, String>.from(json['headers'])
          : null,
      statusCode: json['statusCode'],
      body: json['body'] != null
          ? AssumeRoleWithSAMLResponseBody.fromJson(json['body'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (headers != null) map['headers'] = headers;
    if (statusCode != null) map['statusCode'] = statusCode;
    if (body != null) map['body'] = body!.toJson();
    return map;
  }
}

/// Response body model for GetCallerIdentity API
class GetCallerIdentityResponseBody {
  /// The Alibaba Cloud account ID.
  final String? accountId;

  /// The ARN of the caller.
  final String? arn;

  /// The type of the caller identity.
  final String? identityType;

  /// The ID of the caller.
  final String? principalId;

  /// The request ID.
  final String? requestId;

  /// The ID of the RAM role.
  final String? roleId;

  /// The ID of the RAM user.
  final String? userId;

  GetCallerIdentityResponseBody({
    this.accountId,
    this.arn,
    this.identityType,
    this.principalId,
    this.requestId,
    this.roleId,
    this.userId,
  });

  factory GetCallerIdentityResponseBody.fromJson(Map<String, dynamic> json) {
    return GetCallerIdentityResponseBody(
      accountId: json['AccountId'],
      arn: json['Arn'],
      identityType: json['IdentityType'],
      principalId: json['PrincipalId'],
      requestId: json['RequestId'],
      roleId: json['RoleId'],
      userId: json['UserId'],
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (accountId != null) map['AccountId'] = accountId;
    if (arn != null) map['Arn'] = arn;
    if (identityType != null) map['IdentityType'] = identityType;
    if (principalId != null) map['PrincipalId'] = principalId;
    if (requestId != null) map['RequestId'] = requestId;
    if (roleId != null) map['RoleId'] = roleId;
    if (userId != null) map['UserId'] = userId;
    return map;
  }
}

/// Response model for GetCallerIdentity API
class GetCallerIdentityResponse {
  /// The response headers.
  final Map<String, String>? headers;

  /// The HTTP status code.
  final int? statusCode;

  /// The response body.
  final GetCallerIdentityResponseBody? body;

  GetCallerIdentityResponse({
    this.headers,
    this.statusCode,
    this.body,
  });

  factory GetCallerIdentityResponse.fromJson(Map<String, dynamic> json) {
    return GetCallerIdentityResponse(
      headers: json['headers'] != null
          ? Map<String, String>.from(json['headers'])
          : null,
      statusCode: json['statusCode'],
      body: json['body'] != null
          ? GetCallerIdentityResponseBody.fromJson(json['body'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (headers != null) map['headers'] = headers;
    if (statusCode != null) map['statusCode'] = statusCode;
    if (body != null) map['body'] = body!.toJson();
    return map;
  }
}

/// Assumed role user information
class AssumedRoleUser {
  /// The ARN of the assumed role user.
  final String? arn;

  /// The ID of the assumed role user.
  final String? assumedRoleId;

  AssumedRoleUser({
    this.arn,
    this.assumedRoleId,
  });

  factory AssumedRoleUser.fromJson(Map<String, dynamic> json) {
    return AssumedRoleUser(
      arn: json['Arn'],
      assumedRoleId: json['AssumedRoleId'],
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (arn != null) map['Arn'] = arn;
    if (assumedRoleId != null) map['AssumedRoleId'] = assumedRoleId;
    return map;
  }
}

/// STS credentials
class Credentials {
  /// The AccessKey ID.
  final String? accessKeyId;

  /// The AccessKey secret.
  final String? accessKeySecret;

  /// The time when the STS token expires.
  final String? expiration;

  /// The STS token.
  final String? securityToken;

  Credentials({
    this.accessKeyId,
    this.accessKeySecret,
    this.expiration,
    this.securityToken,
  });

  factory Credentials.fromJson(Map<String, dynamic> json) {
    return Credentials(
      accessKeyId: json['AccessKeyId'],
      accessKeySecret: json['AccessKeySecret'],
      expiration: json['Expiration'],
      securityToken: json['SecurityToken'],
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (accessKeyId != null) map['AccessKeyId'] = accessKeyId;
    if (accessKeySecret != null) map['AccessKeySecret'] = accessKeySecret;
    if (expiration != null) map['Expiration'] = expiration;
    if (securityToken != null) map['SecurityToken'] = securityToken;
    return map;
  }
}

/// OIDC token information
class OIDCTokenInfo {
  /// The client IDs.
  final String? clientIds;

  /// The time when the OIDC token expires.
  final String? expirationTime;

  /// The time when the OIDC token was issued.
  final String? issuanceTime;

  /// The issuer of the OIDC token.
  final String? issuer;

  /// The subject of the OIDC token.
  final String? subject;

  /// The verification information of the OIDC token.
  final String? verificationInfo;

  OIDCTokenInfo({
    this.clientIds,
    this.expirationTime,
    this.issuanceTime,
    this.issuer,
    this.subject,
    this.verificationInfo,
  });

  factory OIDCTokenInfo.fromJson(Map<String, dynamic> json) {
    return OIDCTokenInfo(
      clientIds: json['ClientIds'],
      expirationTime: json['ExpirationTime'],
      issuanceTime: json['IssuanceTime'],
      issuer: json['Issuer'],
      subject: json['Subject'],
      verificationInfo: json['VerificationInfo'],
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (clientIds != null) map['ClientIds'] = clientIds;
    if (expirationTime != null) map['ExpirationTime'] = expirationTime;
    if (issuanceTime != null) map['IssuanceTime'] = issuanceTime;
    if (issuer != null) map['Issuer'] = issuer;
    if (subject != null) map['Subject'] = subject;
    if (verificationInfo != null) map['VerificationInfo'] = verificationInfo;
    return map;
  }
}

/// SAML assertion information
class SAMLAssertionInfo {
  /// The issuer of the SAML assertion.
  final String? issuer;

  /// The recipient of the SAML assertion.
  final String? recipient;

  /// The subject of the SAML assertion.
  final String? subject;

  /// The type of the subject.
  final String? subjectType;

  SAMLAssertionInfo({
    this.issuer,
    this.recipient,
    this.subject,
    this.subjectType,
  });

  factory SAMLAssertionInfo.fromJson(Map<String, dynamic> json) {
    return SAMLAssertionInfo(
      issuer: json['Issuer'],
      recipient: json['Recipient'],
      subject: json['Subject'],
      subjectType: json['SubjectType'],
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (issuer != null) map['Issuer'] = issuer;
    if (recipient != null) map['Recipient'] = recipient;
    if (subject != null) map['Subject'] = subject;
    if (subjectType != null) map['SubjectType'] = subjectType;
    return map;
  }
}

/// Runtime options for API requests, similar to Swift SDK's TeaUtils.RuntimeOptions
class RuntimeOptions {
  /// Whether to auto-retry on failure
  final bool? autoretry;

  /// Maximum number of retry attempts
  final int? maxAttempts;

  /// Backoff policy: 'no', 'equal', 'exponential'
  final String? backoffPolicy;

  /// Backoff period in milliseconds
  final int? backoffPeriod;

  /// Read timeout in milliseconds
  final int? readTimeout;

  /// Connect timeout in milliseconds
  final int? connectTimeout;

  /// HTTP proxy URL
  final String? httpProxy;

  /// HTTPS proxy URL
  final String? httpsProxy;

  /// Hosts that should bypass proxy (comma-separated)
  final String? noProxy;

  /// SOCKS5 proxy URL
  final String? socks5Proxy;

  /// SOCKS5 network type
  final String? socks5NetWork;

  const RuntimeOptions({
    this.autoretry,
    this.maxAttempts,
    this.backoffPolicy,
    this.backoffPeriod,
    this.readTimeout,
    this.connectTimeout,
    this.httpProxy,
    this.httpsProxy,
    this.noProxy,
    this.socks5Proxy,
    this.socks5NetWork,
  });
}
