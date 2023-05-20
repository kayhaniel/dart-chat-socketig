import 'dart:io';

Socket socket = socket;

void main() {
   Socket.connect("localhost", 3000).then((Socket sock) {
    socket = sock;
    socket.listen(dataHandler,
      onError: errorHandler,
      onDone: doneHandler,
      cancelOnError: false);
  });

  stdin.listen((data) => socket.write(
    '${String.fromCharCodes(data).trim()}\n'
  ));
}

void dataHandler(data) {
  print(String.fromCharCodes(data).trim());
}

void errorHandler(error, StackTrace trace) {
  print(error);
}
void doneHandler() {
  socket.destroy();
  exit(0);
}