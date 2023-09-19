import 'package:allergyalert/model/appwrite_sevices.dart';
import 'package:allergyalert/model/log_out.dart';
import 'package:allergyalert/screens/AuthUI/screens/auth.dart';
import 'package:allergyalert/screens/auth_checker.dart';
import 'package:allergyalert/screens/settings/allergies_add_page.dart';
import 'package:allergyalert/screens/settings/history_barcode.dart';
import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

// warning_amber_rounded

class _SettingPageState extends State<SettingPage>
    with TickerProviderStateMixin {
  final TextEditingController _allergiesController = TextEditingController();
  late TabController _tabController;

  String databaseId = '64a82fa507ff7e0dc894';
  String collectionId = '64a82fac21de54a2ac35';

  List<String> suggetAllegies = [
    // Allergy suggestions here
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _allergiesController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _logOut() async {
    await account
        .deleteSession(sessionId: 'current')
        .then(
          (value) => {
            print('You have logout of hte account'),
          },
        )
        .then(
          (value) => {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const AuthCheckerScreen(),
              ),
            )
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                height: 40,
              ),
              Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom:
                        BorderSide(color: Colors.white), // Bottom line color
                  ),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicatorColor: Colors.blue, // Indicator line color
                  labelColor: Colors.blue, // Color of the selected tab label
                  unselectedLabelColor:
                      Colors.black, // Color of the unselected tab labels
                  tabs: const [
                    Tab(
                      child: Padding(
                        padding: EdgeInsets.all(8.0), // Add padding to the tab
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.warning_amber_rounded,
                                color: Colors
                                    .blue), // Custom icon from Icons class
                            SizedBox(
                                width: 8), // Add spacing between icon and text
                            Text('Allergies'),
                          ],
                        ),
                      ),
                    ),
                    Tab(
                      child: Padding(
                        padding: EdgeInsets.all(8.0), // Add padding to the tab
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.history,
                                color: Colors
                                    .blue), // Custom icon from Icons class
                            SizedBox(
                                width: 8), // Add spacing between icon and text
                            Text('History'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    AllergiesPage(),
                    HistoryPage(),
                  ],
                ),
              ),
            ],
          ),
          LogoutButton(
            onPressed: () {
              _logOut();
            },
          )
        ],
      ),
    );
  }
}
