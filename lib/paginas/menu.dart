import 'package:flutter/material.dart';

enum Options { Add, Edit, Delete, Thankyou }

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var appBarHeight = AppBar().preferredSize.height;
  String selected = "Home Page";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Text("Home Popup Menu"),
        elevation: 0,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: CircleAvatar(
                backgroundColor: Colors.cyanAccent,
                child: PopupMenuButton(
                  icon: Icon(Icons.more_vert_rounded),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  )),
                  offset: Offset(0.0, appBarHeight),
                  itemBuilder: (ctx) => [
                    _buildPopupMenuItem("Add", Icons.add, Options.Add.index),
                    _buildPopupMenuItem("Edit", Icons.edit, Options.Edit.index),
                    _buildPopupMenuItem(
                        "Delete", Icons.remove_circle, Options.Delete.index),
                    _buildPopupMenuItem("Thankyou", Icons.remove_circle,
                        Options.Thankyou.index),
                  ],
                  onSelected: (value) {
                    _onSelectedItem(value as int);
                  },
                )),
          )
        ],
      ),
      body: Column(
        children: [
          Center(
            child: Text(selected, style: TextStyle(fontSize: 40)),
          )
        ],
      ),
    );
  }

  PopupMenuItem _buildPopupMenuItem(
      String title, IconData iconData, int position) {
    return PopupMenuItem(
      value: position,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
              padding: EdgeInsets.all(10),
              child: Icon(iconData, color: Colors.black)),
          Text(title),
        ],
      ),
    );
  }

  _onSelectedItem(int value) {
    if (value == Options.Add.index) {
      print("Add Menu Click");
      setState(() {
        selected = "Add Page";
      });
    } else if (value == Options.Edit.index) {
      print("Edit Menu Click");
      setState(() {
        selected = "Edit Page";
      });
    } else if (value == Options.Delete.index) {
      print("Delete Menu Click");
      setState(() {
        selected = "Delete Page";
      });
    } else {
      print("Thank you :)");
      setState(() {
        selected = "Thank you :)";
      });
    }
  }
}
