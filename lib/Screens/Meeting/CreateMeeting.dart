import 'dart:math';
import 'package:cmc/Function/meeting_function.dart';
import 'package:cmc/Models/GroupModels.dart';
import 'package:cmc/Provider/UserProvider.dart';
import 'package:cmc/Screens/Meeting/LiveMeeting.dart';
import 'package:cmc/Utills/CompanyLogo.dart';
import 'package:cmc/Utills/Constant.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateRoom extends StatefulWidget {
  GroupModels? group;
  CreateRoom({super.key, required this.group});

  @override
  State<CreateRoom> createState() => _CreateRoomState();
}

class _CreateRoomState extends State<CreateRoom> {
  final TextEditingController _roomName = TextEditingController();
  final TextEditingController _tagsEditingController = TextEditingController();
  List<String> tags = [];
  int roomId = 9999999;

  @override
  void initState() {
    // TODO: implement initState
    roomId = Random().nextInt(1000000) + 100000;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Audio Room'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 50,
              ),
              const SizedBox(
                height: 30,
              ),
              CompanyLogo(200, 200),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                width: 300,
                child: TextField(
                  controller: _roomName,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(20),
                    prefixIcon: const Icon(Icons.group),
                    hintText: 'RoomName',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              SizedBox(
                width: 300,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _tagsEditingController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(20),
                          prefixIcon: const Icon(Icons.tag),
                          hintText: 'Enter Tags To Add',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        if (_tagsEditingController.text.isNotEmpty) {
                          setState(() {
                            tags.add(_tagsEditingController.text);
                            _tagsEditingController.clear();
                          });
                        }
                      },
                      child: const Text('Add'),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(50),
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: tags.map((tag) {
                    return Chip(
                      label: Text(tag),
                      onDeleted: () {
                        setState(() {
                          tags.remove(tag);
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  createMeeting();
                },
                child: Container(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  width: 100,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Text(
                    ' Create ',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  createMeeting() async {
    var user = Provider.of<UserProvider>(context, listen: false);
    if (_roomName.text.isNotEmpty) {
      MeetingFunction.createMeeting(_roomName.text, roomId.toString(),
          [user.uid], tags, widget.group?.users ?? []);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => LivePage(
                    roomID: roomId.toString(),
                    isHost: true,
                    userName: user.user?.userName ?? 'Unkown',
                    userUid: user.uid,
                    profilePhoto: user.user?.profilePhoto ?? Constant.image,
                  )));
    }
  }
}
