import 'package:flutter/material.dart';
import 'package:flutter_app_models/widgets/create_post.dart';

class AppHomeView extends StatefulWidget {
  const AppHomeView({Key key}) : super(key: key);

  @override
  _AppHomeViewState createState() => _AppHomeViewState();
}

class _AppHomeViewState extends State<AppHomeView>
    with TickerProviderStateMixin {


  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this, initialIndex: 0);
    tabController.addListener(handleTabSelection);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _buildBody(context)),
      bottomNavigationBar: Container(
        height: 48,
        decoration: BoxDecoration(
        ),
        child: SafeArea(
          child: _buildTabBar(context),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return TabBarView(
      physics: NeverScrollableScrollPhysics(),
      controller: tabController,
      children: <Widget>[
      ShowForm(),
      ShowForm(),
      ShowForm(),
      ShowForm(),
      ],
    );
  }

  Widget _buildTabBar(BuildContext context) {
    return TabBar(
      controller: tabController,
      tabs: <Widget>[
        Tab(
          icon: Icon(
            Icons.store,
            size: 28,
          ),
        ),
        Tab(
          icon: Icon(
            Icons.search,
            size: 28,
          ),
        ),
        Tab(
          icon: Icon(
            Icons.receipt,
            size: 28,
          ),
        ),
        Tab(
          icon: Icon(
            Icons.person,
            size: 28,
          ),
        )
      ],
      indicatorColor: Colors.transparent,
      unselectedLabelColor: Colors.black54,
      labelColor: Colors.red,
    );
  }

  void handleTabSelection() {
    setState(() {});
  }
}