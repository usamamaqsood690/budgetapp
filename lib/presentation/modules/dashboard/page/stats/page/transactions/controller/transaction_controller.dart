import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wealthnxai/data/models/stats/transactions/get_transaction_response_model/get_transaction_response_model.dart';
import 'package:wealthnxai/domain/usecases/stats/transaction/get_all_transaction_usecase.dart';

/// Controller for managing transactions list, filtering, and sorting
class TransactionsController extends GetxController {
  TransactionsController({required this.getAllTransactionUseCase});

  // ============================================================================
  // DEPENDENCIES
  // ============================================================================
  final GetAllTransactionUseCase getAllTransactionUseCase;

  // ============================================================================
  // STATE VARIABLES - Loading & Data
  // ============================================================================
  /// Loading state for transactions
  var isLoadingTran = false.obs;
  
  /// All transactions fetched from API
  var transactions = Rxn<TransactionResponseModel>();
  
  /// Transactions after applying filters and search
  var filteredTransactions = <TransBody>[].obs;
  
  /// Error message if transaction fetch fails
  var errorMessage = ''.obs;
  
  /// Flag to prevent duplicate fetches
  var hasFetched = false.obs;
  var hasFetchedTrans = false.obs;
  
  /// Search text controller
  final TextEditingController searchController = TextEditingController();
  
  /// Flag to determine if amount-based sorting is active (for UI display)
  var isAmountSortActive = false.obs;

  // ============================================================================
  // FILTER STATE VARIABLES
  // ============================================================================
  /// Selected date filter (e.g., "Last 7 days", "This month")
  var selectedDate = ''.obs;
  
  /// Custom date range filter
  var selectedDateRange = Rxn<DateTimeRange>();
  
  /// Amount range filter (min-max)
  var selectedAmountRange = Rxn<RangeValues>();
  
  /// Selected categories for filtering
  var selectedCategories = <CustomModelForIconWithHeading>[].obs;
  
  /// Selected sort option
  var selectedSortBy = 'All'.obs;
  
  /// Selected transaction types for filtering
  var selectedTransactionType = <CustomModelForIconWithHeading>[].obs;
  
  /// Selected financial accounts for filtering
  var selectedAccounts = <CustomModelForIconWithHeading>[].obs;
  
  /// Legacy filter variable (may not be used)
  var selectedFilter = ''.obs;
  
  /// Maximum amount in transactions (for amount range slider)
  var highAmountRange = 0.00;
  
  /// Minimum amount in transactions (for amount range slider)
  var lowAmountRange = 0.00;

  // ============================================================================
  // FILTER OPTIONS - Available Choices
  // ============================================================================
  /// Available date filter options
  final List<String> dates = [
    'All time',
    'Last 7 days',
    'Last 30 days',
    'Last 90 days',
    'This month',
    'Last month',
  ];

  /// Available categories extracted from transactions
  var categories = <CustomModelForIconWithHeading>[].obs;
  
  /// Available transaction types extracted from transactions
  var transactionTypes = <CustomModelForIconWithHeading>[].obs;
  
  /// Available financial accounts extracted from transactions
  var financialAccounts = <CustomModelForIconWithHeading>[].obs;

  /// Available sort options
  final List<String> sortOptions = [
    'Date (new to old)',
    'Date (old to new)',
    'Amount (high to low)',
    'Amount (low to high)',
  ];

  // ============================================================================
  // LIFECYCLE METHODS
  // ============================================================================
  @override
  void onInit() {
    super.onInit();
    searchController.addListener(filterTransactions);
    fetchTransations();
  }

  @override
  void onClose() {
    searchController.removeListener(filterTransactions);
    searchController.clear();
    super.onClose();
  }

