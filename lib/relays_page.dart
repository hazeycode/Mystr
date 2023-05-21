import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model.dart';

class RelaysPage extends StatelessWidget {
  const RelaysPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Relays'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(10.0),
        children: [
          ListView(
            padding: const EdgeInsets.all(10.0),
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            children: [
              Text(
                'Connect to...',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const _ConnectToRelayControl(),
            ],
          ),
          const Divider(),
          ListView(
            padding: const EdgeInsets.all(10.0),
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            children: [
              Text(
                'Connected Relays',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const _ConnectedRelays(),
            ],
          ),
          const Divider(),
          // TODO: recommended relays
        ],
      ),
    );
  }
}

class _ConnectToRelayControl extends StatefulWidget {
  const _ConnectToRelayControl();

  @override
  State<_ConnectToRelayControl> createState() => _ConnectToRelayControlState();
}

class _ConnectToRelayControlState extends State<_ConnectToRelayControl> {
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(10.0),
          child: TextFormField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'wss://'
            ),
            initialValue: 'wss://',
            onChanged: (value) => textController.text = value,
          ),
        ),
        ElevatedButton(
          onPressed: () =>
            setState(() => Provider.of<RelaysModel>(context, listen: false)
              .add(textController.text)),
          child: const Text('Connect'),
        ),
      ],
    );
  }
}

class _ConnectedRelays extends StatelessWidget {
  const _ConnectedRelays();

  @override
  Widget build(BuildContext context) {
    return Consumer<RelaysModel>(builder: (context, relays, child) {
      if (relays.items.isEmpty) {
        return const Text('No connected relays');
      } else {
        return ListView.builder(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          itemCount: relays.items.length,
          prototypeItem: const ListTile(
            title: Text('wss://relay.mystr.com'),
          ),
          itemBuilder: (context, index) {
            return Dismissible(
              key: UniqueKey(),
              direction: DismissDirection.endToStart,
              onDismissed: (_) =>
                Provider.of<RelaysModel>(context, listen: false)
                  .remove(relays.items[index]),
              child: ListTile(
                title: Text(relays.items[index]),
              ),
            );
          },
        );
      }
    });
  }
}