import 'package:desaihomes_crm_application/presentations/lead_detail_screen/view/widgets/status_button.dart';
import 'package:desaihomes_crm_application/presentations/lead_screen/view/widgets/lead_card.dart';
import 'package:flutter/material.dart';

class FollowUpScreen extends StatelessWidget {
  const FollowUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // StatusButton(),
          // Padding(
          //   padding: EdgeInsets.all(15.0),
          //   child: 
          //   LeadCard(
          //     name: 'Jishnu Ambadi',
          //     location: 'DD Queens square',
          //     platform: 'Facebook',
          //     timeAgo: '6 hours ago',
          //     initials: 'JA', status: 'Booked',
          //   ),
          // )
        ],
      ),
    );
  }
}
