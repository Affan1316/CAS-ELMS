// ............................................................................

enum SortOption {
  dateNewestFirst("Date (Newest First)"),
  dateOldestFirst("Date (Oldest First)"),
  amountHighestFirst("Amount (Highest First)"),
  amountLowestFirst("Amount (Lowest First)");

  const SortOption(this.title);
  final String title;
}
