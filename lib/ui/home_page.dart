import 'package:agenda_de_contatos/helpers/contact_helper.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import "dart:io";

import 'contact_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContactHelper helper = ContactHelper();
  List<Contact> contacts = List();

  @override
  void initState() {
    super.initState();
    _getAllContacts();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contatos"),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showContactPage();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
      body: ListView.builder(
          padding: EdgeInsets.all(10),
          itemCount: contacts.length,
          itemBuilder: (context, index) {
            return _contactCard(context, index);
          }),
    );
  }

  Widget _contactCard(context, index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: contacts[index].img != null
                          ? FileImage(File(contacts[index].img))
                          : AssetImage("images/person.png"),
                    )),
              ),
              Padding(padding: EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(contacts[index].name ?? "",
                      style: TextStyle(fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(contacts[index].email ?? "",
                      style: TextStyle(fontSize: 18,)
                    ),
                    Text(contacts[index].phone ?? "",
                        style: TextStyle(fontSize: 18,)
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    onTap: (){
        _showOptions(context,index);
    },
    );
  }
  void _showContactPage({Contact contact}) async {
    final recContact = await Navigator.push(context, MaterialPageRoute(builder: (context)=>ContactPage(contact: contact)));
    if(recContact != null && contact != null){
      await helper.updateContact(recContact);
    }else if(recContact != null){
      await helper.saveContact(recContact);
    }
    _getAllContacts();
  }
  void _showOptions(context,index){
    showModalBottomSheet(context: context, builder: (context){
      return BottomSheet(
          onClosing: (){},
          builder: (context){
            return Container(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: FlatButton(
                        child: Text("Ligar",
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 20
                          ),
                        ),
                        onPressed: (){},
                      ),
                  ),Padding(
                    padding: EdgeInsets.all(10),
                    child: FlatButton(
                      child: Text("Editar",
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 20
                        ),
                      ),
                      onPressed: (){
                        Navigator.pop(context);
                        _showContactPage(contact: contacts[index]);
                      },
                    ),
                  ),Padding(
                    padding: EdgeInsets.all(10),
                    child: FlatButton(
                      child: Text("Excluir",
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 20
                        ),
                      ),
                      onPressed: (){
                        helper.deleteContact(contacts[index].id);
                        setState(() {
                          contacts.removeAt(index);
                          Navigator.pop(context);
                        });
                      },
                    ),
                  )
                ],
              ),
            );
          }
      );
    });
  }
  void _getAllContacts(){
    helper.getAllContacts().then((list) {
      setState(() {
        contacts = list;
      });
    });
  }
}

//_showContactPage(contact: contacts[index]);