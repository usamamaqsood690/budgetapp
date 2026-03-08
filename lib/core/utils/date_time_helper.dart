import 'package:intl/intl.dart';

/// A clean, reusable DateTime converter utility class.
/// Uses the `intl` package for locale-aware formatting.
///
/// Usage:
///   DateTimeConverter.toFullDate(dateTime)       → "January 15, 2025"
///   DateTimeConverter.toTime12h(dateTime)         → "02:30 PM"
///   DateTimeConverter.toRelative(dateTime)        → "2 hours ago"
///   DateTimeConverter.toCustom(dateTime, 'yyyy')  → "2025"
class DateTimeConverter {
  DateTimeConverter._(); // Prevent instantiation

  // ──────────────────────────────────────────────
  //  DATE FORMATS
  // ──────────────────────────────────────────────

  ///01/15//2025
  static String toShortDate(DateTime date) {
    return DateFormat('MM/dd/yyyy').format(date);
  }

  /// 01-15-2025 (US style)
  /// 07-18-2026 → DateTime
  static DateTime toShortDateUS(String date) {
    return DateFormat('MM-dd-yyyy').parseStrict(date);
  }


  /// 2025-01-15 (ISO 8601)
  static String toISODate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  /// 01/15/2025 (US style)
  static String toISOShortDate(DateTime date) {
    return DateFormat('MM-dd-yyyy').format(date);
  }

  /// January 15, 2025
  static String toFullDate(DateTime date) {
    return DateFormat('MMMM dd, yyyy').format(date);
  }

  /// Jan 15, 2025
  static String toMediumDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  /// 15 Jan 2025
  static String toDayMonthYear(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  /// Wednesday, January 15, 2025
  static String toFullDateWithDay(DateTime date) {
    return DateFormat('EEEE, MMMM dd, yyyy').format(date);
  }

  /// Wed, Jan 15, 2025
  static String toShortDateWithDay(DateTime date) {
    return DateFormat('EEE, MMM dd, yyyy').format(date);
  }

  // ──────────────────────────────────────────────
  //  TIME FORMATS
  // ──────────────────────────────────────────────

  /// 02:30 PM
  static String toTime12h(DateTime date) {
    return DateFormat('hh:mm a').format(date);
  }

  /// 14:30
  static String toTime24h(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  /// 14:30:45
  static String toTime24hWithSeconds(DateTime date) {
    return DateFormat('HH:mm:ss').format(date);
  }

  /// 02:30:45 PM
  static String toTime12hWithSeconds(DateTime date) {
    return DateFormat('hh:mm:ss a').format(date);
  }

  // ──────────────────────────────────────────────
  //  DATE + TIME COMBINED
  // ──────────────────────────────────────────────

  /// January 15, 2025 at 02:30 PM
  static String toFullDateTime(DateTime date) {
    return DateFormat('MMMM dd, yyyy \'at\' hh:mm a').format(date);
  }

  /// Jan 15, 2025 • 02:30 PM
  static String toMediumDateTime(DateTime date) {
    return '${DateFormat('MMM dd, yyyy').format(date)} • ${DateFormat('hh:mm a').format(date)}';
  }

  /// 15/01/2025 14:30
  static String toShortDateTime(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }

  /// 2025-01-15T14:30:00 (ISO 8601)
  static String toISODateTime(DateTime date) {
    return date.toIso8601String();
  }

  // ──────────────────────────────────────────────
  //  INDIVIDUAL PARTS
  // ──────────────────────────────────────────────

  /// "15"
  static String dayOfMonth(DateTime date) {
    return DateFormat('dd').format(date);
  }

  /// "01"
  static String monthNumber(DateTime date) {
    return DateFormat('MM').format(date);
  }

  /// "January"
  static String monthName(DateTime date) {
    return DateFormat('MMMM').format(date);
  }

  /// "Jan"
  static String monthNameShort(DateTime date) {
    return DateFormat('MMM').format(date);
  }

  /// "2025"
  static String year(DateTime date) {
    return DateFormat('yyyy').format(date);
  }

  /// "Wednesday"
  static String dayName(DateTime date) {
    return DateFormat('EEEE').format(date);
  }

  /// "Wed"
  static String dayNameShort(DateTime date) {
    return DateFormat('EEE').format(date);
  }

  /// "Q1", "Q2", "Q3", "Q4"
  static String quarter(DateTime date) {
    return 'Q${((date.month - 1) ~/ 3) + 1}';
  }

  static String toMonthDayYear(String dateString) {
    try {
      final parsedDate = DateTime.parse(dateString);
      return DateFormat('MM-dd-yyyy').format(parsedDate);
    } catch (e) {
      return dateString;
    }
  }

  // ──────────────────────────────────────────────
  //  RELATIVE TIME (Time Ago / Time From Now)
  // ──────────────────────────────────────────────

  /// "Just now", "5 minutes ago", "2 hours ago", "3 days ago", etc.
  static String toRelative(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    final isFuture = difference.isNegative;
    final duration = difference.abs();

    String result;

    if (duration.inSeconds < 60) {
      result = 'Just now';
      return result;
    } else if (duration.inMinutes < 60) {
      final minutes = duration.inMinutes;
      result = '$minutes ${minutes == 1 ? 'minute' : 'minutes'}';
    } else if (duration.inHours < 24) {
      final hours = duration.inHours;
      result = '$hours ${hours == 1 ? 'hour' : 'hours'}';
    } else if (duration.inDays < 7) {
      final days = duration.inDays;
      result = '$days ${days == 1 ? 'day' : 'days'}';
    } else if (duration.inDays < 30) {
      final weeks = duration.inDays ~/ 7;
      result = '$weeks ${weeks == 1 ? 'week' : 'weeks'}';
    } else if (duration.inDays < 365) {
      final months = duration.inDays ~/ 30;
      result = '$months ${months == 1 ? 'month' : 'months'}';
    } else {
      final years = duration.inDays ~/ 365;
      result = '$years ${years == 1 ? 'year' : 'years'}';
    }

    return isFuture ? 'in $result' : '$result ago';
  }

  // ──────────────────────────────────────────────
  //  SMART / CONTEXTUAL FORMATTING
  // ──────────────────────────────────────────────

  /// Shows "Today", "Yesterday", "Tomorrow", or falls back to medium date.
  /// e.g., "Today at 02:30 PM", "Yesterday at 10:00 AM", "Jan 12, 2025"
  static String toSmart(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);
    final diff = target.difference(today).inDays;

    final time = DateFormat('hh:mm a').format(date);

    if (diff == 0) return 'Today at $time';
    if (diff == -1) return 'Yesterday at $time';
    if (diff == 1) return 'Tomorrow at $time';

    return toMediumDateTime(date);
  }

  /// Chat-style: "10:30 AM" for today, "Yesterday" for yesterday,
  /// "Mon" for this week, "Jan 15" for this year, "Jan 15, 2024" otherwise.
  static String toChatStyle(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);
    final diff = today.difference(target).inDays;

    if (diff == 0) return DateFormat('hh:mm a').format(date);
    if (diff == 1) return 'Yesterday';
    if (diff < 7) return DateFormat('EEE').format(date);
    if (date.year == now.year) return DateFormat('MMM dd').format(date);

    return DateFormat('MMM dd, yyyy').format(date);
  }

