import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'credentials.dart'; // Import the credentials file
import 'injector.dart';
import 'injector_card.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PhyJet - Create Schedule',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isSimultaneousMode = true;
  bool isLoading = true;
  List<Injector> injectors = [];

  @override
  void initState() {
    super.initState();
    fetchInjectors();
  }

  Future<void> fetchInjectors() async {
    final apiUrl = API_URL; // Use the API_URL from credentials.dart

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        if (isSimultaneousMode) {
          injectors = (data['simultaneous'] as List).map((i) => Injector.fromJson(i)).toList();
        } else {
          injectors = (data['sequential'] as List).map((i) => Injector.fromJson(i)).toList();
        }
        isLoading = false;
      });
    } else {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PhyJet - Create Schedule'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ChoiceChip(
                        label: const Text('Simultaneous mode'),
                        selected: isSimultaneousMode,
                        onSelected: (selected) {
                          setState(() {
                            isSimultaneousMode = true;
                            isLoading = true;
                            fetchInjectors();
                          });
                        },
                        selectedColor: const Color.fromARGB(255, 105, 203, 108), // Added this line
                      ),
                      const SizedBox(width: 8.0),
                      ChoiceChip(
                        label: const Text('Sequential mode'),
                        selected: !isSimultaneousMode,
                        onSelected: (selected) {
                          setState(() {
                            isSimultaneousMode = false;
                            isLoading = true;
                            fetchInjectors();
                          });
                        },
                        selectedColor: Colors.green, // Added this line
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: injectors.length,
                    itemBuilder: (context, index) {
                      final injector = injectors[index];
                      return InjectorCard(
                        injectorNumber: index + 1,
                        tank: injector.device,
                        volume: injector.volume.toString(),
                        preMix: injector.preMix,
                        fertigation: injector.fertigation,
                        postMix: injector.postMix,
                        isSimultaneousMode: isSimultaneousMode,
                        mode: injector.mode, 
                      );
                    },
                  ),
                ),  
                if (!isSimultaneousMode)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text('Finish', style: TextStyle(color: Colors.black)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green, // Changed to green color
                        padding: EdgeInsets.symmetric(horizontal: 150.0), // Increased width
                      ),
                    ),
                  ),
              ],
            ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Schedule 1', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Zone 1, Zone 2', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}