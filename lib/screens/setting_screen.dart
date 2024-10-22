import 'package:flutter/material.dart';
import 'package:resq_ai/services/contact_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final ContactService _contactService = ContactService();
  List<Contact> _emergencyContacts = [];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  String _name = '';
  String _age = '';
  String _medicalConditions = '';
  String _allergies = '';

  @override
  void initState() {
    super.initState();
    _loadContacts();
    _loadPersonalInfo();
  }

  Future<void> _loadContacts() async {
    final contacts = await _contactService.getContacts();
    setState(() {
      _emergencyContacts = contacts;
    });
  }

  Future<void> _loadPersonalInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString('name') ?? '';
      _age = prefs.getString('age') ?? '';
      _medicalConditions = prefs.getString('medical_conditions') ?? '';
      _allergies = prefs.getString('allergies') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Personal Information'),
            subtitle: const Text('Update your personal details'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => _showPersonalInfoDialog(),
          ),
          ListTile(
            title: const Text('Medical Information'),
            subtitle: const Text('Update your medical details'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => _showMedicalInfoDialog(),
          ),
          ListTile(
            title: const Text('Emergency Contacts'),
            subtitle: const Text('Add or remove emergency contacts'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => _showContactsDialog(),
          ),
          ListTile(
            title: const Text('Safe Locations'),
            subtitle: const Text('Manage your safe locations'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => Navigator.pushNamed(context, '/safe_locations'),
          ),
          ListTile(
            title: const Text('Privacy Policy'),
            subtitle: const Text('View our privacy policy'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => _showPrivacyPolicy(),
          ),
        ],
      ),
    );
  }

  void _showPersonalInfoDialog() {
    TextEditingController nameController = TextEditingController(text: _name);
    TextEditingController ageController = TextEditingController(text: _age);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Personal Information'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: ageController,
              decoration: const InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString('name', nameController.text);
              prefs.setString('age', ageController.text);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showMedicalInfoDialog() {
    TextEditingController medicalConditionsController =
        TextEditingController(text: _medicalConditions);
    TextEditingController allergiesController =
        TextEditingController(text: _allergies);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Medical Information'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: medicalConditionsController,
              decoration: const InputDecoration(labelText: 'Medical Conditions'),
              maxLines: 3,
            ),
            TextField(
              controller: allergiesController,
              decoration: const InputDecoration(labelText: 'Allergies'),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString('medical_conditions', medicalConditionsController.text);
              prefs.setString('allergies', allergiesController.text);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showContactsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Emergency Contacts'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ..._emergencyContacts.map((contact) => ListTile(
                title: Text(contact.name),
                subtitle: Text(contact.phoneNumber),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _removeContact(contact),
                ),
              )),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: _addContact,
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _addContact() {
    if (_nameController.text.isNotEmpty && _phoneController.text.isNotEmpty) {
      final newContact = Contact(
        name: _nameController.text,
        phoneNumber: _phoneController.text,
      );
      _contactService.saveContact(newContact);
      _loadContacts();
      _nameController.clear();
      _phoneController.clear();
      Navigator.of(context).pop();
    }
  }

  void _removeContact(Contact contact) {
    _contactService.deleteContact(contact);
    _loadContacts();
  }

  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Policy'),
        content: const Text(
          'Our privacy policy is to protect your personal information and only use it for emergency purposes.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}