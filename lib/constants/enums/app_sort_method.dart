enum AppSortMethod {
  alphabetical,
  usage // naps to edge with rounded top corners
  ;

  const AppSortMethod();

  static AppSortMethod fromString(String value) {
    switch (value) {
      case 'Alphabetical':
        return alphabetical;
      case 'Usage':
        return usage;
      default:
        return alphabetical;
    }
  }

  @override
  String toString() {
    switch (this) {
      case alphabetical:
        return 'Alphabetical';
      case usage:
        return 'Usage';
      default:
        return 'Alphabetical';
    }
  }
}