  // ============================================================================
  // DATA FETCHING METHODS
  // ============================================================================
  /// Fetches transactions from API
  /// 
  /// [force] - If true, forces a fresh fetch even if data already exists
  Future<void> fetchTransations({bool force = false}) async {
    // Prevent duplicate fetches
    if (hasFetchedTrans.value && !force) return;
    if (hasFetched.value && !force) return;
    if (isLoadingTran.value) return;

    isLoadingTran.value = true;
    errorMessage.value = '';

    try {
      final result = await getAllTransactionUseCase();

      result.fold(
        (failure) {
          errorMessage.value = failure.message;
        },
        (model) {
          transactions.value = model;
          filteredTransactions
            ..clear()
            ..addAll(model.body ?? []);

          extractUniqueValues();
          extractAmountRange();
          transactions.refresh();
          filteredTransactions.refresh();
          hasFetched.value = true;
          hasFetchedTrans.value = true;
        },
      );
    } catch (e) {
      errorMessage.value = 'Error: $e';
    } finally {
      isLoadingTran.value = false;
    }
  }

  // ============================================================================
  // DATA PROCESSING METHODS
  // ============================================================================
  /// Extracts min and max amount range from transactions
  /// Returns default range [0, 10000] if no transactions exist
  RangeValues extractAmountRange() {
    if (transactions.value?.body == null || transactions.value!.body!.isEmpty) {
      return const RangeValues(0, 10000);
    }

    double minAmount = 0;
    double maxAmount = 0;

    for (var txn in transactions.value!.body!) {
      if (txn.amount != null) {
        double amount = txn.amount!.abs();
        if (amount > maxAmount) {
          maxAmount = amount;
        }
      }
    }
    highAmountRange = maxAmount.toDouble();
    lowAmountRange = minAmount.toDouble();

    return RangeValues(minAmount, maxAmount);
  }

  /// Extracts unique categories, transaction types, and accounts from transactions
  /// Used to populate filter dropdown options
  void extractUniqueValues() {
    if (transactions.value?.body == null) return;

    final Map<String, CustomModelForIconWithHeading> uniqueCategories = {};
    final Map<String, CustomModelForIconWithHeading> uniqueTransactionTypes = {};
    final Map<String, CustomModelForIconWithHeading> uniqueAccounts = {};

    for (var txn in transactions.value!.body!) {
      // Extract unique categories
      if (txn.category != null && txn.category!.isNotEmpty) {
        if (!uniqueCategories.containsKey(txn.category)) {
          uniqueCategories[txn.category!] = CustomModelForIconWithHeading(
            name: txn.category!,
            logoName: txn.personal_finance_category_icon_url,
          );
        }
      }

      // Extract unique transaction types
      if (txn.transaction_type != null && txn.transaction_type!.isNotEmpty) {
        if (!uniqueTransactionTypes.containsKey(txn.transaction_type)) {
          uniqueTransactionTypes[txn.transaction_type!] = CustomModelForIconWithHeading(
            name: txn.transaction_type!,
            logoName: txn.logoUrl,
          );
        }
      }

      // Extract unique financial accounts
      if (txn.institutionName != null && txn.institutionName!.isNotEmpty) {
        if (!uniqueAccounts.containsKey(txn.institutionName)) {
          uniqueAccounts[txn.institutionName!] = CustomModelForIconWithHeading(
            name: txn.institutionName!,
            logoName: txn.institutionLogo,
          );
        }
      }
    }

    // Sort and assign extracted values
    categories.value = uniqueCategories.values.toList()
      ..sort((a, b) => a.name.compareTo(b.name));
    transactionTypes.value = uniqueTransactionTypes.values.toList()
      ..sort((a, b) => a.name.compareTo(b.name));
    financialAccounts.value = uniqueAccounts.values.toList()
      ..sort((a, b) => a.name.compareTo(b.name));
  }

  // ============================================================================
  // FILTER SETTER METHODS - Update Filter Values
  // ============================================================================
  /// Sets the date range filter
  void setDateRange(DateTimeRange? range) {
    selectedDateRange.value = range;
  }

  /// Sets the amount range filter
  void setAmountRange(RangeValues? range) {
    selectedAmountRange.value = range;
  }

  /// Updates selected categories filter
  void toggleCategory(List<CustomModelForIconWithHeading> category) {
    selectedCategories.clear();
    selectedCategories.addAll(category);
  }

