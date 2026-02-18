import 'package:get/get.dart';
import '../controllers/receipts_controller.dart';

class ReceiptsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReceiptsController>(() => ReceiptsController());
  }
}
