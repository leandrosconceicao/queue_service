import 'dart:async';

import 'package:queue_service/models/attendants.dart';

StreamController attendants = StreamController<Attendants?>.broadcast();