  /// Sets the sort option
  void setSortBy(String sortBy) {
    selectedSortBy.value = sortBy;
  }

  /// Updates selected transaction types filter
  void setTransactionType(List<CustomModelForIconWithHeading> types) {
    selectedTransactionType.clear();
    selectedTransactionType.addAll(types);
  }

  /// Updates selected accounts filter
  void setAccounts(List<CustomModelForIconWithHeading> accounts) {
    selectedAccounts.clear();
    selectedAccounts.addAll(accounts);
  }

  /// Resets all filters to default values
  void resetFilters() {
    selectedDateRange.value = null;
    selectedDate.value = '';
    selectedAmountRange.value = null;
    selectedCategories.clear();
    selectedSortBy.value = 'All';
    selectedTransactionType.clear();
    selectedAccounts.clear();
    highAmountRange = 0.00;
    lowAmountRange = 0.00;
    applyFilters();
  }

  /// Returns current filter state as a map
  Map<String, dynamic> getFilterData() {
    return {
      'dateRange': selectedDateRange.value,
      'amountRange': selectedAmountRange.value,
      'categories': selectedCategories.toList(),
      'sortBy': selectedSortBy.value,
      'transactionType': selectedTransactionType.toList(),
      'accounts': selectedAccounts.toList(),
    };
  }

  // ============================================================================
  // FILTER DISPLAY METHODS - Get Display Strings for UI
  // ============================================================================
  /// Returns formatted date range display string
  String getDateRangeDisplay() {
    if (selectedDate.value.isEmpty || selectedDate.value == 'All time') {
      return 'All Time';
    }
    return selectedDate.value;
  }

  /// Returns formatted amount range display string
  String getAmountRangeDisplay() {
    if (selectedAmountRange.value == null) {
      return 'Not Selected';
    }
    return '\$${selectedAmountRange.value!.start.toInt()} - \$${selectedAmountRange.value!.end.toInt()}';
  }

  /// Returns formatted categories display string
  String getCategoriesDisplay() {
    if (selectedCategories.isEmpty) {
      return 'All';
    }
    return selectedCategories.map((e) => e.name).join(', ');
  }

  /// Returns current sort option display string
  String getSortByDisplay() {
    return selectedSortBy.value;
  }

  /// Returns formatted transaction type display string
  String getTransactionTypeDisplay() {
    if (selectedTransactionType.isEmpty) {
      return 'Not Selected';
    }
    return selectedTransactionType.map((e) => e.name).join(', ');
  }

  /// Returns formatted accounts display string
  String getAccountsDisplay() {
    if (selectedAccounts.isEmpty) {
      return 'Not Selected';
    }
    if (selectedAccounts.length == financialAccounts.length) {
      return 'All Accounts';
    }
    return selectedAccounts.map((e) => e.name).join(', ');
  }

