import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:rick_and_morty_char/src/core/client/app_http_client.dart';
import 'package:rick_and_morty_char/src/core/client/http_exceptions.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late MockHttpClient client;
  late AppHttpClient appClient;
  final uri = Uri.parse('https://example.com/resource');

  setUp(() {
    client = MockHttpClient();
    appClient = AppHttpClient(
      client,
      timeout: const Duration(milliseconds: 1),
      maxRetries: 1,
      baseDelay: const Duration(milliseconds: 1),
    );
  });

  test('getJsonMap returns parsed map', () async {
    when(() => client.get(uri)).thenAnswer((_) async => http.Response('{"ok": true}', 200));

    final result = await appClient.getJsonMap(uri);

    expect(result['ok'], true);
  });

  test('getJsonMap throws on non-map json', () async {
    when(() => client.get(uri)).thenAnswer((_) async => http.Response('[1,2,3]', 200));

    expect(() => appClient.getJsonMap(uri), throwsA(isA<FormatException>()));
  });

  test('getBytes returns response bytes', () async {
    final bytes = Uint8List.fromList([1, 2, 3]);
    when(() => client.get(uri)).thenAnswer((_) async => http.Response.bytes(bytes, 200));

    final result = await appClient.getBytes(uri);

    expect(result, bytes);
  });

  test('getBytes throws HttpRequestException on non-2xx', () async {
    when(() => client.get(uri)).thenAnswer((_) async => http.Response('bad', 404));

    await expectLater(() => appClient.getBytes(uri), throwsA(isA<HttpRequestException>()));
  });

  test('throws HttpRequestException on non-2xx', () async {
    when(() => client.get(uri)).thenAnswer((_) async => http.Response('bad', 500));

    await expectLater(() => appClient.getJson(uri), throwsA(isA<HttpRequestException>()));
  });

  test('retries on 429 then succeeds', () async {
    final responses = <http.Response>[http.Response('rate', 429), http.Response('{"ok": true}', 200)];
    when(() => client.get(uri)).thenAnswer((_) async => responses.removeAt(0));

    final result = await appClient.getJsonMap(uri);

    expect(result['ok'], true);
    verify(() => client.get(uri)).called(2);
  });

  test('retries on 429 with retry-after header', () async {
    final responses = <http.Response>[
      http.Response('rate', 429, headers: {'retry-after': '2'}),
      http.Response.bytes(Uint8List.fromList([9]), 200),
    ];
    when(() => client.get(uri)).thenAnswer((_) async => responses.removeAt(0));

    final result = await appClient.getBytes(uri);

    expect(result, Uint8List.fromList([9]));
    verify(() => client.get(uri)).called(2);
  });

  test('throws HttpTooManyRequestsException after retries', () async {
    when(() => client.get(uri)).thenAnswer((_) async => http.Response('rate', 429));

    await expectLater(() => appClient.getJsonMap(uri), throwsA(isA<HttpTooManyRequestsException>()));
    verify(() => client.get(uri)).called(2);
  });

  test('throws HttpTooManyRequestsException with invalid retry-after', () async {
    appClient = AppHttpClient(
      client,
      timeout: const Duration(milliseconds: 1),
      maxRetries: 0,
      baseDelay: const Duration(milliseconds: 1),
    );

    when(() => client.get(uri)).thenAnswer((_) async => http.Response('rate', 429, headers: {'retry-after': 'nope'}));

    await expectLater(() => appClient.getBytes(uri), throwsA(isA<HttpTooManyRequestsException>()));
  });

  test('throws HttpRequestException on timeout', () async {
    when(() => client.get(uri)).thenThrow(TimeoutException('timeout'));

    await expectLater(() => appClient.getJson(uri), throwsA(isA<HttpRequestException>()));
  });

  test('throws HttpRequestException on client exception', () async {
    when(() => client.get(uri)).thenThrow(http.ClientException('client error'));

    await expectLater(() => appClient.getJson(uri), throwsA(isA<HttpRequestException>()));
  });

  test('throws HttpRequestException on unknown error', () async {
    when(() => client.get(uri)).thenThrow(StateError('boom'));

    await expectLater(() => appClient.getJson(uri), throwsA(isA<HttpRequestException>()));
  });
}
