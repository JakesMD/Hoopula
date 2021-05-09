import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hoopula/pages/tabs/countdownSOTab.dart';
import 'package:hoopula/pages/tabs/firstToXHoopsTab.dart';
import 'package:hoopula/pages/tabs/timeToXHoopsTab.dart';
import 'package:hoopula/pages/tabs/timedSOTab.dart';
import 'package:hoopula/services/gameService.dart';
import 'package:hoopula/services/providers.dart';
import 'package:hoopula/widgets/actionIcon.dart';
import 'package:hoopula/widgets/animatedSwapper.dart';
import 'package:hoopula/widgets/animatedText.dart';

/// This is the main page with underlying scaffold.
class HomePage extends StatefulHookWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Used to programmatically open the drawer.
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  /// List of tabs with title and icon.
  final List<Map<String, dynamic>> _tabs = [
    {
      "title": "Timed Shoot-Out",
      "icon": Icons.speed_rounded,
      "tab": TimedSOTab()
    },
    {
      "title": "Time To X Hoops",
      "icon": Icons.timer_rounded,
      "tab": TimeToXHoopsTab()
    },
    {
      "title": "Countdown Shoot-Out",
      "icon": Icons.timelapse_rounded,
      "tab": CountdownSOTab()
    },
    {
      "title": "First To X Hoops",
      "icon": Icons.swap_horiz_rounded,
      "tab": FirstToXHoopsTab()
    },
  ];

  /// The currently displayed tab.
  int _currentTab = 0;

  @override
  Widget build(BuildContext context) {
    // Loads the GameService from the gameProvider.
    final GameService game = useProvider(gameProvider);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black,
      body: Container(
        // The background color.
        decoration: BoxDecoration(
          gradient: RadialGradient(colors: [
            Colors.blue,
            Colors.blue[900],
          ], radius: 1),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Stack(
              children: [
                Positioned.fill(
                  // Animates between the tabs.
                  child: AnimatedSwapper(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: _tabs[_currentTab]["tab"], // The current tab.
                    ),
                  ),
                ),
                Positioned.fill(
                  // A sort of custom app bar.
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // The icon that opens the drawer.
                      ActionIcon(
                        icon: Icons.menu_rounded,
                        color: Colors.white,
                        onPressed: () => _scaffoldKey.currentState.openDrawer(),
                      ),
                      // The icon that displays the bluetooth connection state.
                      ActionIcon(
                        icon: game.isBTConnected
                            ? Icons.bluetooth_connected_rounded
                            : Icons.bluetooth_searching_rounded,
                        color: game.isBTConnected ? Colors.white : Colors.red,
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: SafeArea(
          // The list of tabs.
          child: ListView.builder(
            itemCount: _tabs.length,
            itemBuilder: (context, index) => DrawerTabItem(
                title: _tabs[index]["title"],
                icon: _tabs[index]["icon"],
                onPressed: () {
                  // Animates to selected tab and closes the drawer.
                  setState(() => _currentTab = index);
                  Navigator.pop(context);
                }),
          ),
        ),
      ),
    );
  }
}

/// A ListTile representing a tab in the drawer of the [HomePage].
class DrawerTabItem extends StatelessWidget {
  /// The title of the tab.
  final String title;

  /// The icon of the tab.
  final IconData icon;

  /// Called when this item is pressed.
  final Function onPressed;

  DrawerTabItem({@required this.title, @required this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ActionIcon(
        icon: icon,
        disabledColor: Colors.orange,
      ),
      title: Row(
        children: [
          AnimatedText(
            title,
            fontSize: 18,
            color: Colors.orange,
            fontFamily: "Gruppo",
          ),
        ],
      ),
      onTap: onPressed,
    );
  }
}
