import 'package:persona_app/router/app_router.dart';

class PathParameters {
  final RootTab rootTab;

  PathParameters({
    this.rootTab = RootTab.splash,
  });

  Map<String, String> toMap() {
    return {
      'root_tab': rootTab.value,
    };
  }
}