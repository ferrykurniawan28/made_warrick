import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final firebase = FirebaseFirestore.instance;

class AddNilai extends StatefulWidget {
  const AddNilai({super.key});

  @override
  State<AddNilai> createState() => _AddNilaiState();
}

class _AddNilaiState extends State<AddNilai> {
  final _formKey = GlobalKey<FormState>();
  final _matkul = TextEditingController();
  final _nilaiTM = TextEditingController();
  final _nilaiUTS = TextEditingController();
  final _nilaiUAS = TextEditingController();
  late String grade;

  void _uploadNilai() async {
    final valid = _formKey.currentState!.validate();
    if (!valid) {
      return;
    }
    _formKey.currentState!.save();
    final int tm = int.parse(_nilaiTM.text);
    final int uts = int.parse(_nilaiUTS.text);
    final int uas = int.parse(_nilaiUAS.text);
    final int nilaiAkhir = (tm + uts + uas) ~/ 3;

    if (nilaiAkhir >= 90) {
      grade = 'A';
    } else if (nilaiAkhir >= 80) {
      grade = 'B';
    } else if (nilaiAkhir >= 70) {
      grade = 'C';
    } else if (nilaiAkhir >= 60) {
      grade = 'D';
    } else if (nilaiAkhir >= 50) {
      grade = 'E';
    } else if (nilaiAkhir <= 50) {
      grade = 'F';
    }

    await firebase
        .collection('nilai')
        .doc('Matkul')
        .collection('nilai')
        .doc(_matkul.text)
        .set({
      'matkul': _matkul.text,
      'nilaiTM': tm,
      'nilaiUTS': uts,
      'nilaiUAS': uas,
      'nilaiAkhir': nilaiAkhir,
      'grade': grade,
    });
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _matkul.dispose();
    _nilaiTM.dispose();
    _nilaiUTS.dispose();
    _nilaiUAS.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Nilai'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _matkul,
                decoration: const InputDecoration(
                  hintText: 'Mata Kuliah',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Mata Kuliah tidak boleh kosong';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _nilaiTM,
                decoration: const InputDecoration(
                  hintText: 'Nilai Tugas Mandiri',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nilai Tugas Mandiri tidak boleh kosong';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _nilaiUTS,
                decoration: const InputDecoration(
                  hintText: 'Nilai UTS',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nilai UTS tidak boleh kosong';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _nilaiUAS,
                decoration: const InputDecoration(
                  hintText: 'Nilai UAS',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nilai UAS tidak boleh kosong';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: _uploadNilai,
                child: const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
