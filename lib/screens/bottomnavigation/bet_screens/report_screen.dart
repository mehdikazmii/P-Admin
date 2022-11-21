import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../helpers/constant.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key, required this.data});
  final QueryDocumentSnapshot<Object?> data;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      appBar: AppBar(
        shadowColor: black,
        backgroundColor: black,
        title: const Text('Reported Bets'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('publish')
                .doc(data.id)
                .collection('reports')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container();
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container();
              }
              var item = snapshot.data!.docs;

              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  var data = item[index];

                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                        color: blue, borderRadius: BorderRadius.circular(20)),
                    child: ListTile(
                      textColor: white,
                      title: Text(data['explaination']),
                      subtitle: Text(data['report']),
                      trailing: Text('@ ${data['name']}'),
                    ),
                  );
                },
              );
            }),
      ),
    );
  }
}
