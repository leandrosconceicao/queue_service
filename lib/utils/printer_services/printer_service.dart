import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:queue_service/tools/date_functions.dart';

import '../../models/queue.dart';

class PrinterService {
  static Future<void> printQueue(Queue data, Function callbackIfError) async {
    try {
      final gen = Generator(PaperSize.mm58, await CapabilityProfile.load());
      List<int> bytes = [];
      bytes += gen.row(
          [PosColumn(width: 12, text: FormatDate.standard(data.date ?? ''))]);
      _emptyLine(bytes, 2, gen);
      _genText(gen, '${data.position ?? 0}', bytes);
      _emptyLine(bytes, 2, gen);
      bytes += gen.feed(1);
      bytes += gen.cut();
      await PrintBluetoothThermal.writeBytes(bytes);
    } catch (e) {
      callbackIfError();
    }
  }

  static void _emptyLine(List<int> bytes, int lines, Generator gen) async {
    bytes += gen.emptyLines(lines);
  }

  static void _genText(Generator gen, String text, List<int> bytes) {
    bytes += gen.text(
      text,
      styles: const PosStyles(
        align: PosAlign.center,
        bold: true,
        height: PosTextSize.size8,
      ),
    );
  }
}
