import 'dart:io';

void main() async {
  // Bind the server to all available IP addresses on port 4040
  final server = await ServerSocket.bind(InternetAddress.anyIPv4, 4040);
  print('Server is listening on port 4040');

  // Listen for incoming connections
  await for (final socket in server) {
    print('New connection from ${socket.remoteAddress.address}:${socket.remotePort}');

    // Listen for data from the client
    socket.listen(
      (data) {
        // Convert the received data to a string
        final message = String.fromCharCodes(data);
        print('Received: $message');
      },
      onDone: () {
        print('Client disconnected');
      },
      onError: (error) {
        print('Error: $error');
      },
    );
  }
}
