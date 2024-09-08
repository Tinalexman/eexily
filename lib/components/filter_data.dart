class FilterData {
  final String selection;
  final DateTime? start;
  final DateTime? end;

  const FilterData({
    this.start,
    this.end,
    this.selection = "",
  });
}
