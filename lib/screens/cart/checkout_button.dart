import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:scratch_ecommerce/screens/checkout/delivery_location_screen.dart';


class CheckoutButton extends StatelessWidget {
  const CheckoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final position = await Navigator.push<Position>(
          context,
          MaterialPageRoute(
            builder: (context) => const DeliveryLocationScreen(),
          ),
        );

        if (position != null) {
          // Process checkout with delivery location
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Processing your order...'),
            ),
          );
        }
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
}