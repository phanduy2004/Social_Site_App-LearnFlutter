import 'package:flutter/material.dart';
import 'package:social_site_app/features/profile/presentation/bloc/last_meets_bloc.dart';
import 'package:social_site_app/features/profile/presentation/bloc/last_meets_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'last_meets_widget.dart';

class LastMeetsSection extends StatelessWidget {
  const LastMeetsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          BlocBuilder<LastMeetsBloc, LastMeetsState>(
            builder: (context, state) {
              if (state.status == LastMeetsStatus.loading) {
                return Center(child: CircularProgressIndicator());
              }
              if (state.status == LastMeetsStatus.error) {
                return Center(child: Text('Error: ${state.status}'));
              }
              if (state.lastMeets == null || state.lastMeets!.isEmpty) {
                return Center(child: Text('No meets available'));
              }
              return ListView.separated(
                itemBuilder: (context, index) {
                  return LastMeetsWidget(meetEntity: state.lastMeets![index]);
                },
                separatorBuilder: (context, index) => SizedBox(height: 10),
                itemCount: state.lastMeets!.length,
                shrinkWrap: true,
                physics: AlwaysScrollableScrollPhysics(),
              );
            },
          )
        ],
      ),
    );
  }
}
