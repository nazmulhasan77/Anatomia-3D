import 'package:flutter_test/flutter_test.dart';
import 'package:anatomia3d/main.dart';
import 'package:anatomia3d/services/anatomy_data_service.dart';

void main() {
  test('AnatomyDataService contains organs, systems, and quizzes', () {
    expect(AnatomyDataService.organs.length, greaterThanOrEqualTo(8));
    expect(AnatomyDataService.bodySystems.length, greaterThanOrEqualTo(6));
    expect(AnatomyDataService.quizzes.length, greaterThanOrEqualTo(5));

    final heart = AnatomyDataService.getOrganById('heart');
    expect(heart, isNotNull);
    expect(heart!.name, 'Heart');

    final lungs = AnatomyDataService.getOrganById('lungs');
    expect(lungs, isNotNull);
    expect(lungs!.name, 'Lungs');

    final searchResults = AnatomyDataService.searchOrgans('kidney');
    expect(searchResults.any((o) => o.id == 'kidney'), isTrue);
  });

  testWidgets('Anatomia 3D App loads and renders splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const Anatomia3DApp());

    expect(find.text('Anatomia 3D'), findsOneWidget);
    expect(find.text('See it. Zoom it. Understand it.'), findsOneWidget);

    // Fast-forward past the splash timer and transition
    await tester.pump(const Duration(milliseconds: 3000));
    await tester.pumpAndSettle();

    // Verifies landing on the Home screen
    expect(find.text('Explore the Human Body'), findsOneWidget);
    expect(find.text('3D Body'), findsOneWidget);
    expect(find.text('Popular Organs'), findsOneWidget);
  });
}
