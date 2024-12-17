import 'package:Persona/router/app_router.dart';

class PathParameters {
  final RootTab rootTab;

  PathParameters({
    this.rootTab = RootTab.onboarding,
  });

  Map<String, String> toMap() {
    return {
      'root_tab': rootTab.value,
    };
  }
}