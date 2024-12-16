import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();

  var gelenYaziBasligi = "";
  var gelenYaziIcerigi = "";

  yaziEkle() {
    FirebaseFirestore.instance
        .collection("Articles")
        .doc(t1.text)
        .set({'title': t1.text, 'content': t2.text}).whenComplete(() {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Makale başarıyla eklendi!")));
    });
  }

  yaziGuncelle() {
    FirebaseFirestore.instance
        .collection("Articles")
        .doc(t1.text)
        .update({'title': t1.text, 'content': t2.text}).whenComplete(() {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Makale başarıyla güncellendi!")));
    });
  }

  yaziSil() {
    FirebaseFirestore.instance.collection("Articles").doc(t1.text).delete().whenComplete(() {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Makale başarıyla silindi!")));
    });
  }

  yaziGetir() {
    FirebaseFirestore.instance
        .collection("Articles")
        .doc(t1.text)
        .get()
        .then((gelenVeri) {
      if (gelenVeri.data() != null) {
        setState(() {
          gelenYaziBasligi = gelenVeri.data()?['title'] ?? "";
          gelenYaziIcerigi = gelenVeri.data()?['content'] ?? "";
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Doküman bulunamadı!")));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(40),
        child: Center(
          child: Column(
            children: [
              TextField(
                controller: t1,
                decoration: InputDecoration(labelText: "Başlık"),
              ),
              TextField(
                controller: t2,
                decoration: InputDecoration(labelText: "İçerik"),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(onPressed: yaziEkle, child: Text("Ekle")),
                  ElevatedButton(onPressed: yaziGuncelle, child: Text("Güncelle")),
                  ElevatedButton(onPressed: yaziSil, child: Text("Sil")),
                  ElevatedButton(onPressed: yaziGetir, child: Text("Getir")),
                ],
              ),
              ListTile(
                title: Text(gelenYaziBasligi),
                subtitle: Text(gelenYaziIcerigi),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
