import 'package:baby_f_words/big_button.dart';
import 'package:baby_f_words/managers/app_config.dart';

///THIS IS A MANAGER CLASS TO MAINTAIN DATA DURING THE SOFTWARE RUN

class DataManager {
  AppFlavor flavor = AppFlavor.prod;
  List<BigButton> bigButtonList = [];
}
