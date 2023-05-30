import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:bloc/bloc.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../chat_bloc/chat_bloc.dart';

class ChatList extends StatelessWidget {
  ChatList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(builder: (BuildContext context) {
          return BackButton(
            onPressed: () {
              context.go('/discover');
            },
          );
        }),
        backgroundColor: Color(0xFFFF7F50),
        elevation: 0,
        title: Row(children: const [
          Expanded(child: Text("CHATS")),
        ]),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.person))],
      ),
      body: Chats(),
    );
  }
}

class Chats extends StatelessWidget {

  String compressText(String text) {
    var compressedText = "";

    for (int i = 0; i < 30; i++) {
      compressedText += text[i];
    }
    compressedText += "...";

    return compressedText;
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<ChatBloc>();
    final state = bloc.state;

    if (state is ChatInitial) {
      bloc.add(FetchData());
      return Container();
    } else if (state is ChatLoading) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          CupertinoActivityIndicator(
            radius: 40,
            color: Colors.orange,
          )
        ],
      );
    } else if (state is ChatLoaded) {
      final data = state.data;
      return ListView(
          children: data.map((e) {
        return InkWell(
          onTap: () {
            bloc.add(NewTextArrival());
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        width: 2.0,
                        color: Color.fromARGB(255, 222, 221, 221)))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.transparent,
                      child: SizedBox(
                          width: 120,
                          height: 120,
                          child: ClipOval(
                              child: Image.asset(
                            e.image as String,
                            fit: BoxFit.cover,
                          ))),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(e.name as String),
                          Text(
                            e.recentTyped.toString().length <= 30
                                ? e.recentTyped.toString()
                                : compressText(e.recentTyped.toString()),
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      DateFormat('yyyy/MM/d hh:mm a').format(e.time!),
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
        ;
      }).toList());
    }
    return Container();
  }
}