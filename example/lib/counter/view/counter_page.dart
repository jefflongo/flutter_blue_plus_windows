import 'package:example/counter/counter.dart';
import 'package:example/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus_windows/flutter_blue_plus_windows.dart';

class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CounterCubit(),
      child: const CounterView(),
    );
  }
}

class CounterView extends StatelessWidget {
  const CounterView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: StreamBuilder(
          stream: WinBle.connectionStreamOf('cc:17:8a:a0:2a:18'),
          builder: (context, snapshot) {
            print(snapshot.data);
            return Text(snapshot.data.toString());
          },
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () async {
                // final result =
                //     FlutterBluePlus.scan(timeout: Duration(seconds: 4));
                // result.forEach(print);
                var subscription = FlutterBluePlus.scanResults.listen(
                  (results) {
                    for (final r in results) {
                      print('${r.device.remoteId.str} '
                          '${r.device.localName} '
                          // '==> '
                          // '${r.device} '
                          // '${r.rssi} '
                          // '${r.advertisementData} '
                          // '${r.timeStamp}',
                          );
                    }
                  },
                );

                await FlutterBluePlus.startScan(timeout: Duration(seconds: 4),allowDuplicates: false);

                await FlutterBluePlus.stopScan();
                subscription.cancel();

                // final connected = await FlutterBluePlus.turnOn();
                // print(connected);
              },
              child: const Icon(Icons.add),
            ),
            const SizedBox(height: 8),
            FloatingActionButton(
              onPressed: () async {
                final a = await WinBle.discoverServices('cc:17:8a:a0:2a:18');
                print(a);
                for(final c in a){
                  print('$c =================');
                  final b = await WinBle.discoverCharacteristics(address: 'cc:17:8a:a0:2a:18', serviceId: c);
                  for(final d in b) {
                    print(d.uuid);
                  }
                }
                // WinBle.pair('cc:17:8a:a0:2a:18');
                // WinBle.pair('cc:17:8a:a0:2a:18'.toLowerCase());
              },
              child: const Icon(Icons.remove),
            ),
            const SizedBox(height: 8),
            FloatingActionButton(
              onPressed: () async {
                await WinBle.connect('cc:17:8a:a0:2a:18'.toLowerCase());
              },
              child: const Icon(Icons.remove),
            ),
            const SizedBox(height: 8),
            FloatingActionButton(
              onPressed: () async {
                await WinBle.disconnect('cc:17:8a:a0:2a:18'.toLowerCase());
              },
              child: const Icon(Icons.remove),
            ),
          ],
        ),
      ),
    );
  }
}

