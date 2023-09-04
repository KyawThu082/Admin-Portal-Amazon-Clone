import 'package:admin_web_portal/widget/nav_appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';

class SellersPieChartScreen extends StatefulWidget {
  const SellersPieChartScreen({super.key});

  @override
  State<SellersPieChartScreen> createState() => _SellersPieChartScreenState();
}

class _SellersPieChartScreenState extends State<SellersPieChartScreen> {
  int totalNumberOfVerifiedSellers = 0;
  int totolNumberOfBlockedSellers = 0;

  getTotalNumberOfVerifiedSellers() async {
    FirebaseFirestore.instance
        .collection("sellers")
        .where("status", isEqualTo: "approved")
        .get()
        .then((allVerifiedSellers) {
      setState(() {
        totalNumberOfVerifiedSellers = allVerifiedSellers.docs.length;
      });
    });
  }

  getTotalNumberOfBlockedSellers() async {
    FirebaseFirestore.instance
        .collection("sellers")
        .where("status", isEqualTo: "not approved")
        .get()
        .then((allBlockedSellers) {
      setState(() {
        totolNumberOfBlockedSellers = allBlockedSellers.docs.length;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getTotalNumberOfVerifiedSellers();
    getTotalNumberOfBlockedSellers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: NavAppBar(
        title: "iShot",
      ),
      body: DChartPie(
        data: [
          {'domain': 'Blocked Sellers', 'measure': totolNumberOfBlockedSellers},
          {
            'domain': 'Verified Sellers',
            'measure': totalNumberOfVerifiedSellers
          }
        ],
        fillColor: (pieData, index) {
          switch (pieData['domain']) {
            case 'Blocked Sellers':
              return Colors.pinkAccent;
            case 'Verified Sellers':
              return Colors.deepPurpleAccent;
            default:
              return Colors.grey;
          }
        },
        labelFontSize: 20,
        animate: false,
        pieLabel: (pieData, index) {
          return "${pieData['domain']}";
        },
        labelColor: Colors.white,
        strokeWidth: 6,
      ),
    );
  }
}
