import 'package:firechat/views/chat/chat_page.dart';
import 'package:firechat/views/common/theme/colors.dart';
import 'package:firechat/views/contacts/contacts_page.dart';
import 'package:firechat/views/profile/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:firechat/common/extensions/context_extensions.dart';

class HomePage extends StatefulWidget {

  static Route route() {
    return MaterialPageRoute(builder: (_) => HomePage());
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final pageElements = [
    HomePageElement(ChatPage(), Icons.chat),
    HomePageElement(ContactsPage(), Icons.people),
    HomePageElement(ProfilePage(), Icons.account_circle)
  ];

  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text(pageElements[_index].getTitle(context)),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [Expanded(child: pageElements[_index].page), _bottomNavBar],
      ),
    );
  }

  Widget get _bottomNavBar => BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: themeFieldColor,
        selectedItemColor: themeTextColor,
        unselectedItemColor: themeHintTextColor,
        items: pageElements
            .map((elem) => BottomNavigationBarItem(
                label: elem.getTitle(context), icon: Icon(elem.icon)))
            .toList(),
        currentIndex: _index,
        onTap: (newIndex) {
          setState(() {
            _index = newIndex;
          });
        },
      );
}

class HomePageElement {
  final Widget page;
  final IconData icon;

  HomePageElement(this.page, this.icon);

  String getTitle(BuildContext context) {
    if(page is ChatPage) return context.strings.homeChatTitle;
    if(page is ContactsPage) return context.strings.homeContactsTitle;
    if(page is ProfilePage) return context.strings.homeProfileTitle;
    throw UnsupportedError("No title given for page ${page.runtimeType}");
  }
}
