enum SwipeGesture {
  none,
  openDrawer,
  openApp;

  const SwipeGesture();

  static SwipeGesture fromString(String value) {
    switch (value) {
      case 'None':
        return none;
      case 'Open Drawer':
        return openDrawer;
      case 'Open App':
        return openApp;
      default:
        return none;
    }
  }

  @override
  String toString() {
    switch (this) {
      case none:
        return 'None';
      case openDrawer:
        return 'Open Drawer';
      case openApp:
        return 'Open App';
      default:
        return 'None';
    }
  }
}
