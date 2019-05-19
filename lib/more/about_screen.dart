import 'package:fest_app/shared/bottom_navigation.dart';
import 'package:fest_app/shared/screen_title.dart';
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
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
                    title: 'About',
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ListView(
                  children: <Widget>[
                    Text(
                      '''BITS, Pilani, India is back with the 37th edition of APOGEE- the institute’s annual technical extravaganza, from 28th to 31st March 2019, this time as The Reality Roulette! A melange of technology, innovation and inspiration across space and time of humankind, this technical conference will, as always, play host to the brightest minds and thinkers in the country and world. From presenting papers and projects at the oldest-of-its-kind events in the country, developing amazing solutions to real-life cases and problems, exhibitions of the best contraptions that man has made, guest lectures that tell stories never heard before, to the college’s own literature festival, APOGEE challenges the intellect of the participants and piques the minds of the audience.''',
                      style: TextStyle(fontSize: 18.0),
                    )
                  ],
                ),
              ),
            )
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
