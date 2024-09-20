import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ipet/misc/themestyle.dart';

class ChatVet extends StatefulWidget {
  final String vetID;
  const ChatVet({super.key, required this.vetID});

  @override
  State<ChatVet> createState() => _ChatVetState();
}

class _ChatVetState extends State<ChatVet> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();

  File? _selectedImage;

  Future<void> _sendMessage() async {
    if (_messageController.text.isEmpty && _selectedImage == null) return;

    String? imageUrl;
    if (_selectedImage != null) {
      imageUrl = await _uploadImage();
    }

    await _firestore.collection('chats').add({
      'text': _messageController.text,
      'senderId': _auth.currentUser!.uid,
      'vetId': widget.vetID,
      'imageUrl': imageUrl,
      'timestamp': FieldValue.serverTimestamp(),
    });

    _messageController.clear();
    setState(() {
      _selectedImage = null;
    });
  }

  Future<String?> _uploadImage() async {
    if (_selectedImage == null) return null;

    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageReference =
          FirebaseStorage.instance.ref().child('chat_images/$fileName');
      UploadTask uploadTask = storageReference.putFile(_selectedImage!);
      TaskSnapshot taskSnapshot = await uploadTask;
      return await taskSnapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.image),
            onPressed: _pickImage,
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Enter your message',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('chats')
          .where('vetId', isEqualTo: widget.vetID)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Something went wrong: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No messages'));
        }

        // Fetch the messages and sort them by timestamp here
        var messages = snapshot.data!.docs;

        // Sort the messages based on the 'timestamp' field
        messages.sort((a, b) {
          Timestamp timeA = a['timestamp'] ?? Timestamp.now();
          Timestamp timeB = b['timestamp'] ?? Timestamp.now();
          return timeB.compareTo(timeA); // Sort descending (newest first)
        });

        return ListView.builder(
          reverse: true,
          itemCount: messages.length,
          itemBuilder: (context, index) {
            var message = messages[index];
            bool isSender = message['senderId'] == _auth.currentUser!.uid;

            return Align(
              alignment:
                  isSender ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isSender ? maincolor : Colors.grey[300],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (message['imageUrl'] != null)
                      Image.network(
                        message['imageUrl'],
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    Text(
                      message['text'] ?? '',
                      style: TextStyle(
                          color: isSender ? Colors.white : Colors.black),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: maincolor,
        title: Text(
          'Message',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          if (_selectedImage != null)
            Image.file(
              _selectedImage!,
              width: 100,
              height: 100,
            ),
          _buildMessageInput(),
        ],
      ),
    );
  }
}
