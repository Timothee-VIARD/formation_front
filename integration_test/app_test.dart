import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formation_front/app/widgets/home_view.dart';
import 'package:formation_front/main.dart';
import 'package:formation_front/modules/meetings/meetings_page.dart';
import 'package:formation_front/modules/rooms/rooms_page.dart';
import 'package:formation_front/modules/users/users_page.dart';
import 'package:formation_front/utils/date_time/date_time.dart';
import 'package:http/http.dart' as http;
import 'package:integration_test/integration_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'app_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  late MockClient mockClient;

  setUpAll(() {
    mockClient = MockClient();
    when(mockClient.post(
      Uri.parse('http://localhost:8008/login'),
      headers: anyNamed('headers'),
      body: {"username": "roger", "password": "roger"},
    )).thenAnswer((_) async {
      return http.Response(
          json.encode({'access_token': 'mockToken', 'token_type': 'Bearer'}),
          200);
    });

    when(mockClient.get(
      Uri.parse('http://localhost:8008/utilisateurs/'),
      headers: anyNamed('headers'),
    )).thenAnswer((_) async {
      return http.Response(
          json.encode([
            {"id": -1, "name": "roger", "email": "roger", "is_active": true}
          ]),
          200);
    });

    when(mockClient.get(
      Uri.parse('http://localhost:8008/salles'),
      headers: anyNamed('headers'),
    )).thenAnswer((_) async {
      return http.Response(
          json.encode([
            {"name": "room", "nb_max": 0, "id": 0}
          ]),
          200);
    });

    when(mockClient.get(
      Uri.parse('http://localhost:8008/reunions/'),
      headers: anyNamed('headers'),
    )).thenAnswer((_) async {
      return http.Response(
          json.encode([
            {
              "people_nb": 0,
              "horaire": DateTime.now().add(Duration(days: 1)).toString(),
              "duree": 0,
              "id": 0,
              "salle_id": 0,
              "user": "roger"
            }
          ]),
          200);
    });
  });

  group('Login tests', () {
    testWidgets('login successful', (tester) async {
      await tester.pumpWidget(MyApp(client: mockClient));

      await tester.enterText(find.byType(TextFormField).at(0), 'roger');
      await tester.enterText(find.byType(TextFormField).at(1), 'roger');

      await tester.tap(find.byType(ElevatedButton));

      await tester.pumpAndSettle();

      expect(find.byType(NavigationHome), findsOneWidget);

      expect(find.byType(SnackBar), findsOneWidget);
      final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
      expect(snackBar.backgroundColor, Colors.green);
      expect((snackBar.content as Text).data, 'Login successful');
    });

    testWidgets('login failed', (tester) async {
      when(mockClient.post(
        Uri.parse('http://localhost:8008/login'),
        headers: anyNamed('headers'),
        body: {"username": "notroger", "password": "notroger"},
      )).thenAnswer((_) async => http.Response(
          json.encode({'detail': 'Identifiants non reconnus'}), 400));

      await tester.pumpWidget(MyApp(client: mockClient));

      await tester.enterText(find.byType(TextFormField).at(0), 'notroger');
      await tester.enterText(find.byType(TextFormField).at(1), 'notroger');

      await tester.tap(find.byType(ElevatedButton));

      await tester.pumpAndSettle();

      expect(find.byType(NavigationHome), findsNothing);

      expect(find.byType(SnackBar), findsOneWidget);
      final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
      expect(snackBar.backgroundColor, Colors.red);
      expect((snackBar.content as Text).data,
          'Exception: Identifiants non reconnus');
    });
  });

  group('Home navigation tests', () {
    Future<void> setUpConnectedApp(WidgetTester tester) async {
      await tester.pumpWidget(MyApp(client: mockClient));

      await tester.enterText(find.byType(TextFormField).at(0), 'roger');
      await tester.enterText(find.byType(TextFormField).at(1), 'roger');

      await tester.tap(find.byType(ElevatedButton));

      await tester.pumpAndSettle();

      expect(find.byType(NavigationHome), findsOneWidget);
    }

    testWidgets('navigate to users', (tester) async {
      await setUpConnectedApp(tester);

      await tester.tap(find.byType(ElevatedButton).at(0));

      await tester.pumpAndSettle();

      expect(find.byType(UsersPage), findsOneWidget);
      expect(find.text('roger'), findsExactly(2));
    });

    testWidgets('navigate to rooms', (tester) async {
      await setUpConnectedApp(tester);

      await tester.tap(find.byType(ElevatedButton).at(1));

      await tester.pumpAndSettle();

      expect(find.byType(RoomsPage), findsOneWidget);
      expect(find.text('0'), findsExactly(2));
      expect(find.text('room'), findsOneWidget);
    });

    testWidgets('navigate to meetings', (tester) async {
      await setUpConnectedApp(tester);

      await tester.tap(find.byType(ElevatedButton).at(2));

      await tester.pumpAndSettle();

      expect(find.byType(MeetingsPage), findsOneWidget);
      final tomorrow = DateTime.now().add(Duration(days: 1));
      expect(find.text(DateTimeUtils.getDateOnly(tomorrow)), findsOneWidget);
    });
  });
}
