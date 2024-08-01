import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../../constants/enums.dart';
import '../../logic/notifications/notifications_service.dart';
import '../models/comment_model.dart';
import '../models/plant_model.dart';
import '../models/post_model.dart';
import '../models/reminder_model.dart';

class PlantRepository {
  final plantCollection = FirebaseFirestore.instance.collection('plants');
  final postsCollection = FirebaseFirestore.instance.collection('posts');
  final userPlantsCollection = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser?.uid ?? '55')
      .collection('user plants');
  final userRemindersCollection = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser?.uid ?? '55')
      .collection('user reminders');
  final userCollection = FirebaseFirestore.instance.collection('users');
  final userId = FirebaseAuth.instance.currentUser?.uid ?? '55';
  int generateUniqueIntId() {
    final max32Bit = 2147483647;
    final min32Bit = -2147483648;

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final randomNumber = Random().nextInt(max32Bit) %
        1000; // Ensure it stays within 32-bit range

    // Combine timestamp and random number within 32-bit range
    return (timestamp + randomNumber) % (max32Bit - min32Bit) + min32Bit;
  }

// plantControler <=========================================>
  Future<List<Plant>> plantsData() async {
    final plants = <Plant>[];
    try {
      await plantCollection.get().then(
        (value) {
          for (var plantDoc in value.docs) {
            final plant = plantDoc.data();
            plants.add(Plant(
                plantId: plant['plantId'],
                commonName: plant['commonName'],
                scientificName: plant['scientificName'],
                careInstructions: plant['careInstructions'],
                sunlightRequirements: plant['sunlightRequirements'],
                wateringSchedule: plant['wateringSchedule'],
                imageUrl: plant['imageUrl'],
                isFavorite: true));
          }
        },
      );
      return plants;
    } catch (e) {
      debugPrint(e.toString());
      return plants;
    }
  }

  Future<Map<String, bool>> userplants() async {
    final userPlantsId = <String, bool>{};
    try {
      userPlantsCollection.get().then(
        (value) {
          for (var doc in value.docs) {
            userPlantsId.addAll(
              {doc.id: doc.data()['isFavorite']},
            );
          }
        },
      );
      return userPlantsId;
    } catch (e) {
      print(e);
      return userPlantsId;
    }
  }

  Future<List<Plant>> fetchPlantsData() async {
    var editedPlants = <Plant>[];
    try {
      await userplants().then(
        (userPlantsId) async {
          await plantsData().then(
            (plants) {
              for (var plant in plants) {
                if (userPlantsId.containsKey(plant.plantId)) {
                  plant.isFavorite = userPlantsId[plant.plantId] ?? false;
                } else {
                  plant.isFavorite = false;
                }
              }
              editedPlants = plants;
              return plants;
            },
          );
        },
      );
      return editedPlants;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<bool> checkIfDocExists(String docId) async {
    try {
      final docSnapshot = await userPlantsCollection.doc(docId).get();
      return docSnapshot.exists;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> clicOnFavorit(String plantId, bool isFavorite) async {
    try {
      if (await checkIfDocExists(plantId)) {
        // Document exists, update it
        await userPlantsCollection
            .doc(plantId)
            .update({'isFavorite': isFavorite});
        debugPrint('Document updated successfully!');
      } else {
        // Document doesn't exist, add a new one
        await userPlantsCollection.doc(plantId).set({'isFavorite': isFavorite});
        debugPrint('New document added successfully!');
      }
    } catch (e) {
      debugPrint('error in clicOnFavorit in plant repsetory $e');
      rethrow;
    }
  }

//=========================================================>
//reminders <===============================================
  Future<List<Reminder>> fetchRemindersData() async {
    final reminders = <Reminder>[];
    try {
      await userRemindersCollection.get().then(
        (value) {
          for (var postDoc in value.docs) {
            final reminder = postDoc.data();
            reminders.add(Reminder(
              plantName: reminder['plantName'],
              careType: reminder['careType'] == 'watering'
                  ? CareType.watering
                  : reminder['careType'] == 'rotation'
                      ? CareType.rotation
                      : reminder['careType'] == 'fertilizing'
                          ? CareType.fertilizing
                          : CareType.watering,
              lastCaregDateTime:
                  (reminder['lastCaregDateTime'] as Timestamp).toDate(),
              nextCaregDateTime:
                  (reminder['nextCaregDateTime'] as Timestamp).toDate(),
              days: reminder['days'],
              hours: reminder['hours'],
              id: postDoc.id,
              notificationId: reminder['notificationId'],
            ));
          }
        },
      );
      reminders.sort(
        (a, b) => a.nextCaregDateTime.compareTo(b.nextCaregDateTime),
      );
      return reminders;
    } catch (e) {
      debugPrint(e.toString());
      return reminders;
    }
  }

  Future<void> addReminder(
    String plantName,
    CareType careType,
    DateTime lastCaregDate,
    TimeOfDay lastCareingTime,
    int days,
    int hours,
    String? reminderId,
  ) async {
    final combinedDateTime = DateTime(
      lastCaregDate.year,
      lastCaregDate.month,
      lastCaregDate.day,
      lastCareingTime.hour,
      lastCareingTime.minute,
    );

    final lastTimestamp = Timestamp.fromDate(combinedDateTime);
    final nextTimestamp = Timestamp.fromDate(
        combinedDateTime.add(Duration(days: days, hours: hours)));
    final notificationId = generateUniqueIntId();

    try {
      if (reminderId == null) {
        await userRemindersCollection.doc().set({
          'plantName': plantName,
          'careType': careType.name,
          'lastCaregDateTime': lastTimestamp,
          'nextCaregDateTime': nextTimestamp,
          'days': days,
          'hours': hours,
          'notificationId': notificationId,
        }).then(
          (_) {
            NotificationsService().scheduleNotification(
              dateTime:
                  combinedDateTime.add(Duration(days: days, hours: hours)),
              title: plantName,
              body: 'It is time to ${careType.name} you plant🌱💧',
              notificationId: notificationId,
            );
          },
        );
        debugPrint('New reminder added successfully!');
      } else {
        await userRemindersCollection.doc(reminderId).update({
          'plantName': plantName,
          'careType': careType.name,
          'lastCaregDateTime': lastTimestamp,
          'nextCaregDateTime': nextTimestamp,
          'days': days,
          'hours': hours,
        }).then(
          (_) {
            NotificationsService().scheduleNotification(
              dateTime:
                  combinedDateTime.add(Duration(days: days, hours: hours)),
              title: plantName,
              body: 'It is time to ${careType.name} you plant🌱💧',
              notificationId: notificationId,
            );
          },
        );
        debugPrint('New reminder added successfully!');
      }
    } catch (e) {
      debugPrint('error in addReminder in plant repsetory $e');
      rethrow;
    }
  }

  Future<void> deletReminder(
    String reminderId,
    int notificationId,
  ) async {
    try {
      await userRemindersCollection.doc(reminderId).delete().then(
        (_) {
          NotificationsService().cancelScheduledNotification(notificationId);
        },
      );
      debugPrint('reminder $reminderId deleted successfully!');
    } catch (e) {
      debugPrint('error in deletReminder in plant repsetory $e');
      rethrow;
    }
  }

//===============================================================>
//posts <========================================================>
  Future<String?> fetchUserImageUrl() async {
    String? imageUrl = '';
    try {
      final userDoc = await userCollection
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      imageUrl = userDoc.data()?['userImageUrl'] ?? '';
      return imageUrl;
    } catch (e) {
      print(e);
      return imageUrl;
    }
  }

  Future<List<PostModel>> fetchPostsData() async {
    final posts = <PostModel>[];
    try {
      await postsCollection.get().then(
        (value) async {
          for (final postDoc in value.docs) {
            final post = postDoc.data();
            final autherImageUrl =
                await (post['auther ImageUrl'] as DocumentReference)
                    .get()
                    .then((value) => value.get('userImageUrl'));

            // Fetch comments for the post
            final commentsSnapshot =
                await postDoc.reference.collection('comments').get();
            final comments = <CommentModel>[];
            int totalCommentsCount = commentsSnapshot.size;

            for (final commentDoc in commentsSnapshot.docs) {
              final comment = commentDoc.data();
              // Fetch replies for the comment
              final replies = await fetchReplies(commentDoc.reference);
              final repliesCount = await countReplies(commentDoc.reference);

              totalCommentsCount += repliesCount;

              comments.add(CommentModel(
                commentId: commentDoc.id,
                content: comment['content'],
                replies: replies,
              ));
            }

            posts.add(PostModel(
              postId: postDoc.id,
              paragraph: post['paragraph'],
              imageUrl: post['imageUrl'],
              comments: comments,
              autherImageUrl: autherImageUrl,
              autherName: post['auther name'],
              autherId: post['autherId'],
              postTimestamp: post['timestamp'],
              likes: post['likes'],
              totalCommentsCount:
                  totalCommentsCount, // Add this field to your PostModel
            ));
          }
        },
      );
      return posts;
    } catch (e) {
      print(e);
      return posts;
    }
  }

  Future<List<CommentModel>> fetchReplies(DocumentReference commentRef) async {
    final repliesSnapshot = await commentRef.collection('replies').get();
    final replies = <CommentModel>[];

    for (final replyDoc in repliesSnapshot.docs) {
      final reply = replyDoc.data();
      final nestedReplies = await fetchReplies(replyDoc.reference);

      replies.add(CommentModel(
        commentId: replyDoc.id,
        content: reply['content'],
        replies: nestedReplies,
      ));
    }

    return replies;
  }

  Future<int> countReplies(DocumentReference commentRef) async {
    final repliesSnapshot = await commentRef.collection('replies').get();
    int count = repliesSnapshot.size;

    for (final replyDoc in repliesSnapshot.docs) {
      count += await countReplies(replyDoc.reference);
    }

    return count;
  }

  Future<String> uploadImage(
      {required File image, required bool isUserImage}) async {
    try {
      final fileName = isUserImage
          ? FirebaseAuth.instance.currentUser!.uid
          : DateTime.now().millisecondsSinceEpoch.toString();
      final storageRef = FirebaseStorage.instance
          .ref()
          .child(isUserImage ? 'user image' : 'postsImages')
          .child(fileName)
          .child(isUserImage ? 'profile_image.jpg' : 'plant_image.jpg');
      await storageRef.putFile(image);
      final downloadUrl = await storageRef.getDownloadURL();
      print(downloadUrl);
      return downloadUrl;
    } catch (e) {
      print('error in uploadImage :$e');
      rethrow;
    }
  }

  Future<void> savePost(
      String imageUrl, String paragraph, String autherImageUrl) async {
    try {
      await FirebaseFirestore.instance.collection('posts').add({
        'imageUrl': imageUrl,
        'paragraph': paragraph,
        'timestamp': FieldValue.serverTimestamp(),
        'autherId': FirebaseAuth.instance.currentUser!.uid,
        'auther ImageUrl': userCollection.doc(userId),
        'auther name': FirebaseAuth.instance.currentUser!.displayName,
        'coments': [],
        'likes': [],
      });
    } catch (e) {
      print('eroor in savePost :$e');
      rethrow;
    }
  }

  Future<void> saveUserImageInfo(String userId, String downloadUrl) async {
    try {
      final firestoreRef = userCollection.doc(userId);

      // Save the image URL and location in Firestore
      await firestoreRef.set(
          {
            'userImageUrl': downloadUrl,
            'imagePath mainFolder': 'usersImages',
            'imagePath imageFolder': userId,
            'imagePath fileName': 'profile_image.jpg',
          },
          // ignore: lines_longer_than_80_chars
          // Use merge to update existing document without overwriting other fields
          SetOptions(merge: true));

      print('User image info saved successfully.');
    } catch (e) {
      print('Error saving image info to Firestore: $e');
    }
  }

  Future<void> createPost(
      String paragraph, File? image, String autherImageUrl) async {
    try {
      if (image != null) {
        final imageUrl = await uploadImage(image: image, isUserImage: false);
        await savePost(imageUrl, paragraph, autherImageUrl);
      } else {
        savePost('', paragraph, autherImageUrl);
      }
    } catch (e) {
      print('error in createPost :$e');
      rethrow;
    }
  }

  Future<void> uploadAndSaveUserImage(File imageFile) async {
    try {
      // Upload the image
      final downloadUrl =
          await uploadImage(image: imageFile, isUserImage: true);

      // Save the image info in Firestore
      await saveUserImageInfo(userId, downloadUrl);
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> postLike(List likes, String postId) async {
    if (!likes.contains(userId)) {
      likes.add(userId);
    } else {
      likes.removeWhere(
        (element) => element == userId,
      );
    }
    try {
      await postsCollection.doc(postId).update({
        'likes': likes,
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> addComment(String postId, String content) async {
    await postsCollection.doc(postId).collection('comments').add({
      'content': content,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
