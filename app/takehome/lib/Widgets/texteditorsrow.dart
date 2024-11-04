import 'package:flutter/material.dart';
import '../Adapter/responsiveness.dart';

class FiltersRow extends StatelessWidget {
  const FiltersRow({
    super.key,
    required TextEditingController controller1,
    required TextEditingController controller2,
    required TextEditingController controller3,
    required TextEditingController controller4,
  })  : _controller1 = controller1,
        _controller2 = controller2,
        _controller3 = controller3,
        _controller4 = controller4;

  final TextEditingController _controller1;
  final TextEditingController _controller2;
  final TextEditingController _controller3;
  final TextEditingController _controller4;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: ofScreenSize(0.02, context),
          vertical: ofScreenSize(0.02, context)),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.orange.shade100,
            border: Border.all(color: Colors.black87, width: 2)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const Spacer(flex: 1),
              Expanded(
                flex: 3,
                child: TextField(
                  controller: _controller1,
                  decoration: const InputDecoration(
                    labelText: 'Código',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const Spacer(flex: 1),
              Expanded(
                flex: 3,
                child: TextField(
                  controller: _controller2,
                  decoration: const InputDecoration(
                    labelText: 'Descrição',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const Spacer(flex: 1),
              Expanded(
                flex: 3,
                child: TextField(
                  controller: _controller3,
                  decoration: const InputDecoration(
                    labelText: 'Custo',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const Spacer(flex: 1),
              Expanded(
                flex: 3,
                child: TextField(
                  controller: _controller4,
                  decoration: const InputDecoration(
                    labelText: 'Preço de Venda',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}
