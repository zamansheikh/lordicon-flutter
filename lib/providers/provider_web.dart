import 'dart:js_interop';
import 'dart:typed_data';

import 'package:web/web.dart' as web;

Future<Uint8List> loadHttp(Uri uri, {Map<String, String>? headers}) async {
  final init = web.RequestInit(method: 'GET');

  if (headers != null) {
    final headersObj = web.Headers();
    headers.forEach(headersObj.append);
    init.headers = headersObj;
  }

  final response = await web.window.fetch(uri.toString().toJS, init).toDart;

  if (!response.ok) {
    throw Exception(
      'Http error. Status code: ${response.status} for $uri',
    );
  }

  final buffer = (await response.arrayBuffer().toDart).toDart;
  final bytes = buffer.asUint8List();

  if (bytes.lengthInBytes == 0) {
    throw Exception('NetworkImage is an empty file: $uri');
  }

  return bytes;
}

Future<Uint8List> loadFile(Object file) async {
  final blob = file as web.Blob;
  final buffer = (await blob.arrayBuffer().toDart).toDart;
  return buffer.asUint8List();
}

String filePath(Object file) {
  return (file as web.File).name;
}
