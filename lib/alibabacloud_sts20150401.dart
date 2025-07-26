/// Alibaba Cloud STS SDK for Dart
/// 
/// This library provides a Dart client for Alibaba Cloud Security Token Service (STS).
/// STS allows you to request temporary, limited-privilege credentials for users or applications.
/// 
/// Example usage:
/// ```dart
/// import 'package:alibabacloud_sts20150401/alibabacloud_sts20150401.dart';
/// 
/// final client = StsClient(
///   accessKeyId: 'your-access-key-id',
///   accessKeySecret: 'your-access-key-secret',
///   regionId: 'cn-hangzhou',
/// );
/// 
/// final request = AssumeRoleRequest(
///   roleArn: 'acs:ram::123456789012****:role/adminrole',
///   roleSessionName: 'alice',
///   durationSeconds: 3600,
/// );
/// 
/// final response = await client.assumeRole(request);
/// print('AccessKeyId: ${response.credentials?.accessKeyId}');
/// ```
library alibabacloud_sts20150401;

export 'src/client.dart';
export 'src/models.dart';