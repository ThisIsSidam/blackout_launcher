import 'package:blackout_launcher/constants/assets.dart';
import 'package:blackout_launcher/pages/utils/clock.dart';
import 'package:flutter/material.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

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
      backgroundColor: Colors.grey[850],
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
                              _buildAppTile(app),
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
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                style: Theme.of(context).textTheme.bodyMedium,
                onChanged: (value) {
                  setState((){});
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppTile(AppInfo app) {
    return ListTile(
      leading: ConstrainedBox(
        constraints: const BoxConstraints(
          maxHeight: 24, 
          minWidth: 24
        ),
        child: app.icon != null
        ? Image.memory(app.icon!)
        : Image.asset(Images.defaultIcon.path)
      ),
      title: Text(
        app.name,
        style: Theme.of(context).textTheme.bodySmall,
      ),
      onTap: () => InstalledApps.startApp(app.packageName),
    );
  }

}
