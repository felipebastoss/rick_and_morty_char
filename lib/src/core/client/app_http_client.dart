import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:rick_and_morty_char/src/core/client/http_exceptions.dart';

class AppHttpClient {
  AppHttpClient(
    this._client, {
    Duration timeout = const Duration(seconds: 10),
    int maxRetries = 3,
    Duration baseDelay = const Duration(milliseconds: 500),
  }) : _timeout = timeout,
       _maxRetries = maxRetries,
       _baseDelay = baseDelay;

  final http.Client _client;
  final Duration _timeout;
  final int _maxRetries;
  final Duration _baseDelay;

  Future<dynamic> getJson(Uri uri) async {
    final body = await _getWithRetry(uri);
    return jsonDecode(body);
  }

  Future<Map<String, dynamic>> getJsonMap(Uri uri) async {
    final payload = await getJson(uri);
    if (payload is Map<String, dynamic>) {
      return payload;
    }

    throw const FormatException('Expected JSON object.');
  }

  Future<Uint8List> getBytes(Uri uri) async {
    return _getBytesWithRetry(uri);
  }

  Future<String> _getWithRetry(Uri uri) async {
    var attempt = 0;

    while (true) {
      final response = await _send(uri);

      if (response.statusCode == 429) {
        if (attempt >= _maxRetries) {
          throw HttpTooManyRequestsException(
            uri: uri,
            message: 'Too many requests.',
            statusCode: response.statusCode,
            responseBody: response.body,
            retryCount: attempt,
            retryAfter: _parseRetryAfter(response),
          );
        }

        final delay = _computeDelay(attempt, response);
        attempt += 1;
        await Future.delayed(delay);
        continue;
      }

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw HttpRequestException(
          uri: uri,
          message: 'Request failed with status ${response.statusCode}.',
          statusCode: response.statusCode,
          responseBody: response.body,
        );
      }

      return response.body;
    }
  }

  Future<Uint8List> _getBytesWithRetry(Uri uri) async {
    var attempt = 0;

    while (true) {
      final response = await _send(uri);

      if (response.statusCode == 429) {
        if (attempt >= _maxRetries) {
          throw HttpTooManyRequestsException(
            uri: uri,
            message: 'Too many requests.',
            statusCode: response.statusCode,
            responseBody: response.body,
            retryCount: attempt,
            retryAfter: _parseRetryAfter(response),
          );
        }

        final delay = _computeDelay(attempt, response);
        attempt += 1;
        await Future.delayed(delay);
        continue;
      }

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw HttpRequestException(
          uri: uri,
          message: 'Request failed with status ${response.statusCode}.',
          statusCode: response.statusCode,
          responseBody: response.body,
        );
      }

      return response.bodyBytes;
    }
  }

  Future<http.Response> _send(Uri uri) async {
    try {
      return await _client.get(uri).timeout(_timeout);
    } on TimeoutException {
      throw HttpRequestException(uri: uri, message: 'Request timed out.');
    } on http.ClientException catch (error) {
      throw HttpRequestException(uri: uri, message: error.message);
    } catch (error) {
      throw HttpRequestException(uri: uri, message: 'Request failed: $error');
    }
  }

  Duration _computeDelay(int attempt, http.Response response) {
    final multiplier = 1 << attempt;
    final baseDelay = Duration(milliseconds: _baseDelay.inMilliseconds * multiplier);
    final retryAfter = _parseRetryAfter(response);
    if (retryAfter == null) {
      return baseDelay;
    }

    return retryAfter > baseDelay ? retryAfter : baseDelay;
  }

  Duration? _parseRetryAfter(http.Response response) {
    final header = response.headers['retry-after'];
    if (header == null) {
      return null;
    }

    final seconds = int.tryParse(header);
    if (seconds == null) {
      return null;
    }

    return Duration(seconds: seconds);
  }
}
