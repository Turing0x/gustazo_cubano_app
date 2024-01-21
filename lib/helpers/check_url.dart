bool checkUrl( String value ) {

  final Uri uri = Uri.parse(value);
  
  if (!uri.hasAbsolutePath) {
    return false;
  }

  return true;

}