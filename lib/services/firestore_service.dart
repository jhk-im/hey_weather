import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:logger/logger.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final logger = Logger();

  Future<void> initialTokenAndDefaultAlarms() async {
    String? token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      logger.i("FCM Token and Alarm Time init: $token");
      await _db.collection('users').doc(token).set({
        'token': token,
        'alarms': {
          '07:00': {'enabled': true},
          '17:00': {'enabled': true}
        },
        'createdAt': FieldValue.serverTimestamp(),
      });
    } else {
      logger.e("Failed to get FCM token");
    }
  }

  Future<void> updateAlarm(
      DateTime prevTime, DateTime updateTime, bool isEnabled) async {
    String? token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      logger.i("FCM Token and Alarm update: $token");
      String prevAlarmKey =
          prevTime.toIso8601String().split('T')[1].substring(0, 5);
      // 기존 알람 삭제
      await _db.collection('users').doc(token).update({
        'alarms.$prevAlarmKey': FieldValue.delete(),
      });

      String updateAlarmKey =
          updateTime.toIso8601String().split('T')[1].substring(0, 5);
      await _db.collection('users').doc(token).update({
        'alarms.$updateAlarmKey': {
          'enabled': isEnabled,
        },
      });
    } else {
      logger.e("Failed to get FCM token");
    }
  }

  Future<void> updateAllAlarm(bool isEnabled) async {
    String? token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      logger.i("FCM Token and Alarm updateAll: $token");
      DocumentSnapshot doc = await _db.collection('users').doc(token).get();

      if (doc.exists) {
        Map<String, dynamic> alarms = doc['alarms'];

        alarms.forEach((key, value) {
          alarms[key]['enabled'] = isEnabled;
        });

        await _db.collection('users').doc(token).update({
          'alarms': alarms,
        });
      }
    } else {
      logger.e("Failed to get FCM token");
    }
  }

  Future<void> updateAlarmEnabled(DateTime alarmTime, bool isEnabled) async {
    String? token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      logger.i("FCM Token and Alarm Enabled: $token");
      String alarmKey =
          alarmTime.toIso8601String().split('T')[1].substring(0, 5);
      await _db.collection('users').doc(token).update({
        'alarms.$alarmKey.enabled': isEnabled,
      });
    } else {
      logger.e("Failed to get FCM token");
    }
  }

  // Future<Map<String, dynamic>?> getUserAlarms(String token) async {
  //   DocumentSnapshot doc = await _db.collection('users').doc(token).get();
  //   return doc.exists ? doc.data() as Map<String, dynamic>? : null;
  // }
}
