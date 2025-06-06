Future<void> delay(bool addDelay) async {
  if (addDelay) {
    await Future.delayed(Duration(seconds: 2));
  } else {
    return Future.value();
  }
}
