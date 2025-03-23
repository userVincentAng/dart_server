import 'dart:io';
import 'dart:convert';

void main() async {
  final server = await ServerSocket.bind(InternetAddress.anyIPv4, 4040);
  print('Server is listening on port 4040');

  await for (final socket in server) {
    print('New connection from ${socket.remoteAddress.address}:${socket.remotePort}');

    socket.listen(
      (data) {
        final message = String.fromCharCodes(data);
        print('Received: $message');

        try {
          // Parse the JSON message
          final orderDetails = jsonDecode(message) as Map<String, dynamic>;
          print('Order Details:');
          print('Items:');
          for (final item in orderDetails['items']) {
            print('- ${item['ProductName']} (Quantity: ${item['quantity']}, Price: ₱${item['Price']})');
          }
          print('Total Amount: ₱${orderDetails['totalAmount']}');
        } catch (e) {
          print('Error parsing JSON: $e');
        }
      },
      onDone: () => print('Client disconnected'),
      onError: (error) => print('Error: $error'),
    );
  }
}
