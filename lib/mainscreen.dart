import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:made_warrick/addnilai.dart';

final firebase = FirebaseFirestore.instance;

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late String grade;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nilai'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddNilai(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: firebase
            .collection('nilai')
            .doc('Matkul')
            .collection('nilai')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final DocumentSnapshot document = snapshot.data!.docs[index];
              return Card(
                child: ListTile(
                  title: Text(document['matkul']),
                  subtitle: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Nilai Akhir : ${document['nilaiAkhir'].toString()}',
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Grade : ${document['grade']}',
                      ),
                    ],
                  ),
                  leading: IconButton(
                    onPressed: () async {
                      firebase
                          .collection('nilai')
                          .doc('Matkul')
                          .collection('nilai')
                          .doc(
                            document['matkul'],
                          )
                          .delete();
                    },
                    icon: const Icon(Icons.delete),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
