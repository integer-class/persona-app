part of 'package:Persona/router/app_router.dart';

enum RootTab {
  login('1'),
  upload('2'),
  signup('3'),
  genderSelection('4'),
  edit('5'),
  profile('6'),
  onboarding('7'),
  history('8'),
  accessories('9'),
  glasses('10'),
  hairstyle('11'),
  feedback('12'),
  historyDetail('13');

  final String value;
  const RootTab(this.value);

  factory RootTab.fromIndex(int index) {
    return values.firstWhere(
      (value) => value.value == '$index',
      orElse: () => RootTab.onboarding,
    );
  }
}