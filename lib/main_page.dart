import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nostr/nostr.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'model.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

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
      body: const _FeedView(),
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

class _FeedView extends StatefulWidget {
  const _FeedView();

  @override
  State<_FeedView> createState() => _FeedViewState();
}

class _FeedViewState extends State<_FeedView> {
  final List<Event> events = [];
  WebSocketChannel? channel; // TODO: support multiple relays

  @override
  void didChangeDependencies() {
    channel?.sink.close();
    channel = null;
    if (Provider.of<RelaysModel>(context).items.isNotEmpty) {
      channel = WebSocketChannel.connect(
        Uri.parse(Provider.of<RelaysModel>(context).items[0]) // TODO: support multiple relays
      );
      channel?.sink.add(
        Request(generate64RandomHexChars(), [
          Filter(kinds: [1],
          since: currentUnixTimestampSeconds()),
        ]).serialize(),
      );
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // TODO: support multiple relays
    channel?.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RelaysModel>(builder: (context, relays, child) {
      return StreamBuilder(
        stream: channel?.stream,
        builder: (context, snapshot) {
          if (channel == null) {
            return const Center(child: Text('Goto settings to add relays'));
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (snapshot.hasData == false) {
            return const Center(child: CircularProgressIndicator());
          }
          try {
            Message msg = Message.deserialize(snapshot.data);
            if (msg.type == "EVENT") {
              Event event = msg.message;
              events.add(event);
              events.sort((a, b) => b.createdAt.compareTo(a.createdAt));
            }
          } catch (e) {
            print('Failed to deserialise message with exception: $e');
          }
          return ListView.builder(
            shrinkWrap: true,
            itemCount: events.length,
            itemBuilder: (context, index) => _FeedNoteWidget(
              avatar: '',
              pubkey: events[index].pubkey,
              timestamp: events[index].createdAt,
              text: events[index].content,
            ),
          );
        },
      );
    });
  }
}

class _FeedNoteWidget extends StatelessWidget {
  final String avatar;
  final String pubkey;
  final int timestamp;
  final String text;

  const _FeedNoteWidget({
    required this.avatar,
    required this.pubkey,
    required this.timestamp,
    required this.text,
  });

  String formatDate(int secondsUnixTimestamp) {
    var date = DateTime
        .fromMillisecondsSinceEpoch(secondsUnixTimestamp * 1000, isUtc: true)
        .toLocal()
        .toString();
    return date.substring(0, date.length - 4);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                margin: const EdgeInsets.all(10.0),
                child: const Placeholder(), // TODO: draw senders profile image here instead
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 5.0),
                              child: Text(pubkey.substring(0, 8))
                            ),
                            Text(formatDate(timestamp)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SelectableText(text),
                  ],
                ),
              )
            ],
          ),
        ),
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
            title: const Text('Bobby Zapper'),
            subtitle: const Text('@bobbyzapper'),
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