  // ──────────────────────────────────────────────
  //  PARSING
  // ──────────────────────────────────────────────

  /// Parses a date string with a given format.
  /// Returns `null` if parsing fails.
  ///
  /// Example: DateTimeConverter.parse("15/01/2025", "dd/MM/yyyy")
  static DateTime? parse(String dateString, String format) {
    try {
      return DateFormat(format).parseStrict(dateString);
    } catch (_) {
      return null;
    }
  }

  /// Tries to parse a date string automatically from common formats.
  static DateTime? tryParse(String dateString) {
    final formats = [
      'yyyy-MM-dd',
      'dd/MM/yyyy',
      'MM/dd/yyyy',
      'yyyy-MM-dd HH:mm:ss',
      'dd/MM/yyyy HH:mm',
      'MMM dd, yyyy',
      'MMMM dd, yyyy',
    ];

    for (final format in formats) {
      try {
        return DateFormat(format).parseStrict(dateString);
      } catch (_) {
        continue;
      }
    }
    return null;
  }

  // ──────────────────────────────────────────────
  //  CUSTOM FORMAT
  // ──────────────────────────────────────────────

  /// Format with any custom pattern.
  ///
  /// Common patterns:
  ///   yyyy → 2025       yy → 25
  ///   MMMM → January    MMM → Jan       MM → 01     M → 1
  ///   dd   → 15         d  → 5
  ///   EEEE → Wednesday  EEE → Wed
  ///   HH   → 14 (24h)   hh → 02 (12h)
  ///   mm   → 30         ss → 45
  ///   a    → PM
  static String toCustom(DateTime date, String pattern) {
    return DateFormat(pattern).format(date);
  }

  // ──────────────────────────────────────────────
  //  UTILITY HELPERS
  // ──────────────────────────────────────────────

  /// Check if two dates are the same day.
  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  /// Check if the date is today.
  static bool isToday(DateTime date) => isSameDay(date, DateTime.now());

  /// Check if the date is yesterday.
  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return isSameDay(date, yesterday);
  }

  /// Check if the date is tomorrow.
  static bool isTomorrow(DateTime date) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return isSameDay(date, tomorrow);
  }

  /// Returns the start of the day (00:00:00).
  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Returns the end of the day (23:59:59.999).
  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  }

  /// Returns the difference between two dates as a readable string.
  /// e.g., "2 days, 3 hours, 15 minutes"
  static String differenceBetween(DateTime from, DateTime to) {
    final diff = to.difference(from).abs();
    final parts = <String>[];

    if (diff.inDays > 0) {
      parts.add('${diff.inDays} ${diff.inDays == 1 ? 'day' : 'days'}');
    }
    final hours = diff.inHours % 24;
    if (hours > 0) {
      parts.add('$hours ${hours == 1 ? 'hour' : 'hours'}');
    }
    final minutes = diff.inMinutes % 60;
    if (minutes > 0) {
      parts.add('$minutes ${minutes == 1 ? 'minute' : 'minutes'}');
    }

    return parts.isEmpty ? '0 minutes' : parts.join(', ');
  }
}

// final now = DateTime.now();
//
// DateTimeConverter.toFullDate(now);        // "January 15, 2025"
// DateTimeConverter.toShortDate(now);       // "15/01/2025"
// DateTimeConverter.toTime12h(now);         // "02:30 PM"
// DateTimeConverter.toRelative(now);        // "5 minutes ago"
// DateTimeConverter.toSmart(now);           // "Today at 02:30 PM"
// DateTimeConverter.toChatStyle(now);       // "10:30 AM" (if today)
// DateTimeConverter.monthName(now);         // "January"
// DateTimeConverter.dayName(now);           // "Wednesday"
// DateTimeConverter.toCustom(now, 'yyyy');  // "2025"
// DateTimeConverter.isToday(now);           // true
// DateTimeConverter.differenceBetween(a,b); // "2 days, 3 hours"