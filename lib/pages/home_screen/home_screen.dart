import 'package:blackout_launcher/pages/home_screen/widgets/app_tile.dart';
import 'package:blackout_launcher/pages/home_screen/widgets/clock.dart';
import 'package:blackout_launcher/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final TextEditingController _controller = TextEditingController();
  List<AppInfo> applications = <AppInfo>[];


  @override
  void initState() {
    super.initState();
    getApps();
  }

  Future<List<AppInfo>> getApps() async {
    return await InstalledApps.getInstalledApps(
      true, true, 
    );
  }

  @override
  Widget build(BuildContext context) {

    Future<List<AppInfo>> applications = getApps();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (_controller.text.isEmpty) ...<Widget>[
              const ClockWidget(),
              const Spacer(),
            ]
            else
            Flexible(
              child: SizedBox(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: FutureBuilder<List<AppInfo>>(
                    future: applications, 
                    builder: (context, AsyncSnapshot<List<AppInfo>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const ListTile(
                          title: SizedBox(
                            width: 36,
                            child: CircularProgressIndicator()
                          )
                        );
                      }
                      else if (snapshot.hasData) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            for (var app in snapshot.data!
                              .where((app) => app.name
                                  .toLowerCase()
                                  .contains(_controller.text.toLowerCase()))
                              .take(5)
                              .toList()
                            )
                              AppTile(app: app),
                          ],
                        );
                      }
                      else if (snapshot.hasError) {
                        return ListTile(
                          title: Text(
                            'Could not load app data : ${snapshot.error}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )
                        );
                      }
                      else {
                        return const ListTile(
                          title: Text('Could not load app data')
                        );
                      }

                    }
                  )
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                title: TextField(
                  controller: _controller,
                  style: Theme.of(context).textTheme.bodyMedium,
                  decoration: null,
                  onChanged: (value) {
                    setState((){});
                  },
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    context.go(AppRoute.settings.path);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
