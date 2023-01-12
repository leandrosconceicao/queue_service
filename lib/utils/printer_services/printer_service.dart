import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

import '../../models/queue.dart';

class PrinterService {
  static Future<void> printQueue(Queue data, Function callbackIfError) async {
    try {
      final gen = Generator(PaperSize.mm80, await CapabilityProfile.load());
      List<int> bytes = [];
      bytes += gen.text('${data.date}', styles: _style());
      bytes += gen.emptyLines(1);
      bytes += gen.text('${data.position}', styles: _style());
      
      bytes += gen.cut();
      
      bytes += gen.text('${data.date}', styles: _style());
      bytes += gen.emptyLines(1);
      bytes += gen.text('${data.position}', styles: _style());
      bytes += gen.cut();
      await PrintBluetoothThermal.writeBytes(bytes);
    } catch (e) {
      callbackIfError();
    }
  }

  static PosStyles _style() {
    return const PosStyles(
        align: PosAlign.center,
        bold: true,
        height: PosTextSize.size2,
        width: PosTextSize.size2
      );
  }
}
