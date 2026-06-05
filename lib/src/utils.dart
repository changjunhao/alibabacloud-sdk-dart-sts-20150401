import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:uuid/uuid.dart';

/// Calculates the backoff delay in milliseconds based on the retry policy.
///
/// [policy] can be `'no'`, `'equal'`, or `'exponential'`.
/// [period] is the base backoff period in milliseconds.
/// [retryTimes] is the current retry attempt index (0-based).
///
/// Returns 0 for `'no'` or unknown policies, [period] for `'equal'`,
/// and `period * 2^retryTimes` for `'exponential'`.
int calculateBackoffDelay(String? policy, int? period, int retryTimes) {
  final effectivePolicy = policy ?? 'no';
  final effectivePeriod = period ?? 1000;

  switch (effectivePolicy) {
    case 'equal':
      return effectivePeriod;
    case 'exponential':
      return effectivePeriod * (1 << retryTimes);
    case 'no':
    default:
      return 0;
  }
}

/// Determines whether an error is retryable.
///
/// Network-related errors ([SocketException], [HttpException]) are always
/// considered retryable. HTTP responses with [statusCode] >= 500 are also
/// retryable.
bool isRetryableError(Object error, {int? statusCode}) {
  if (error is SocketException || error is HttpException) {
    return true;
  }
  if (statusCode != null && statusCode >= 500) {
    return true;
  }
  return false;
}

/// Generates a unique nonce string using timestamp + UUID v4, hashed with MD5.
///
/// Returns a 32-character lowercase hexadecimal string.
String generateNonce() {
  final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
  final uuid = const Uuid().v4();
  final content = timestamp + uuid;
  final digest = md5.convert(utf8.encode(content));
  return digest.toString();
}

/// Percent-encodes a string following Alibaba Cloud API conventions.
///
/// This applies standard URI component encoding with the following adjustments:
/// - `+` is replaced with `%20`
/// - `*` is replaced with `%2A`
/// - `%7E` (tilde) is decoded back to `~`
String percentEncode(String value) {
  return Uri.encodeComponent(value)
      .replaceAll('+', '%20')
      .replaceAll('*', '%2A')
      .replaceAll('%7E', '~');
}

/// Generates an HMAC-SHA1 signature for an Alibaba Cloud API request.
///
/// [method] is the HTTP method (e.g., `'POST'`).
/// [parameters] are the request parameters to be signed.
/// [accessKeySecret] is the secret key used for HMAC computation.
///
/// Returns a Base64-encoded signature string.
String generateSignature(
    String method, Map<String, String> parameters, String accessKeySecret) {
  // Sort parameters
  final sortedParams = Map.fromEntries(
      parameters.entries.toList()..sort((a, b) => a.key.compareTo(b.key)));

  // Create canonical query string
  final queryString = sortedParams.entries
      .map((e) => '${percentEncode(e.key)}=${percentEncode(e.value)}')
      .join('&');

  // Create string to sign
  final stringToSign =
      '$method&${percentEncode('/')}&${percentEncode(queryString)}';

  // Generate signature
  final key = utf8.encode('$accessKeySecret&');
  final bytes = utf8.encode(stringToSign);
  final hmacSha1 = Hmac(sha1, key);
  final digest = hmacSha1.convert(bytes);

  return base64Encode(digest.bytes);
}
