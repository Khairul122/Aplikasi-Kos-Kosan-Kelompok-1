import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DataPemesananPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Data Pemesanan'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Tidak ada data pemesanan'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final user = snapshot.data!.docs[index];
              final pemesananCollection =
                  user.reference.collection('pemesanan');

              return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: pemesananCollection.snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        pemesananSnapshot) {
                  if (pemesananSnapshot.hasError) {
                    return Text('Error: ${pemesananSnapshot.error}');
                  }

                  if (pemesananSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final pemesananDocs = pemesananSnapshot.data!.docs;

                  if (pemesananDocs.isEmpty) {
                    return SizedBox();
                  }

                  final pemesanan = pemesananDocs.first.data();

                  final nama = pemesanan != null && pemesanan['nama'] != null
                      ? pemesanan['nama'] as String
                      : '';
                  final alamat =
                      pemesanan != null && pemesanan['alamat'] != null
                          ? pemesanan['alamat'] as String
                          : '';
                  final telepon =
                      pemesanan != null && pemesanan['telepon'] != null
                          ? pemesanan['telepon'] as String
                          : '';
                  final jenisKelamin =
                      pemesanan != null && pemesanan['jenisKelamin'] != null
                          ? pemesanan['jenisKelamin'] as String
                          : '';
                  final kamar = pemesanan != null && pemesanan['kamar'] != null
                      ? pemesanan['kamar'] as String
                      : '';

                  return Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: Card(
                      child: ListTile(
                        leading: Icon(Icons.shopping_cart_sharp),
                        title: Text(nama),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Alamat: $alamat'),
                            Text('Telepon: $telepon'),
                            Text('Jenis Kelamin: $jenisKelamin'),
                            Text('Kamar: $kamar'),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
