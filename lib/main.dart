import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Hooks Demo',
      home: MyHomePageHook(),
    );
  }
}

class MyHomePageHook extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final albumId = useState(1);
    final data = useState("");
    useMemoized(() async {
      final response = await http
          .get('https://jsonplaceholder.typicode.com/albums/${albumId.value}');

      data.value = response.body;
    }, [albumId.value]);

    useEffect(() {
      void listener() => print("Album got changed!");
      albumId.addListener(listener);

      // Remove listener during disposing the effect
      return () => albumId.removeListener(listener);
    }, [albumId.value]);

    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Hooks Demo"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Album ID: ${albumId.value}",
              style: TextStyle(color: Colors.red),
            ),
            Text(data.value),
            RaisedButton(
              child: Text("Bump"),
              onPressed: () => albumId.value++,
            )
          ],
        ),
      ),
    );
  }
}
