import 'package:flutter/material.dart';
import 'package:flutter_project_1/Model/model.dart';
import 'package:flutter_project_1/Widgets/CoffeeCard.dart';

const Color _cream = Color(0xFFFFF9F7);
const Color _darkBrown = Color(0xFF3E2723);
const Color _softBrown = Color(0xFF795548);
const Color _lightBrown = Color(0xFFA1887F);

class SearchScreen extends StatefulWidget {
  final List<Product> products;

  const SearchScreen({super.key, required this.products});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Product> get _results {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return const [];
    return widget.products
        .where((p) => p.name.toLowerCase().contains(q))
        .toList();
  }

  void _onQueryChanged(String value) {
    setState(() => _query = value);
  }

  @override
  Widget build(BuildContext context) {
    final searching = _query.trim().isNotEmpty;
    final results = _results;

    return Scaffold(
      backgroundColor: _cream,
      appBar: AppBar(
        backgroundColor: _cream,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: _darkBrown,
          ),
        ),
        title: const Text(
          'Search',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: _darkBrown,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: TextField(
                controller: _controller,
                onChanged: _onQueryChanged,
                textInputAction: TextInputAction.search,
                style: const TextStyle(
                  fontSize: 15,
                  color: _darkBrown,
                ),
                decoration: InputDecoration(
                  hintText: 'Search coffee...',
                  hintStyle: const TextStyle(color: _softBrown),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: _softBrown,
                  ),
                  suffixIcon: _query.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.clear, color: _softBrown),
                          onPressed: () {
                            _controller.clear();
                            _onQueryChanged('');
                          },
                        ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.brown.shade200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.brown.shade400, width: 1.4),
                  ),
                ),
              ),
            ),
            Expanded(
              child: searching
                  ? (results.isEmpty
                      ? const _NoResultsState()
                      : GridView.builder(
                          padding: const EdgeInsets.fromLTRB(12, 4, 12, 24),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.75,
                          ),
                          itemCount: results.length,
                          itemBuilder: (context, index) {
                            return CoffeeCard(product: results[index]);
                          },
                        ))
                  : const _EmptySearchState(),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptySearchState extends StatelessWidget {
  const _EmptySearchState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.brown.shade50,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.search,
                size: 48,
                color: _lightBrown,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Find Your Coffee',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: _darkBrown,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Search for your favorite\ncoffee and discover something new.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: _softBrown,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NoResultsState extends StatelessWidget {
  const _NoResultsState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.brown.shade50,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.local_cafe_outlined,
                size: 48,
                color: _lightBrown,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No Coffee Found',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: _darkBrown,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Try searching for another\ncoffee or check the spelling.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: _softBrown,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
