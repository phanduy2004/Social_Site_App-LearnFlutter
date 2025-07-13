import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:social_site_app/core/entity/job_type_entity.dart';
import 'package:social_site_app/core/get_it/get_it.dart';
import 'package:social_site_app/core/ui/default_button.dart';
import 'package:social_site_app/core/ui/default_text_field.dart';
import 'package:go_router/go_router.dart';
import 'package:social_site_app/features/create_meet/presentation/bloc/create_meet_bloc.dart';
import 'package:social_site_app/features/create_meet/presentation/bloc/create_meet_event.dart';
import 'package:social_site_app/features/create_meet/presentation/bloc/create_meet_status.dart';
import 'package:social_site_app/features/create_meet/presentation/page/service_types_checkbox.dart';
import 'package:social_site_app/features/job_type/bloc/job_type_bloc.dart';
import 'package:social_site_app/features/job_type/bloc/job_type_event.dart';
import 'package:social_site_app/features/profile/presentation/bloc/last_meets_bloc.dart';
import 'package:social_site_app/features/profile/presentation/bloc/last_meets_event.dart';
import '../../../job_type/bloc/job_type_state.dart';
import 'location_picker_page.dart';

class CreateMeetPage extends StatefulWidget {
  static const String route = '/create_meet';

  const CreateMeetPage({super.key});

  @override
  State<CreateMeetPage> createState() => _CreateMeetPageState();
}

class _CreateMeetPageState extends State<CreateMeetPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  GoogleMapController? _mapController;
  TimeOfDay timeOfDay = TimeOfDay.now();
  LatLng? location;
  List<JobTypeEntity> selectedJobTypes = [];

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<CreateMeetBloc>()),
        BlocProvider(create: (context) => getIt<JobTypeBloc>()..add(GetJobTypeEvent())),
      ],
      child: BlocConsumer<CreateMeetBloc, CreateMeetState>(
        listener: (context, state) {
          if (state.status == CreateMeetStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? 'Có lỗi xảy ra')),
            );
          } else if (state.status == CreateMeetStatus.success) {
            context.pop();
          }
        },
        builder: (context, state) {
          if (state.status == CreateMeetStatus.loading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator.adaptive()),
            );
          }
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Tạo Cuộc Gặp',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              centerTitle: false,
            ),
            body: SingleChildScrollView(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tiêu đề',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      DefaultTextField(
                        hintText: 'Nhập tiêu đề...',
                        controller: _titleController,
                        maxLength: 100,
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        'Loại dịch vụ',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 5),
                      _buildServiceTypesSelector(context),
                      const SizedBox(height: 15),
                      Text(
                        'Mô tả',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      DefaultTextField(
                        hintText: 'Mô tả cuộc gặp...',
                        controller: _descriptionController,
                        maxLength: 255,
                        minLines: 1,
                        maxLines: 6,
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Thời gian',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Sự kiện sẽ tự động đánh dấu hoàn thành sau 2 giờ kể từ khi bắt đầu.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(.8),
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildTimePicker(context),
                      const SizedBox(height: 10),
                      Text(
                        'Vị trí',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Chạm vào bản đồ để chọn vị trí',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildLocationPicker(context),
                      const SizedBox(height: 40),
                      DefaultButton(
                        text: 'Tạo',
                        onPressed: (location == null ||
                            _titleController.text.isEmpty ||
                            _descriptionController.text.isEmpty ||
                            selectedJobTypes.isEmpty)
                            ? null
                            : () {
                          context.read<CreateMeetBloc>().add(
                            CreateMeetEvent(
                              title: _titleController.text,
                              description: _descriptionController.text,
                              time: timeOfDay,
                              location: location!,
                              jobTypes: selectedJobTypes
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildServiceTypesSelector(BuildContext context) {
    return BlocBuilder<JobTypeBloc, JobTypeState>(
      builder: (context, jobTypeState) {
        return InkWell(
          onTap: jobTypeState.status == JobTypeStatus.loading ||
              jobTypeState.status == JobTypeStatus.error
              ? null
              : () async {
            final selected = await showDialog<List<JobTypeEntity>>(
              context: context,
              builder: (context) => ServiceTypesCheckbox(
                selectedItems: selectedJobTypes,
              ),
            );
            if (selected != null) {
              setState(() {
                selectedJobTypes = selected;
              });
            }
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              selectedJobTypes.isEmpty
                  ? 'Chọn loại dịch vụ'
                  : selectedJobTypes.map((e) => e.name).join(', '),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        );
      },
    );
  }

  Widget _buildTimePicker(BuildContext context) {
    return Row(
      children: [
        _buildTimePart(context, timeOfDay.hour),
        const SizedBox(width: 5),
        Text(':', style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(width: 5),
        _buildTimePart(context, timeOfDay.minute),
      ],
    );
  }

  Widget _buildTimePart(BuildContext context, int value) {
    return InkWell(
      onTap: () async {
        final time = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
          initialEntryMode: TimePickerEntryMode.inputOnly,
        );
        if (time != null) {
          setState(() {
            timeOfDay = time;
          });
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(12),
        child: Text(
          value.toString().padLeft(2, '0'),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildLocationPicker(BuildContext context) {
    return Container(
      height: 300,
      width: double.maxFinite,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: GoogleMap(
        myLocationEnabled: false,
        compassEnabled: false,
        myLocationButtonEnabled: false,
        scrollGesturesEnabled: false,
        zoomGesturesEnabled: false,
        tiltGesturesEnabled: false,
        rotateGesturesEnabled: false,
        zoomControlsEnabled: false,
        onMapCreated: (controller) {
          setState(() {
            _mapController = controller;
          });
        },
        onTap: (_) async {
          final selectedLocation = await context.push(LocationPickerPage.route);
          if (selectedLocation != null) {
            setState(() {
              location = selectedLocation as LatLng;
            });
            _mapController?.animateCamera(
              CameraUpdate.newLatLngZoom(selectedLocation as LatLng, 15),
            );
          }
        },
        markers: location != null
            ? {
          Marker(
            markerId: const MarkerId('selectedLocation'),
            position: location!,
          ),
        }
            : {},
        initialCameraPosition: const CameraPosition(
          target: LatLng(10.7769, 106.7009), // TP. Hồ Chí Minh
          zoom: 10,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _mapController?.dispose();
    super.dispose();
  }
}