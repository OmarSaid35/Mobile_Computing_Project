import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:scratch_ecommerce/screens/checkout/delivery_location_screen.dart';
import 'package:provider/provider.dart';
import 'package:scratch_ecommerce/providers/auth_provider.dart';
import 'package:scratch_ecommerce/providers/cart_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CheckoutButton extends StatelessWidget {
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
                  ? Text('Location confirmed ${location.latitude}, ${location.longitude}')
                  : Text('Location confirmed: $location'),
                 ),
             );
          }
        } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(
                content: Text('Location not set, proceed to order without location'),
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

     if(user != null){
        try{
            await FirebaseFirestore.instance.collection('orders').add({
               'username': user.name,
                'time': now.toString(),
               'totalPrice': totalPrice,
            });

           ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Order placed successfully!'))
             );

             cartProvider.clear(); //clear the cart after order is placed

        }catch(e){
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error placing order $e'))
            );
        }
      }
    else{
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to continue'))
        );
     }
  }
}