// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:untitled/utils/network_util.dart';
import 'package:untitled/utils/prefs_util.dart';
import 'package:http/http.dart' as http;


void main() {
  // testWidgets('Counter increments smoke test', (WidgetTester tester) async {
  //   // Build our app and trigger a frame.
  //   await tester.pumpWidget(const MyApp());
  //
  //   // Verify that our counter starts at 0.
  //   expect(find.text('0'), findsOneWidget);
  //   expect(find.text('1'), findsNothing);
  //
  //   // Tap the '+' icon and trigger a frame.
  //   await tester.tap(find.byIcon(Icons.add));
  //   await tester.pump();
  //
  //   // Verify that our counter has incremented.
  //   expect(find.text('0'), findsNothing);
  //   expect(find.text('1'), findsOneWidget);
  // });
  //
  // // 测试dio请求
  // test("description", () async {
  //   Map params = {};
  //   params["start"] = 1;
  //   params["limit"] = 10;
  //   Response? response =
  //       await NetworkUtil.getInstance().get("role/roles", params: params);
  //   print(response?.data["data"]);
  // });
  //
  // // 测试shared_preferences
  // test("description", () async {
  //   await CommonPreferences.init();
  //   CommonPreferences.isLogin.value = true;
  //   print(CommonPreferences.isLogin.value);
  // });
  //

  // 测试http
  test("description", () async{
    var result = await NetworkUtil.getInstance().get("task/tasks?start=1");
    print(result?.data);

    var request = http.Request('GET',
        Uri.parse('http://159.138.20.163:10086/api/v1/task/tasks?start=1'));

    http.StreamedResponse response = await request.send();
    print(await response.stream.bytesToString());
  });
}
