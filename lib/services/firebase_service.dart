import 'package:cloud_firestore/cloud_firestore.dart';

abstract class FirebaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  static FirebaseFirestore get firestore => _firestore;
  
  static const String tablesCollection = 'tables';
  static const String categoriesCollection = 'categories';
  static const String productsCollection = 'products';
  static const String ordersCollection = 'orders';
  static const String orderItemsCollection = 'order_items';
  static const String restaurantsCollection = 'restaurants';

  static CollectionReference get tables => _firestore.collection(tablesCollection);
  static CollectionReference get categories => _firestore.collection(categoriesCollection);
  static CollectionReference get products => _firestore.collection(productsCollection);
  static CollectionReference get orders => _firestore.collection(ordersCollection);
  static CollectionReference get restaurants => _firestore.collection(restaurantsCollection);
}