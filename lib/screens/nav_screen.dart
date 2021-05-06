import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_models/widgets/create_post.dart';
import 'package:flutter_app_models/widgets/drawer_show.dart';
import 'package:flutter_app_models/widgets/post_screen.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';


bool isVisible  = false;
class NavScreen extends StatefulWidget {
  const NavScreen({Key key}) : super(key: key);
  static const navRoute = '/navScreen';

  @override
  _NavScreenState createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen>  {

  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  int _currentIndex = 0;
  List<Widget> _pages = [
    PostScreen(),
    ShowForm(),
    PostScreen(),

  ];
void onItemTap(int index){
  if(index == 3){
_drawerKey.currentState.openDrawer();
  }else{
    setState(() {
      _currentIndex = index;
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
        drawer: DrawerShow(),
        body: PageTransitionSwitcher(
            duration: Duration(seconds: 1),
            transitionBuilder: (child,
                animation,
                secondaryAnimation) => SharedAxisTransition(
                child: child,
                animation: animation,
                secondaryAnimation: secondaryAnimation,
                transitionType: SharedAxisTransitionType.horizontal
            ),
            child: _pages[_currentIndex]
        ),
      bottomNavigationBar: Visibility(
        child: KeyboardVisibilityBuilder(
          builder: (context, visible) => Visibility(
            visible: visible ? false : true,
            child: BottomNavigationBar(
                      currentIndex: _currentIndex,
                      onTap: onItemTap,
                      selectedItemColor: Colors.black,
                      unselectedItemColor: Colors.black26,
                      items: [
                        BottomNavigationBarItem(
                            icon: Icon(Icons.home), label: 'Home'),
                        BottomNavigationBarItem(
                            icon: Icon(Icons.add), label: 'Add Post'),
                        BottomNavigationBarItem(
                            icon: Icon(Icons.photo), label: 'Gallery'),
                        BottomNavigationBarItem(
                            icon: Icon(Icons.menu), label: 'Menu'),
                      ]
            ),
          ),
        ),
      )
    );
  }
}