  // ============================================================================
  // FILTER APPLICATION LOGIC
  // ============================================================================
  /// Applies all active filters to transactions and updates filteredTransactions
  /// Filters are applied in order: Date -> Amount -> Categories -> Types -> Accounts -> Search -> Sort
  void applyFilters() {
    List<TransBody> filtered = List.from(transactions.value?.body ?? []);

    // 1. Apply Date Range Filter
    if (selectedDateRange.value != null) {
      filtered = filtered.where((txn) {
        if (txn.date == null) return false;
        final txnDate = txn.date!.toLocal();
        final start = selectedDateRange.value!.start;
        final end = selectedDateRange.value!.end.add(const Duration(days: 1));
        return txnDate.isAfter(start.subtract(const Duration(days: 1))) &&
            txnDate.isBefore(end);
      }).toList();
    }

    // 2. Apply Date Preset Filter (Last 7 days, This month, etc.)
    if (selectedDate.value.isNotEmpty && selectedDate.value != 'All time') {
      final now = DateTime.now();
      DateTime startDate;

      switch (selectedDate.value) {
        case 'Last 7 days':
          startDate = now.subtract(const Duration(days: 7));
          break;
        case 'Last 30 days':
          startDate = now.subtract(const Duration(days: 30));
          break;
        case 'Last 90 days':
          startDate = now.subtract(const Duration(days: 90));
          break;
        case 'This month':
          startDate = DateTime(now.year, now.month, 1);
          break;
        case 'Last month':
          startDate = DateTime(now.year, now.month - 1, 1);
          final lastDayOfLastMonth = DateTime(now.year, now.month, 0);
          filtered = filtered.where((txn) {
            if (txn.date == null) return false;
            final txnDate = txn.date!.toLocal();
            return txnDate.isAfter(startDate.subtract(const Duration(days: 0))) &&
                txnDate.isBefore(lastDayOfLastMonth.add(const Duration(days: 0)));
          }).toList();
          break;
        default:
          startDate = DateTime(2000);
      }

      if (selectedDate.value != 'Last month') {
        filtered = filtered.where((txn) {
          if (txn.date == null) return false;
          return txn.date!.toLocal().isAfter(
            startDate.subtract(const Duration(days: 0)),
          );
        }).toList();
      }
    }

    // 3. Apply Amount Range Filter
    if (selectedAmountRange.value != null) {
      filtered = filtered.where((txn) {
        if (txn.amount == null) return false;
        final amount = txn.amount!.abs();
        return amount >= selectedAmountRange.value!.start &&
            amount <= selectedAmountRange.value!.end;
      }).toList();
    }

    // 4. Apply Categories Filter
    if (selectedCategories.isNotEmpty) {
      final categoryNames = selectedCategories.map((e) => e.name.toLowerCase()).toSet();
      filtered = filtered.where((txn) {
        return txn.category != null &&
            categoryNames.contains(txn.category!.toLowerCase());
      }).toList();
    }

    // 5. Apply Transaction Type Filter
    if (selectedTransactionType.isNotEmpty) {
      final typeNames = selectedTransactionType.map((e) => e.name.toLowerCase()).toSet();
      filtered = filtered.where((txn) {
        return txn.transaction_type != null &&
            typeNames.contains(txn.transaction_type!.toLowerCase());
      }).toList();
    }

    // 6. Apply Accounts Filter
    if (selectedAccounts.isNotEmpty) {
      final accountNames = selectedAccounts.map((e) => e.name.toLowerCase()).toSet();
      filtered = filtered.where((txn) {
        return txn.institutionName != null &&
            accountNames.contains(txn.institutionName!.toLowerCase());
      }).toList();
    }

    // 7. Apply Search Filter
    final searchTerm = searchController.text.toLowerCase();
    if (searchTerm.isNotEmpty) {
      filtered = filtered.where((txn) {
        return txn.title?.toLowerCase().contains(searchTerm) ?? false;
      }).toList();
    }

    // 8. Apply Sorting
    if (selectedSortBy.value != 'All') {
      switch (selectedSortBy.value) {
        case 'Amount (high to low)':
          isAmountSortActive.value = true;
          filtered.sort((a, b) {
            if (a.amount == null || b.amount == null) return 0;
            return b.amount!.abs().compareTo(a.amount!.abs());
          });
          break;

        case 'Amount (low to high)':
          isAmountSortActive.value = true;
          filtered.sort((a, b) {
            if (a.amount == null || b.amount == null) return 0;
            return a.amount!.abs().compareTo(b.amount!.abs());
          });
          break;

        case 'Date (new to old)':
          isAmountSortActive.value = false;
          filtered.sort((a, b) {
            if (a.date == null || b.date == null) return 0;
            return b.date!.compareTo(a.date!);
          });
          break;

        case 'Date (old to new)':
          isAmountSortActive.value = false;
          filtered.sort((a, b) {
            if (a.date == null || b.date == null) return 0;
            return a.date!.compareTo(b.date!);
          });
          break;
      }
    } else {
      isAmountSortActive.value = false;
    }

    filteredTransactions.assignAll(filtered);
    filteredTransactions.refresh();
  }

