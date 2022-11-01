import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'dart:math' as math;

import '../controllers/connection.dart';
import '../models/attendants.dart';

enum Gif { info, alert, help }

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final lastQueue = StreamController<List<Attendants>?>.broadcast();
  final List<Attendants> dt = [];
  final List<Attendants> lasts = [];

  @override
  Widget build(BuildContext context) {
    initiateSock();
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Atendimentos'),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     attendants.add(Attendants(
      //       branch: '0101',
      //       code: 'fasdfa',
      //       datetime: '',
      //       serviceDesk: '01',
      //       userCode: '009137'
      //     ));
      //     dt.add(getQueueNumber());
      //     queue.add(dt.reversed);
      //   },
      //   child: const Icon(Icons.add),
      // ),
      body: Row(
        children: [
          Expanded(
            child: Card(
              child: SizedBox(
                height: height * 0.89,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text('Últimas senhas',
                          style: TextStyle(
                              fontSize: width * 0.028,
                              fontWeight: FontWeight.bold)),
                    ),
                    Expanded(
                      child: StreamBuilder<List<Attendants>?>(
                        initialData: const [],
                        stream: lastQueue.stream,
                        builder: (context,
                            AsyncSnapshot<List<Attendants>?> snapshot) {
                          return ListView.separated(
                            separatorBuilder: (context, _) => const Divider(),
                            itemCount: snapshot.data!.length > 3
                                ? 3
                                : snapshot.data!.length,
                            itemBuilder: (context, int i) {
                              return queueCard(
                                context,
                                attendant: snapshot.data![i],
                              );
                            },
                          );
                        },
                      ),
                    ),
                    StreamBuilder(
                      initialData: 0,
                      stream: Stream.periodic(const Duration(seconds: 1)),
                      builder: (context, AsyncSnapshot snapshot) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Text(
                            DateFormat('dd/MM/yyyy HH:mm')
                                .format(DateTime.now()),
                            style: Theme.of(context).textTheme.headline3,
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Card(
              child: SizedBox(
                height: height * 0.89,
                child: StreamBuilder(
                    stream: Connection.channel.stream,
                    builder: (context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData) {
                        return waitingWidget(context);
                      } else if (snapshot.data == "") {
                        return waitingWidget(context);
                      } else {
                        Attendants? att = Attendants.fromJson(
                            Attendants.jsonify(snapshot.data));
                        // AudioService.playNotification();
                        return GestureDetector(
                          onTap: () {
                            lasts.add(att);
                            lastQueue.add(lasts.reversed.toList());
                            Connection.addMessage(null);
                          },
                          child: onCallQueueCard(context, attendants: att),
                        );
                      }
                    }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void initiateSock() {
    Connection.channel;
  }

  Widget waitingWidget(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildGif(height, Gif.info),
          Text(
            'Aguardando atendimentos',
            style: Theme.of(context).textTheme.headline2,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String getQueueNumber() => math.Random.secure().nextInt(10).toString();

  Widget queueCard(BuildContext context, {required Attendants attendant}) {
    double width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Text(
          attendant.code!,
          style:
              TextStyle(fontSize: width * 0.045, fontWeight: FontWeight.bold),
        ),
        Text(
          'Balcão: ${attendant.serviceDesk}',
          style: Theme.of(context).textTheme.headline5,
        )
      ],
    );
  }

  Widget onCallQueueCard(
    BuildContext context, {
    required Attendants attendants,
  }) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildGif(height, Gif.alert),
        Text(
          'Senha ${attendants.code}\npor favor dirija-se ao:',
          style:
              TextStyle(fontSize: width * 0.045, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        Text(
          'Balcão ${attendants.serviceDesk}',
          style: TextStyle(
              fontSize: width * 0.045,
              fontWeight: FontWeight.bold,
              color: Colors.red),
          textAlign: TextAlign.center,
        )
      ],
    );
  }

  Widget buildGif(double height, Gif gif) {
    return SizedBox(height: height * 0.09, child: Image.asset(setGif(gif)));
  }

  String setGif(Gif gif) {
    switch (gif) {
      case Gif.info:
        return 'images/info.gif';
      case Gif.alert:
        return 'images/alert.gif';
      case Gif.help:
        return 'images/help.gif';
    }
  }
}
