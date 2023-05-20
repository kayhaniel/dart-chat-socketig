import 'dart:io';
import 'dart:typed_data';

class ChatClient {
  final Socket _socket;
  String _address;
  int _port;

  ChatClient(this._socket, this._address, this._port) {
    _address = _socket.remoteAddress.address;
    _port = _socket.remotePort;
    _socket.listen(messageHandler, onError: errorHandler, onDone: finishHandler);
  }

  void write(String message) {
    _socket.write(message);
  }

  void distributeMessage(ChatClient client,String message) {
    for(ChatClient c in clients) {
      if(c != client) {
        c.write('$message\n');
      }
    }
  }

  void messageHandler(Uint8List data) {
    String message = String.fromCharCodes(data);
    distributeMessage(this, '$_address:$_port Message: $message');
  }

  void errorHandler(error) {
    print('$_address:$_port Error: $error');
    removeClient(this);
    _socket.close();
  }

  void finishHandler() {
    print('$_address:$_port Disconnected');
    removeClient(this);
    _socket.close();
  }

  void removeClient(ChatClient client) {
    clients.remove(client);
  }
}

List<ChatClient> clients = [];

void main() {
  ServerSocket server;
  ServerSocket.bind('127.0.0.1', 3000).then( (ServerSocket socket) {
    server = socket;
    server.listen((client) {
      handleConnection(client);
    });
  });
}

void handleConnection(Socket client) {
  print('connection from '
      '${client.remoteAddress.address}:${client.remotePort}');

  clients.add(ChatClient(client, '127.0.0.1' ,3000));

  client.write("Welcome to kayhan-chat ! "
    "There are ${clients.length - 1} other clients\n"
  );

}