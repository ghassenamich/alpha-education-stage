import 'dart:convert';
import 'package:education/core/util/session_storage.dart';
import 'package:http/http.dart' as http;

Future<void> fetchConversation() async {
  try {
    final (storedUser, headers) = await SessionStorage.loadSession();

    // Step 1: Get all conversations
    final idResponse = await http.get(
      Uri.parse('http://staging.alphaeducation.fr/api/v1/tutor/conversations'),
      headers: headers,
    );

    print("Step 1 Status: ${idResponse.statusCode}");
    print("Step 1 Raw Response (first 300 chars):");
    print(idResponse.body.substring(0, idResponse.body.length > 300 ? 300 : idResponse.body.length));

    // ✅ Only try decoding if response looks like JSON
    if (idResponse.headers['content-type']?.contains('application/json') ?? false) {
      final decodedIdResponse = jsonDecode(idResponse.body);
      print("Decoded Step 1: $decodedIdResponse");
    } else {
      print("Step 1 response is not JSON, it's probably HTML (login page, error, or redirect).");
    }

  } catch (e) {
    print("Error: $e");
  }
}
