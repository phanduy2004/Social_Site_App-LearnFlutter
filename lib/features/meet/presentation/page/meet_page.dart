import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_site_app/core/get_it/get_it.dart';
import 'package:social_site_app/features/meet/presentation/bloc/meet_bloc.dart';
import 'package:social_site_app/features/meet/presentation/bloc/meet_event.dart';
import 'package:social_site_app/features/meet/presentation/bloc/meet_state.dart';
import 'package:social_site_app/features/meet/presentation/widget/meet_attendees_section.dart';
import 'package:social_site_app/features/meet/presentation/widget/meet_bottom_button.dart';
import 'package:social_site_app/features/meet/presentation/widget/meet_details_section.dart';
import 'package:social_site_app/features/meet/presentation/widget/meet_location_section.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_site_app/core/get_it/get_it.dart';
import 'package:social_site_app/features/meet/presentation/bloc/meet_bloc.dart';
import 'package:social_site_app/features/meet/presentation/bloc/meet_event.dart';
import 'package:social_site_app/features/meet/presentation/bloc/meet_state.dart';
import 'package:social_site_app/features/meet/presentation/widget/meet_attendees_section.dart';
import 'package:social_site_app/features/meet/presentation/widget/meet_bottom_button.dart';
import 'package:social_site_app/features/meet/presentation/widget/meet_details_section.dart';
import 'package:social_site_app/features/meet/presentation/widget/meet_location_section.dart';

class MeetPage extends StatelessWidget {
  final String meetId;

  static String route(String meetId) => '/meet/$meetId';

  const MeetPage({super.key, required this.meetId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<MeetBloc>()..add(GetMeetEvent(meetId: meetId)),
      child: BlocConsumer<MeetBloc, MeetState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Meet from ${state.meetEntity?.admin.name}',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(20),
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        MeetDetailsSection(),
                        SizedBox(height: 10,),
                        MeetAttendeesSection(),
                        SizedBox(height: 10,),
                        MeetLocationSection(),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Spacer(),
                      MeetBottomButtons(),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
