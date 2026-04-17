import 'package:flutter/material.dart';
class CardListGridSliverDemo extends StatelessWidget {
  const CardListGridSliverDemo({super.key});
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Cards, Lists, Grids & Slivers'),
          backgroundColor: Colors.red.shade700,
          bottom: const TabBar(
            isScrollable: true,
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(text: 'Cards'),
              Tab(text: 'List'),
              Tab(text: 'Grid'),
              Tab(text: 'Stack'),
              Tab(text: 'Slivers'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _CardsDemo(),
            _ListViewDemo(),
            _GridViewDemo(),
            _StackDemo(),
            _SliversDemo(),
          ],
        ),
      ),
    );
  }
}

// ---------- 1. Cards Demo ----------
class _CardsDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          elevation: 5,
          margin: const EdgeInsets.all(10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: const ListTile(
            leading: Icon(Icons.school, color: Colors.red),
            title: Text('AI Lecture 1'),
            subtitle: Text('Generated slides for Machine Learning'),
          ),
        ),
        Card(
          elevation: 8,
          margin: const EdgeInsets.all(10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: const ListTile(
            leading: Icon(Icons.slideshow, color: Colors.red),
            title: Text('AI Lecture 2'),
            subtitle: Text('Deep Learning basics'),
          ),
        ),
        Card(
          elevation: 3,
          margin: const EdgeInsets.all(10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: const ListTile(
            leading: Icon(Icons.chat, color: Colors.red),
            title: Text('AI Chat Session'),
            subtitle: Text('Q&A about Flutter'),
          ),
        ),
        Card(
          elevation: 6,
          margin: const EdgeInsets.all(10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Icon(Icons.star, color: Colors.red, size: 40),
                const SizedBox(height: 8),
                const Text('Custom Card Content', style: TextStyle(fontWeight: FontWeight.bold)),
                const Text('You can put any widget inside a Card.'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ---------- 2. ListView.builder Demo ----------
class _ListViewDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: 20,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Icon(Icons.book, color: Colors.red),
          title: Text('Lecture $index'),
          subtitle: Text('Generated on day ${index + 1}'),
          trailing: const Icon(Icons.arrow_forward, color: Colors.red),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Opened Lecture $index')),
            );
          },
        );
      },
    );
  }
}

// ---------- 3. GridView Demo (GridView.count) ----------
class _GridViewDemo extends StatelessWidget {
  final List<Color> colors = [
    Colors.red.shade100,
    Colors.red.shade200,
    Colors.red.shade300,
    Colors.red.shade400,
    Colors.red.shade500,
    Colors.red.shade600,
    Colors.red.shade700,
    Colors.red.shade800,
    Colors.red.shade900,
  ];
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2, // 2 columns
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      padding: const EdgeInsets.all(16),
      children: List.generate(12, (index) {
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          color: colors[index % colors.length],
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.grid_on, size: 40, color: Colors.red.shade800),
                const SizedBox(height: 8),
                Text('Item $index', style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        );
      }),
    );
  }
}

// ---------- 4. Stack Demo ----------
class _StackDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background container
          Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              color: Colors.red.shade100,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.red.shade200, blurRadius: 10)],
            ),
          ),
          // Middle container
          Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              color: Colors.red.shade300,
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Center(
              child: Text(
                'Middle',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
          // Top positioned widget
          Positioned(
            top: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [BoxShadow(color: Colors.red.shade400, blurRadius: 5)],
              ),
              child: const Icon(Icons.favorite, color: Colors.red, size: 30),
            ),
          ),
          // Bottom positioned widget
          const Positioned(
            bottom: 20,
            left: 20,
            child: Icon(Icons.star, color: Colors.white, size: 30),
          ),
          // Text overlay
          const Positioned(
            bottom: 50,
            child: Text(
              'Stack with Positioned',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------- 5. Slivers Demo (CustomScrollView) ----------
class _SliversDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // SliverAppBar with floating and expanded height
        SliverAppBar(
          expandedHeight: 120,
          floating: true,
          pinned: true,
          backgroundColor: Colors.red.shade700,
          flexibleSpace: FlexibleSpaceBar(
            title: const Text('Sliver Demo'),
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.red.shade700, Colors.red.shade300],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
        ),
        // SliverList
        SliverList(
          delegate: SliverChildBuilderDelegate(
                (context, index) => ListTile(
              leading: const Icon(Icons.list, color: Colors.red),
              title: Text('List Item $index'),
              subtitle: Text('This is a sliver list item'),
              onTap: () {},
            ),
            childCount: 15,
          ),
        ),
        // SliverGrid
        SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          delegate: SliverChildBuilderDelegate(
                (context, index) => Card(
              color: Colors.red.shade100,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.grid_on, color: Colors.red.shade700),
                    Text('Grid $index'),
                  ],
                ),
              ),
            ),
            childCount: 8,
          ),
        ),
        // Another SliverList as footer
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverToBoxAdapter(
            child: Center(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Load More'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}