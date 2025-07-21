import 'package:flutter/material.dart';
import 'package:pedidos_fundacion/features/pedidos/presentation/screens/hello_world_screen.dart'; // Adjust 'your_project_name'

class Example11Screen extends StatelessWidget {
  const Example11Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Example 11 Screen'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Pulsa el botón para ver el "Hola Mundo":',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to the HelloWorldScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HelloWorldScreen(),
                  ),
                );
              },
              child: const Text('Ir a Hola Mundo'),
            ),
          ],
        ),
      ),
    );
  }
}