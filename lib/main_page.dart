import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  MainPage({super.key});

  final List<String> items = List<String>.generate(1000, (i) => 'Item $i');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Mystr'), // TODO: Mystr ident image
        centerTitle: true,
        actions: <Widget>[
          Builder(builder: (context) {
            return IconButton(
              onPressed: () => Scaffold.of(context).openEndDrawer(),
              icon: const Icon(
                Icons.account_circle, // TODO: draw profile image here instead
                size: 40.0,
              ),
            );
          })
        ]
      ),
      endDrawer: _SettingsPanel(),
      body: ListView.builder(
        itemCount: items.length,
        prototypeItem: ListTile(
          title: Text(items.first),
        ),
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(items[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          // TODO: display new post widget
        },
        tooltip: 'New post...',
        shape: const CircleBorder(),
        child: const Icon(Icons.message),
      ),
    );
  }
}

class _SettingsPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const LinearBorder(),
      child: ListView(
        children: [
          ListTile(
            leading: const Icon(
              Icons.account_circle, // TODO: draw profile image here instead
              size: 40.0,
            ),
            title: Text('Bobby Zapper'),
            subtitle: Text('@bobbyzapper'),
            onTap: () => Navigator.pushNamed(context, '/profile'),
          ),
          ListTile(
            title: const Text('Relays'),
            onTap: () => Navigator.pushNamed(context, '/relays'),
          ),
        ],
      ),
    );
  }
}
