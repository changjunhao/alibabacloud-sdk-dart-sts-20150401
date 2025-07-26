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

/// Response model for AssumeRole API
class AssumeRoleResponse {
  /// The assumed role user information.
  final AssumedRoleUser? assumedRoleUser;
  
  /// The STS credentials.
  final Credentials? credentials;
  
  /// The request ID.
  final String? requestId;
  
  /// The source identity.
  final String? sourceIdentity;
  
  AssumeRoleResponse({
    this.assumedRoleUser,
    this.credentials,
    this.requestId,
    this.sourceIdentity,
  });
  
  factory AssumeRoleResponse.fromJson(Map<String, dynamic> json) {
    return AssumeRoleResponse(
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

/// Response model for AssumeRoleWithOIDC API
class AssumeRoleWithOIDCResponse {
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
  
  AssumeRoleWithOIDCResponse({
    this.assumedRoleUser,
    this.credentials,
    this.oidcTokenInfo,
    this.requestId,
    this.sourceIdentity,
  });
  
  factory AssumeRoleWithOIDCResponse.fromJson(Map<String, dynamic> json) {
    return AssumeRoleWithOIDCResponse(
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

/// Response model for AssumeRoleWithSAML API
class AssumeRoleWithSAMLResponse {
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
  
  AssumeRoleWithSAMLResponse({
    this.assumedRoleUser,
    this.credentials,
    this.requestId,
    this.samlAssertionInfo,
    this.sourceIdentity,
  });
  
  factory AssumeRoleWithSAMLResponse.fromJson(Map<String, dynamic> json) {
    return AssumeRoleWithSAMLResponse(
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
}

/// Response model for GetCallerIdentity API
class GetCallerIdentityResponse {
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
  
  GetCallerIdentityResponse({
    this.accountId,
    this.arn,
    this.identityType,
    this.principalId,
    this.requestId,
    this.roleId,
    this.userId,
  });
  
  factory GetCallerIdentityResponse.fromJson(Map<String, dynamic> json) {
    return GetCallerIdentityResponse(
      accountId: json['AccountId'],
      arn: json['Arn'],
      identityType: json['IdentityType'],
      principalId: json['PrincipalId'],
      requestId: json['RequestId'],
      roleId: json['RoleId'],
      userId: json['UserId'],
    );
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
    return {
      'Arn': arn,
      'AssumedRoleId': assumedRoleId,
    };
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
    return {
      'AccessKeyId': accessKeyId,
      'AccessKeySecret': accessKeySecret,
      'Expiration': expiration,
      'SecurityToken': securityToken,
    };
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
    return {
      'ClientIds': clientIds,
      'ExpirationTime': expirationTime,
      'IssuanceTime': issuanceTime,
      'Issuer': issuer,
      'Subject': subject,
      'VerificationInfo': verificationInfo,
    };
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
    return {
      'Issuer': issuer,
      'Recipient': recipient,
      'Subject': subject,
      'SubjectType': subjectType,
    };
  }
}