// TODO Implement this library.
import 'category.dart';

class CategoryClassifier {
  static Category classify(String merchant) {
    final m = merchant.toLowerCase();

    // 🍔 FOOD
    if (_containsAny(m, [
      'swiggy',
      'zomato',
      'hotel',
      'restaurant',
      'food',
      'canteen',
      'biryani',
      'pizza',
      'burger',
      'cafe',
      'dhabha',
    ])) {
      return Category.food;
    }

    // 🚌 TRAVEL
    if (_containsAny(m, [
      'uber',
      'ola',
      'metro',
      'rail',
      'irctc',
      'abhibus',
      'redbus',
      'ixigo',
      'rapido',
      'bus',
      'flight',
    ])) {
      return Category.travel;
    }

    // 🛒 SHOPPING
    if (_containsAny(m, [
      'amazon',
      'flipkart',
      'zepto',
      'dmart',
      'myntra',
      'meesho',
      'shopping',
      'store',
      'mart',
    ])) {
      return Category.shopping;
    }

    // 📱 RECHARGE / UTILITIES
    if (_containsAny(m, [
      'jio',
      'airtel',
      'vi ',
      'bsnl',
      'recharge',
      'electricity',
      'water',
      'gas',
      'bill',
    ])) {
      return Category.bills;
    }

    // 🎓 EDUCATION
    if (_containsAny(m, [
      'college',
      'university',
      'school',
      'exam',
      'fee',
      'education',
      'academy',
      'institute',
      'griet',
    ])) {
      return Category.education;
    }

    // 🏧 ATM
    if (m.contains('atm')) {
      return Category.atm;
    }

    // 💰 INCOME / TRANSFER
    if (_containsAny(m, [
      'salary',
      'stipend',
      'credit',
      'transfer',
      'received',
    ])) {
      return Category.income;
    }

    // ❓ OTHER (fallback)
    return Category.other;
  }

  static bool _containsAny(String text, List<String> keywords) {
    for (final k in keywords) {
      if (text.contains(k)) return true;
    }
    return false;
  }
}
