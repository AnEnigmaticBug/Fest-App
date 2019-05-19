import 'package:flutter/material.dart';

import 'package:fest_app/more/models.dart';
import 'package:fest_app/shared/bottom_navigation.dart';
import 'package:fest_app/shared/screen_title.dart';

const _contacts = <Contact>[
  Contact(
    name: 'Satyansh Rai',
    role: 'President, Student Union',
    mobile: '+91-9151178228',
    picUrl: 'http://bits-apogee.org/3f48d8dff7707dc4d5eff6453b7db8aa.jpg',
  ),
  Contact(
    name: 'Aakash Singh',
    role: 'General Secretary, Student Union',
    mobile: '+91-9468923617',
    picUrl: 'http://bits-apogee.org/d2922f9db921923834c804c1705beacc.jpg',
  ),
  Contact(
    name: 'Megh Thakkar',
    role: 'For app related queries',
    mobile: '+91-9829799877',
    picUrl: 'http://bits-apogee.org/48524dae9913a21ac36b617e1ce44058.jpg',
  ),
  Contact(
    name: 'Parv Panthari',
    role: 'Registrations and Correspondence',
    mobile: '+91-9462011235',
    picUrl: 'http://bits-apogee.org/561b0cde1229afdda21420f97ac9ff41.jpg',
  ),
  Contact(
    name: 'Anushka Pathak',
    role: 'Sponsorship and Marketing',
    mobile: '+91-7795025103',
    picUrl: 'http://bits-apogee.org/6fcb439c24576a5236f38cbf1342f900.jpg',
  ),
  Contact(
    name: 'Apoorv Saxena',
    role: 'Registration, Events and Projects',
    mobile: '+91-7239805667',
    picUrl: 'http://bits-apogee.org/eeb0c0443872cd1f96e4411474110509.jpg',
  ),
  Contact(
    name: 'Yatharth Singh',
    role: 'Reception and Accomodation',
    mobile: '+91-9971393939',
    picUrl: 'http://bits-apogee.org/ae5a18b484ba677cf3589d3cd581db3d.jpg',
  ),
  Contact(
    name: 'Aditya Pawar',
    role: 'Publicity and Online Partnerships',
    mobile: '+91-9829971666',
    picUrl: 'http://bits-apogee.org/0378ed88538d1beb8e939902a59b8bbc.jpg',
  ),
  Contact(
    name: 'Anirudh Singla',
    role: 'Guest Lectures and Paper Presentation',
    mobile: '+91-9818536680',
    picUrl: 'http://bits-apogee.org/65ceaf2463bc5cd5c4c7a15f9f3b9981.jpg',
  )
];

class ContactsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                SizedBox(width: 4.0),
                BackButton(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: ScreenTitle(
                    title: 'Contacts',
                  ),
                ),
              ],
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: _ContactsList(),
            )),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigation(
        initialIndex: 4,
        selectedItemColor: Colors.green,
      ),
    );
  }
}

class _ContactsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 20.0),
      itemCount: _contacts.length,
      itemBuilder: (context, index) {
        final color = Colors.accents[index % 6];
        return _ContactTile(contact: _contacts[index], backgroundColor: color);
      },
      separatorBuilder: (context, index) => SizedBox(height: 16.0),
    );
  }
}

class _ContactTile extends StatelessWidget {
  final Contact contact;
  final Color backgroundColor;

  _ContactTile({
    Key key,
    @required this.contact,
    @required this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      elevation: 8.0,
      child: InkWell(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(flex: 1, child: _ContactInfo(contact: contact)),
              CircleAvatar(
                radius: 40.0,
                backgroundImage: NetworkImage(contact.picUrl),
              ),
            ],
          ),
        ),
        onTap: () {},
      ),
    );
  }
}

class _ContactInfo extends StatelessWidget {
  final Contact contact;

  _ContactInfo({Key key, @required this.contact}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _ContactName(name: contact.name),
        _ContactRole(role: contact.role),
        SizedBox(height: 16.0),
        _ContactMobile(mobile: contact.mobile),
      ],
    );
  }
}

class _ContactName extends StatelessWidget {
  final String name;

  _ContactName({Key key, @required this.name}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      style: TextStyle(fontSize: 24.0, color: Colors.white),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _ContactRole extends StatelessWidget {
  final String role;

  _ContactRole({Key key, @required this.role}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      role,
      style: TextStyle(color: Colors.white),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _ContactMobile extends StatelessWidget {
  final String mobile;

  _ContactMobile({Key key, @required this.mobile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      mobile,
      style: TextStyle(color: Colors.white, letterSpacing: 1.0),
    );
  }
}
