import 'package:flutter/material.dart';
import 'package:union_shop/models/cart.dart';
import 'package:union_shop/widgets/shared_layout.dart';
import 'package:union_shop/models/product.dart';

class ThePrintShackPage extends StatefulWidget {
  const ThePrintShackPage({super.key});

  @override
  State<ThePrintShackPage> createState() => _ThePrintShackPageState();
}

class _ThePrintShackPageState extends State<ThePrintShackPage> {
  final List<String> _productTypes = ['T-Shirt', 'Hoodie', 'Mug'];
  final List<String> _fonts = ['Arial', 'Georgia', 'Roboto'];
  final List<String> _textColours = ['White', 'Black', 'Red', 'Blue'];
  final List<String> _positions = ['Front Center', 'Front Left Chest', 'Back Center'];

  String _selectedProduct = 'T-Shirt';
  String _selectedFont = 'Arial';
  String _selectedColour = 'White';
  String _selectedPosition = 'Front Center';

  final TextEditingController _textController = TextEditingController();
  static const int _maxChars = 30;

  @override
  void initState() {
    super.initState();
    _textController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Color _colorFromName(String name) {
    switch (name) {
      case 'Black':
        return Colors.black;
      case 'Red':
        return Colors.red;
      case 'Blue':
        return Colors.blue;
      case 'White':
      default:
        return Colors.white;
    }
  }

  Alignment _alignmentForPosition(String pos) {
    switch (pos) {
      case 'Front Left Chest':
        return const Alignment(-0.6, -0.0);
      case 'Back Center':
        return const Alignment(0.0, -0.1);
      case 'Front Center':
      default:
        return Alignment.center;
    }
  }

  @override
  Widget build(BuildContext context) {
    final String? productImage = productRegistry['essential_tshirt']?.images.first;
    const contentPadding = EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const AppHeader(),

            // Main centered content area
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: Container(
                  color: Colors.white,
                  padding: contentPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 8),
                      const Center(
                        child: Text(
                          'Print Shack — Personalise your product',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF333333),
                          ),
                        ),
                      ),
                      const SizedBox(height: 36),

