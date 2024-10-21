enum DockStyle {
  floating,
  edgeSnap, // snaps to edge with sharp corners
  roundedEdgeSnap // naps to edge with rounded top corners
  ;

  const DockStyle();

  static DockStyle fromString(String value) {
    switch (value) {
      case 'Floating':
        return floating;
      case 'Edge Snap':
        return edgeSnap;
      case 'Rounded Edge Snap':
        return roundedEdgeSnap;
      default:
        return floating;
    }
  }

  @override
  String toString() {
    switch (this) {
      case floating:
        return 'Floating';
      case edgeSnap:
        return 'Edge Snap';
      case roundedEdgeSnap:
        return 'Rounded Edge Snap';
      default:
        return 'Floating';
    }
  }
}
