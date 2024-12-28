import 'gen/api.pb.dart';

abstract class ContainerObserver {
  void containersUpdated(List<Container> containers);
}
