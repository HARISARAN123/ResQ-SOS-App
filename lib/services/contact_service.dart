import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Contact {
  final String name;
  final String phoneNumber;

  Contact({required this.name, required this.phoneNumber});

  Map<String, dynamic> toJson() => {
    'name': name,
    'phoneNumber': phoneNumber,
  };

  factory Contact.fromJson(Map<String, dynamic> json) => Contact(
    name: json['name'],
    phoneNumber: json['phoneNumber'],
  );
}

class ContactService {
  static const String _contactsKey = 'emergency_contacts';

  Future<List<Contact>> getContacts() async {
    final prefs = await SharedPreferences.getInstance();
    final contactsJson = prefs.getStringList(_contactsKey) ?? [];
    return contactsJson.map((json) => Contact.fromJson(jsonDecode(json))).toList();
  }

  Future<void> saveContact(Contact contact) async {
    final prefs = await SharedPreferences.getInstance();
    final contacts = await getContacts();
    contacts.add(contact);
    await prefs.setStringList(_contactsKey, contacts.map((c) => jsonEncode(c.toJson())).toList());
  }

  Future<void> deleteContact(Contact contact) async {
    final prefs = await SharedPreferences.getInstance();
    final contacts = await getContacts();
    contacts.removeWhere((c) => c.phoneNumber == contact.phoneNumber);
    await prefs.setStringList(_contactsKey, contacts.map((c) => jsonEncode(c.toJson())).toList());
  }

  Future<void> updateContact(Contact oldContact, Contact newContact) async {
    final prefs = await SharedPreferences.getInstance();
    final contacts = await getContacts();
    final index = contacts.indexWhere((c) => c.phoneNumber == oldContact.phoneNumber);
    if (index != -1) {
      contacts[index] = newContact;
      await prefs.setStringList(_contactsKey, contacts.map((c) => jsonEncode(c.toJson())).toList());
    }
  }
}