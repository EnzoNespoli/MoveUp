import 'dart:typed_data';
import 'dart:html' as html;

Future<void> saveBytes(Uint8List bytes, String filename, String mimeType) async {
  final blob = html.Blob([bytes], mimeType);
  final url = html.Url.createObjectUrlFromBlob(blob);
  final a = html.AnchorElement(href: url)..download = filename..style.display='none';
  html.document.body!.append(a);
  a.click();
  a.remove();
  html.Url.revokeObjectUrl(url);
}