                      LayoutBuilder(
                        builder: (context, constraints) {
                          final isNarrow = constraints.maxWidth < 900;
                          // On narrow screens stack the cards vertically (no Expanded widgets)
                          if (isNarrow) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Card(
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('Customise Your Product', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                                        const SizedBox(height: 16),

                                        const Text('Product Type'),
                                        const SizedBox(height: 8),
                                        DropdownButtonFormField<String>(
                                          initialValue: _selectedProduct,
                                          items: _productTypes.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
                                          onChanged: (v) => setState(() => _selectedProduct = v ?? _selectedProduct),
                                        ),
                                        const SizedBox(height: 16),

                                        const Text('Font'),
                                        const SizedBox(height: 8),
                                        DropdownButtonFormField<String>(
                                          initialValue: _selectedFont,
                                          items: _fonts.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
                                          onChanged: (v) => setState(() => _selectedFont = v ?? _selectedFont),
                                        ),
                                        const SizedBox(height: 16),

                                        const Text('Text Colour'),
                                        const SizedBox(height: 8),
                                        DropdownButtonFormField<String>(
                                          initialValue: _selectedColour,
                                          items: _textColours.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
                                          onChanged: (v) => setState(() => _selectedColour = v ?? _selectedColour),
                                        ),
                                        const SizedBox(height: 16),

                                        const Text('Position'),
                                        const SizedBox(height: 8),
                                        DropdownButtonFormField<String>(
                                          initialValue: _selectedPosition,
                                          items: _positions.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
                                          onChanged: (v) => setState(() => _selectedPosition = v ?? _selectedPosition),
                                        ),
                                        const SizedBox(height: 16),

                                        const Text('Custom Text'),
                                        const SizedBox(height: 8),
                                        TextField(
                                          controller: _textController,
                                          maxLength: _maxChars,
                                          decoration: const InputDecoration(hintText: 'Enter your text here...', border: OutlineInputBorder()),
                                        ),

                                        const SizedBox(height: 16),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: ElevatedButton(
                                                onPressed: _textController.text.trim().isEmpty
                                                    ? null
                                                    : () {
                                                        String baseId;
                                                        switch (_selectedProduct) {
                                                          case 'Hoodie':
                                                            baseId = 'limited_essential_zip_hoodie';
                                                            break;
                                                          case 'Mug':
                                                            baseId = 'signature_mug';
                                                            break;
                                                          case 'T-Shirt':
                                                          default:
                                                            baseId = 'essential_tshirt';
                                                        }

                                                        final product = productRegistry[baseId];
                                                        final price = product?.price ?? 0.0;
                                                        final image = (product?.images.isNotEmpty ?? false) ? product!.images.first : null;

                                                        final customId = '${baseId}_custom_${_textController.text.hashCode}';

                                                        final item = CartItem(
                                                          id: customId,
                                                          title: '${product?.title ?? _selectedProduct} - ${_textController.text}',
                                                          color: _selectedColour,
                                                          size: _selectedPosition,
                                                          image: image,
                                                          quantity: 1,
                                                          price: price,
                                                        );

                                                        globalCart.add(item);

                                                        final summary = '$_selectedProduct ($_selectedColour) - "${_textController.text}"';
                                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Added to cart: $summary')));
                                                      },
                                                child: const Padding(padding: EdgeInsets.symmetric(vertical: 14), child: Text('Add to Cart')),
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            OutlinedButton(
                                              onPressed: () => setState(() => _textController.clear()),
                                              child: const Padding(padding: EdgeInsets.symmetric(vertical: 14, horizontal: 8), child: Text('Clear')),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                // Preview & selection stacked under the form on mobile
                                Card(
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('Preview', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                                        const SizedBox(height: 12),
                                        Container(
                                          height: 260,
                                          width: double.infinity,
                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade300)),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(6),
                                            child: Stack(
                                              fit: StackFit.expand,
                                              children: [
                                                if (productImage != null) Image.network(productImage, fit: BoxFit.contain) else Container(color: Colors.grey.shade200),
                                                if (_textController.text.trim().isNotEmpty)
                                                  Align(
                                                    alignment: _alignmentForPosition(_selectedPosition),
                                                    child: FractionallySizedBox(
                                                      widthFactor: 0.8,
                                                      child: Text(
                                                        _textController.text,
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(fontFamily: _selectedFont, fontSize: 26, color: _colorFromName(_selectedColour), shadows: const [Shadow(offset: Offset(0, 1), blurRadius: 2, color: Colors.black26)]),
                                                      ),
                                                    ),
                                                  )
                                                else
                                                  const Center(child: Text('Enter text to see preview', style: TextStyle(color: Colors.grey))),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        Card(
                                          elevation: 0,
                                          color: Colors.grey.shade100,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(16),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const Text('Your Selection', style: TextStyle(fontWeight: FontWeight.w700)),
                                                const SizedBox(height: 12),
                                                _buildSelectionRow('Product', _selectedProduct),
                                                _buildSelectionRow('Font', _selectedFont),
                                                _buildSelectionRow('Colour', _selectedColour),
                                                _buildSelectionRow('Position', _selectedPosition),
                                                _buildSelectionRow('Text', _textController.text.isEmpty ? '-' : _textController.text),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }

                          // Desktop / wide layout: two-column with Expanded children
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 5,
                                child: Card(
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('Customise Your Product', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                                        const SizedBox(height: 16),

                                        const Text('Product Type'),
                                        const SizedBox(height: 8),
                                        DropdownButtonFormField<String>(
                                          initialValue: _selectedProduct,
                                          items: _productTypes.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
                                          onChanged: (v) => setState(() => _selectedProduct = v ?? _selectedProduct),
                                        ),
                                        const SizedBox(height: 16),

                                        const Text('Font'),
                                        const SizedBox(height: 8),
                                        DropdownButtonFormField<String>(
                                          initialValue: _selectedFont,
                                          items: _fonts.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
                                          onChanged: (v) => setState(() => _selectedFont = v ?? _selectedFont),
                                        ),
                                        const SizedBox(height: 16),

                                        const Text('Text Colour'),
                                        const SizedBox(height: 8),
                                        DropdownButtonFormField<String>(
                                          initialValue: _selectedColour,
                                          items: _textColours.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
                                          onChanged: (v) => setState(() => _selectedColour = v ?? _selectedColour),
                                        ),
                                        const SizedBox(height: 16),

                                        const Text('Position'),
                                        const SizedBox(height: 8),
                                        DropdownButtonFormField<String>(
                                          initialValue: _selectedPosition,
                                          items: _positions.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
                                          onChanged: (v) => setState(() => _selectedPosition = v ?? _selectedPosition),
                                        ),
                                        const SizedBox(height: 16),

                                        const Text('Custom Text'),
                                        const SizedBox(height: 8),
                                        TextField(
                                          controller: _textController,
                                          maxLength: _maxChars,
                                          decoration: const InputDecoration(hintText: 'Enter your text here...', border: OutlineInputBorder()),
                                        ),

                                        const SizedBox(height: 16),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: ElevatedButton(
                                                onPressed: _textController.text.trim().isEmpty
                                                    ? null
                                                    : () {
                                                        String baseId;
                                                        switch (_selectedProduct) {
                                                          case 'Hoodie':
                                                            baseId = 'limited_essential_zip_hoodie';
                                                            break;
                                                          case 'Mug':
                                                            baseId = 'signature_mug';
                                                            break;
                                                          case 'T-Shirt':
                                                          default:
                                                            baseId = 'essential_tshirt';
                                                        }

                                                        final product = productRegistry[baseId];
                                                        final price = product?.price ?? 0.0;
                                                        final image = (product?.images.isNotEmpty ?? false) ? product!.images.first : null;

                                                        final customId = '${baseId}_custom_${_textController.text.hashCode}';

                                                        final item = CartItem(
                                                          id: customId,
                                                          title: '${product?.title ?? _selectedProduct} - ${_textController.text}',
                                                          color: _selectedColour,
                                                          size: _selectedPosition,
                                                          image: image,
                                                          quantity: 1,
                                                          price: price,
                                                        );

                                                        globalCart.add(item);

                                                        final summary = '$_selectedProduct ($_selectedColour) - "${_textController.text}"';
                                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Added to cart: $summary')));
                                                      },
                                                child: const Padding(padding: EdgeInsets.symmetric(vertical: 14), child: Text('Add to Cart')),
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            OutlinedButton(
                                              onPressed: () => setState(() => _textController.clear()),
                                              child: const Padding(padding: EdgeInsets.symmetric(vertical: 14, horizontal: 8), child: Text('Clear')),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                flex: 4,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Card(
                                      elevation: 2,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text('Preview', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                                            const SizedBox(height: 12),
                                            Container(
                                              height: 260,
                                              width: double.infinity,
                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade300)),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(6),
                                                child: Stack(
                                                  fit: StackFit.expand,
                                                  children: [
                                                    if (productImage != null) Image.network(productImage, fit: BoxFit.contain) else Container(color: Colors.grey.shade200),
                                                    if (_textController.text.trim().isNotEmpty)
                                                      Align(
                                                        alignment: _alignmentForPosition(_selectedPosition),
                                                        child: FractionallySizedBox(
                                                          widthFactor: 0.8,
                                                          child: Text(
                                                            _textController.text,
                                                            textAlign: TextAlign.center,
                                                            style: TextStyle(fontFamily: _selectedFont, fontSize: 26, color: _colorFromName(_selectedColour), shadows: const [Shadow(offset: Offset(0, 1), blurRadius: 2, color: Colors.black26)]),
                                                          ),
                                                        ),
                                                      )
                                                    else
                                                      const Center(child: Text('Enter text to see preview', style: TextStyle(color: Colors.grey))),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Card(
                                      elevation: 0,
                                      color: Colors.grey.shade100,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text('Your Selection', style: TextStyle(fontWeight: FontWeight.w700)),
                                            const SizedBox(height: 12),
                                            _buildSelectionRow('Product', _selectedProduct),
                                            _buildSelectionRow('Font', _selectedFont),
                                            _buildSelectionRow('Colour', _selectedColour),
                                            _buildSelectionRow('Position', _selectedPosition),
                                            _buildSelectionRow('Text', _textController.text.isEmpty ? '-' : _textController.text),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const AppFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(label, style: const TextStyle(color: Colors.grey)), Flexible(child: Text(value, textAlign: TextAlign.right))],
      ),
    );
  }
}
