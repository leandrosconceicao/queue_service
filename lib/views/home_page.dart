import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:queue_service/controllers/api.dart';
import 'package:queue_service/models/api_responses.dart';
import 'package:queue_service/models/app_controller.dart';
import 'package:queue_service/utils/printer_services/device_manager.dart';
import 'package:queue_service/utils/printer_services/printer_service.dart';
import 'package:queue_service/views/components/custom_snackbar.dart';
import '../models/queue.dart';

enum Gif { info, alert, help }

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final isLoading = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Fila de atendimento'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: Obx(
        () => FloatingActionButton(
          backgroundColor: Colors.red,
          onPressed: isLoading.value
              ? null
              : () async {
                  Get.dialog(
                      barrierDismissible: false,
                      AlertDialog(
                        content: Text(
                          'Atenção! Confirma a exclusão das senhas geradas? Operação não pode ser desfeita!',
                          style: Get.textTheme.headline4,
                        ),
                        actions: [
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: Get.height * 0.06,
                                  child: Obx(
                                    () => ElevatedButton(
                                        onPressed: isLoading.value ? null : () async {
                                          isLoading.value = true;
                                          await QueueService.clearQueue(() {});
                                          isLoading.value = false;
                                          Get.back();
                                        },
                                        child: const Text('Confirmar')),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: SizedBox(
                                  height: Get.height * 0.06,
                                  child: TextButton(
                                    onPressed: () => Get.back(),
                                    child: const Text('Cancelar'),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ));
                },
          tooltip: 'Limpar fila',
          child: const Icon(Icons.clear),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Obx(() => Visibility(
                visible: isLoading.value,
                child: const LinearProgressIndicator())),
            Expanded(
              child: Card(child: queueStream()),
            ),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: Get.height * 0.15,
                    child: TextButton(
                      onPressed: () {
                        Get.dialog(
                          barrierDismissible: false,
                          AlertDialog(
                            scrollable: true,
                            title: const Text('Selecione a impressora'),
                            contentPadding: EdgeInsets.zero,
                            content: StreamBuilder(
                                stream: Devices.bloc.stream,
                                builder: (context, AsyncSnapshot snapshot) {
                                  if (!snapshot.hasData) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  } else {
                                    ApiRes r = snapshot.data;
                                    if (!r.result) {
                                      return Center(child: Text(r.message));
                                    } else {
                                      List<BluetoothInfo> devices = r.data;
                                      if (devices.isEmpty) {
                                        return const Center(
                                            child: Text(
                                                'Nenhum dispositivo encontrado'));
                                      } else {
                                        return Column(
                                          children: devices
                                              .map(
                                                (e) => Obx(
                                                  () => RadioListTile(
                                                    controlAffinity:
                                                        ListTileControlAffinity
                                                            .leading,
                                                    groupValue: appCon
                                                        .selectedPrinter.value,
                                                    value: e,
                                                    title: Text(e.name),
                                                    subtitle: Text(e.macAdress),
                                                    onChanged: (value) {
                                                      appCon.selectedPrinter
                                                          .value = value;
                                                    },
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                        );
                                      }
                                    }
                                  }
                                }),
                            actionsAlignment: MainAxisAlignment.center,
                            actions: [
                              Row(
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      height: Get.height * 0.06,
                                      child: Obx(() => ElevatedButton(
                                          onPressed:
                                              appCon.selectedPrinter.value ==
                                                      null
                                                  ? null
                                                  : () async {
                                                    Get.dialog(
                                                      const Center(child: CircularProgressIndicator())
                                                    );
                                                    final r = await Devices.connect();
                                                    Get.back();
                                                    if (!r.result) {
                                                      appCon.selectedPrinter.value = null;
                                                      Get.showSnackbar(appSnackBar(r.message));
                                                    } else {
                                                      Get.back();
                                                    }
                                                  },
                                          child: const Text('Conectar'))),
                                    ),
                                  ),
                                  SizedBox(
                                    width: Get.width * 0.01,
                                  ),
                                  Expanded(
                                    child: SizedBox(
                                        height: Get.height * 0.06,
                                        child: TextButton(
                                            onPressed: () => Get.back(),
                                            child: const Text('Cancelar'))),
                                  )
                                ],
                              )
                            ],
                          ),
                        );
                        Devices.loadPrinters();
                      },
                      child: Icon(
                        Icons.settings,
                        size: Get.height * 0.06,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: Get.width * 0.03,
                ),
                Expanded(
                  child: SizedBox(
                    height: Get.height * 0.15,
                    child: Obx(
                      () => ElevatedButton(
                          onPressed: isLoading.value
                              ? null
                              : () async {
                                  isLoading.value = true;
                                  await QueueService.loadNext(() {
                                    Get.showSnackbar(appSnackBar('Não foi possível imprimir a senha'));
                                  });
                                  isLoading.value = false;
                                },
                          child: Text(
                            'Gerar senha',
                            style: TextStyle(
                              fontSize: Get.height * 0.025,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                    ),
                  ),
                ),
              ],
            )
            // Expanded(
            //   child: Card(child: lastCalls()),
            // ),
          ],
        ),
      ),
    );
  }

  StreamBuilder lastCalls() {
    return StreamBuilder(
      stream: QueueService.lastCallsbloc.stream,
      builder: (context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(
              child: Text(
                'Aguardando dados',
                style: Get.textTheme.headline4,
                textAlign: TextAlign.center,
              ),
            );
          default:
            if (!snapshot.hasData) {
              return const SizedBox();
            } else {
              ApiRes<List<Queue?>?> r = snapshot.data;
              if (!r.result) {
                return Center(child: Text(r.message));
              } else {
                return ListView.builder(
                  itemCount: r.data?.length ?? 0,
                  itemBuilder: (context, int i) {
                    Queue queue = r.data![i]!;
                    return Center(
                        child: Text(
                      queue.position.toString(),
                    ));
                  },
                );
              }
            }
        }
      },
    );
  }

  StreamBuilder queueStream() {
    return StreamBuilder(
      stream: QueueService.bloc.stream,
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(child: infoText('Acione o botão para\ngerar a senha'));
        } else {
          ApiRes<List<Queue?>?> r = snapshot.data;
          if (!r.result) {
            return Center(child: infoText(r.message));
          } else {
            // clearQueueIsEnabled.value = r.data?.isNotEmpty ?? false;
            return Center(
                child: infoText('${r.data?.first?.position ?? 0}',
                    style: TextStyle(fontSize: Get.height * 0.2)));
          }
        }
      },
    );
  }

  Text infoText(String message, {TextStyle? style}) {
    return Text(
      message,
      style: style ?? Get.textTheme.headline4,
      textAlign: TextAlign.center,
    );
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

  Widget buildGif(double height, Gif gif) {
    return SizedBox(height: Get.height * 0.09, child: Image.asset(setGif(gif)));
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
