import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:scratch_ecommerce/screens/checkout/delivery_location_screen.dart';
import 'package:provider/provider.dart';
import 'package:scratch_ecommerce/providers/auth_provider.dart';
import 'package:scratch_ecommerce/providers/cart_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CheckoutButton extends StatelessWidget {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  const CheckoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        // Attempt to get location. If it fails, we proceed to order checkout without location information
        try {
          final location = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const DeliveryLocationScreen(),
            ),
          );
          if (location != null) {
            // Process checkout with delivery location
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: location is Position
                    ? Text(
                        'Location confirmed ${location.latitude}, ${location.longitude}')
                    : Text('Location confirmed: $location'),
              ),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text('Location not set, proceed to order without location'),
            ),
          );
          // Handle the case where getting the location fails
          // Proceed with the checkout process without a location
        }

        _placeOrder(context);
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: const Text(
        'Proceed to Checkout',
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  Future<void> _placeOrder(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final user = authProvider.user;
    final totalPrice = cartProvider.total;
    final now = DateTime.now();

    if (user != null) {
      try {
        String? feedback = await showDialog<String>(
          context: context,
          builder: (context) {
            final feedbackController = TextEditingController();
            return AlertDialog(
              title: const Text('Order Feedback'),
              content: TextField(
                controller: feedbackController,
                decoration: const InputDecoration(
                  labelText: 'Your feedback (optional)',
                ),
                maxLines: 3,
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(null),
                  child: const Text('Skip'),
                ),
                TextButton(
                  onPressed: () =>
                      Navigator.of(context).pop(feedbackController.text),
                  child: const Text('Submit'),
                ),
              ],
            );
          },
        );

        // Proceed with the transaction
        await FirebaseFirestore.instance.runTransaction((transaction) async {
          final orderData = {
            'username': user.name,
            'time': now.toIso8601String(),
            'totalPrice': totalPrice,
            'feedback': feedback ?? '', // Save feedback
          };
          await FirebaseFirestore.instance.collection('orders').add(orderData);

          for (final cartItem in cartProvider.items) {
            String productId = cartItem.product.id;
            DocumentSnapshot doc =
                await _firestore.collection('product').doc(productId).get();

            if (doc.exists) {
              final newStockQuantity =
                  cartItem.product.stockQuantity - cartItem.quantity;
              final newSoldCount =
                  cartItem.product.soldCount + cartItem.quantity;

              await _firestore.collection('product').doc(productId).update({
                'quantity': newStockQuantity,
                'sales': newSoldCount,
              });
            } else {
              print("Document does not exist with ID: ${cartItem.product.id}");
            }
          }
        });

        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Order placed successfully!')));

        cartProvider.clear(); // Clear the cart after the order is placed
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error placing order $e')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please log in to continue')));
    }
  }
}
