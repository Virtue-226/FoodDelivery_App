import 'package:flutter/material.dart';
import 'package:fooddelivery_app/src/Pages/sign_in_page.dart';
import 'package:fooddelivery_app/src/Scoped_model/food_model.dart';
import 'package:fooddelivery_app/src/Scoped_model/main_model.dart';
import 'package:fooddelivery_app/src/admin/pages/add_food_items.dart';
import 'package:scoped_model/scoped_model.dart';

//Pages
import '../Pages/home_page.dart';
import '../Pages/order_page.dart';
import '../Pages/explore_page.dart';
import '../Pages/profile_Page.dart';

class MainScreen extends StatefulWidget {
  final MainModel model;
  MainScreen({this.model});
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentTabIndex = 0;
  List<Widget> pages;
  Widget currentPage;

  HomePage homepage;
  OrderPage orderpage;
  FavoritePage favouritepage;
  ProfilePage profilePage;

  @override
  void initState() {
    //TODO: implement initState
    super.initState();
    //call the fetch method in food
    widget.model.fetchAll();
    // widget.model.fetchFoods();
    homepage = HomePage();
    orderpage = OrderPage();
    favouritepage = FavoritePage(model: widget.model);
    profilePage = ProfilePage();
    pages = [homepage, favouritepage, orderpage, profilePage];
    currentPage = homepage;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.black),
            title: Text(
              currentTabIndex == 0
                  ? "Food App"
                  : currentTabIndex == 1
                      ? "All Food Items"
                      : currentTabIndex == 2
                          ? "Orders "
                          : "Profile ",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.notifications_none,
                  // size: 30.0,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              currentTabIndex == 3
                  ? ScopedModelDescendant(builder:
                      (BuildContext context, Widget child, MainModel model) {
                      return IconButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        SignInPage()));
                            model.logout();
                          },
                          icon: Icon(
                            Icons.logout,
                          ));
                    })
                  : IconButton(
                      onPressed: () {},
                      icon: _buildShoppingCart(),
                    )
            ]),
        drawer: Drawer(
            child: Column(
          children: <Widget>[
            ListTile(
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => AddFoodItem()));
                },
                leading: Icon(Icons.list),
                title: Text("Add Food Items",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15.0))),
          ],
        )),
        bottomNavigationBar: BottomNavigationBar(
            onTap: (int index) {
              setState(() {
                currentTabIndex = index;
                currentPage = pages[index];
              });
            },
            currentIndex: currentTabIndex,
            type: BottomNavigationBarType.fixed,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                title: Text("Home"),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.explore),
                title: Text("Explore"),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart),
                title: Text("Orders"),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                title: Text("Profile"),
              ),
            ]),
        body: currentPage,
      ),
    );
  }

  Widget _buildShoppingCart() {
    return Stack(
      children: [
        Icon(
          Icons.shopping_cart,
          // size: 30.0,
          color: Theme.of(context).primaryColor,
        ),
        Positioned(
          top: 0.0,
          right: 0.0,
          child: Container(
            height: 12.0,
            width: 12.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.0), color: Colors.red),
            child: Center(child: ScopedModelDescendant(
              builder: (BuildContext context, Widget child, MainModel model) {
                return Text(
                  "${model.foodleng}",
                  style: TextStyle(color: Colors.white, fontSize: 14.0),
                );
              },
            )),
          ),
        ),
      ],
    );
  }
}
