import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:blabber/pages/auth_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:blabber/components/app_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class Profile extends StatelessWidget {
    void showErrorMessage(String message, context){
      showDialog(
        context: context,
        builder:(context){
          return AlertDialog(
            title: Text(message),
          );
      },
      );
    }



    // current logged in user
    final User? currentUser = FirebaseAuth.instance.currentUser;

    Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetails() async {
      return await FirebaseFirestore.instance.collection("Users").doc(currentUser!.email).get();
    }

  
  Profile({super.key});
  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Your Profile'),
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      elevation: 0,
    ),
    drawer: AppDrawer(),
    body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: getUserDetails(),
      builder: (context, snapshot) {
        //loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } 
        //error
        else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        } 
        //data received
        else if (snapshot.hasData) {
          Map<String, dynamic>? user = snapshot.data!.data();
          var userEmail = user!['email'];
          var userUsername = user['username'];
          return Column(
            children: [
              const Expanded(flex: 2, child: _TopPortion()),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        userUsername,
                        style: Theme.of(context).textTheme.headline6?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FloatingActionButton.extended(
                            onPressed: () {},
                            heroTag: 'edit',
                            elevation: 0,
                            backgroundColor: Color.fromARGB(255, 230, 230, 230),
                            label: const Text("Settings", style: TextStyle(color: Colors.black)),
                            icon: const Icon(Icons.settings, color: Colors.black),
                          ),
                          const SizedBox(width: 16.0),
                          FloatingActionButton.extended(
                            onPressed: () {},
                            heroTag: 'follow',
                            elevation: 0,
                            backgroundColor: Color.fromARGB(255, 249, 28, 31),
                            label: const Text("Follow", style: TextStyle(color: Colors.white)),
                            icon: const Icon(Icons.alternate_email, color: Colors.white),
                          ),
                          const SizedBox(width: 16.0),
                          FloatingActionButton.extended(
                            onPressed: () {},
                            heroTag: 'friend',
                            elevation: 0,
                            backgroundColor: Color.fromARGB(255, 249, 226, 30),
                            label: const Text("Friend", style: TextStyle(color: Colors.black)),
                            icon: const Icon(Icons.group_add, color: Colors.black),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const _ProfileInfoRow()
                    ],
                  ),
                ),
              ),
            ],
          );
        } else {
          return Text("No data");
        }
      },
    ),
  );
}

}


class _ProfileInfoRow extends StatelessWidget {
  const _ProfileInfoRow({Key? key}) : super(key: key);

  final List<ProfileInfoItem> _items = const [
    ProfileInfoItem("Blabbers", 0),
    ProfileInfoItem("Followers", 0),
    ProfileInfoItem("Friends", 0),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      constraints: const BoxConstraints(maxWidth: 400),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _items
            .map((item) => Expanded(
                    child: Row(
                  children: [
                    if (_items.indexOf(item) != 0) const VerticalDivider(),
                    Expanded(child: _singleItem(context, item)),
                  ],
                )))
            .toList(),
      ),
    );
  }

  Widget _singleItem(BuildContext context, ProfileInfoItem item) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              item.value.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          Text(
            item.title,
            style: Theme.of(context).textTheme.caption,
          )
        ],
      );
}

class ProfileInfoItem {
  final String title;
  final int value;
  const ProfileInfoItem(this.title, this.value);
}

class _TopPortion extends StatelessWidget {
  const _TopPortion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 50),
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Color(0xffF9E21E), Color(0xffF91C1F)]),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              )),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: 150,
            height: 150,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                            'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1470&q=80')),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    child: Container(
                      margin: const EdgeInsets.all(8.0),
                      decoration: const BoxDecoration(
                          color: Colors.green, shape: BoxShape.circle),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}