  // ============================================================================
  // SEARCH METHODS
  // ============================================================================
  /// Filters transactions based on search text input
  /// Called automatically when search text changes
  void filterTransactions() {
    final searchTerm = searchController.text.toLowerCase();
    if (searchTerm.isEmpty) {
      filteredTransactions.assignAll(transactions.value?.body ?? []);
    } else {
      filteredTransactions.assignAll(
        (transactions.value?.body ?? []).where(
          (txn) => txn.title?.toLowerCase().contains(searchTerm) ?? false,
        ),
      );
    }
    filteredTransactions.refresh();
  }

  // ============================================================================
  // DATE FORMATTING METHODS
  // ============================================================================
  /// Formats transaction date for display
  /// Returns "Today" if date is today, otherwise formatted date string
  String formatTransactionDate(DateTime date) {
    final now = DateTime.now();
    final localDate = date.toLocal();
    if (now.year == localDate.year &&
        now.month == localDate.month &&
        now.day == localDate.day) {
      return 'Today';
    } else {
      return DateFormat('dd MMMM yyyy').format(localDate);
    }
  }

  /// Formats ISO date string to dd-MM-yyyy format
  String formatDate(String isoDate) {
    final dateTime = DateTime.parse(isoDate).toLocal();
    return DateFormat('dd-MM-yyyy').format(dateTime);
  }

  /// Formats date string to time format (e.g., "3:45 PM")
  String formatTime(String dateStr) {
    final dateTime = DateTime.parse(dateStr).toLocal();
    return DateFormat.jm().format(dateTime);
  }

  // ============================================================================
  // TRANSACTION GROUPING METHODS
  // ============================================================================
  /// Groups filtered transactions by date label
  /// Returns a LinkedHashMap to preserve insertion order
  /// Transactions are sorted based on selectedSortBy before grouping
  Map<String, List<TransBody>> get groupedTransactions {
    final Map<String, List<TransBody>> grouped = LinkedHashMap<String, List<TransBody>>();

    // Sort transactions based on selected sort order
    List<TransBody> sortedTransactions = List.from(filteredTransactions);

    if (selectedSortBy.value == 'Date (old to new)') {
      // Oldest to newest
      sortedTransactions.sort((a, b) {
        if (a.date == null || b.date == null) return 0;
        return a.date!.compareTo(b.date!);
      });
    } else {
      // Default: newest to oldest (for initial load and 'Date (new to old)')
      sortedTransactions.sort((a, b) {
        if (a.date == null || b.date == null) return 0;
        return b.date!.compareTo(a.date!);
      });
    }

    // Group sorted transactions by date label
    for (var txn in sortedTransactions) {
      if (txn.date != null) {
        final label = formatTransactionDate(txn.date!);
        grouped.putIfAbsent(label, () => []);
        grouped[label]!.add(txn);
      } else {
        print('⚠️ Skipping transaction with null date: ${txn.toJson()}');
      }
    }

    return grouped;
  }

  // ============================================================================
  // FILTER STATUS GETTERS
  // ============================================================================
  /// Checks if any filters are currently active
  bool get hasActiveFilters {
    return selectedDateRange.value != null ||
        (selectedDate.value.isNotEmpty && selectedDate.value != 'All time') ||
        selectedAmountRange.value != null ||
        selectedCategories.isNotEmpty ||
        selectedTransactionType.isNotEmpty ||
        selectedAccounts.isNotEmpty ||
        selectedSortBy.value != 'All';
  }

  /// Returns the count of active filters
  int get activeFilterCount {
    int count = 0;
    if (selectedDateRange.value != null ||
        (selectedDate.value.isNotEmpty && selectedDate.value != 'All time'))
      count++;
    if (selectedAmountRange.value != null) count++;
    if (selectedCategories.isNotEmpty) count++;
    if (selectedTransactionType.isNotEmpty) count++;
    if (selectedAccounts.isNotEmpty) count++;
    if (selectedSortBy.value != 'All') count++;
    return count;
  }
}

// ============================================================================
// SUPPORTING CLASSES
// ============================================================================
/// Model class for filter options with icon/logo support
class CustomModelForIconWithHeading {
  String name;
  String? logoName;

  CustomModelForIconWithHeading({required this.name, this.logoName});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomModelForIconWithHeading &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() => name;
}
