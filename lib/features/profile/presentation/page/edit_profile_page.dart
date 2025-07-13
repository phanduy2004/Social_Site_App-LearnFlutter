import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_site_app/core/entity/job_entity.dart';
import 'package:social_site_app/core/ui/default_button.dart';
import 'package:social_site_app/features/auth/presentation/bloc/user_bloc.dart';
import 'package:social_site_app/features/auth/presentation/bloc/user_event.dart';
import 'package:social_site_app/features/auth/presentation/bloc/user_state.dart';
import 'package:social_site_app/features/job_type/bloc/job_type_event.dart';
import 'package:social_site_app/features/profile/presentation/widgets/circle_user_avatar.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/ui/default_text_field.dart';
import 'package:go_router/go_router.dart';
import '../../../job_type/bloc/job_type_bloc.dart';
import '../../../job_type/bloc/job_type_state.dart';

class EditProfilePage extends StatefulWidget {
  static const String route = '/edit_profile';

  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  File? _avatarFile;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final Set<JobEntity> _selectedJobIds = {};

  @override
  void initState() {
    super.initState();
    final user = context.read<UserBloc>().state.userEntity;
    _nameController.text = user?.name ?? '';
    _bioController.text = user?.bio ?? '';
    _selectedJobIds.addAll(user?.jobs ?? []);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (context.read<JobTypeBloc>().state.status != JobTypeStatus.success) {
      context.read<JobTypeBloc>().add(GetJobTypeEvent());
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: false,
      ),
      body: BlocConsumer<UserBloc, UserState>(
        builder: (context, userState) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height - kToolbarHeight - 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: InkWell(
                        onTap: () async {
                          var image = await ImagePicker().pickImage(source: ImageSource.gallery);
                          if (image != null) {
                            setState(() {
                              _avatarFile = File(image.path);
                            });
                          }
                        },
                        child: _avatarFile != null
                            ? ClipOval(
                          child: Image.file(
                            _avatarFile!,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        )
                            : CircleUserAvatar(
                          width: 100,
                          height: 100,
                          url: userState.userEntity?.avatar,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text('Name', style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 10),
                    DefaultTextField(
                      hintText: 'Enter your name',
                      controller: _nameController,
                    ),
                    const SizedBox(height: 10),
                    Text('Bio', style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 10),
                    DefaultTextField(
                      hintText: 'Writing something about you...',
                      controller: _bioController,
                      minLines: 1,
                      maxLines: 2,
                      maxLength: 60,
                    ),
                    const SizedBox(height: 10),
                    Text('Job Types', style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 10),
                    BlocBuilder<JobTypeBloc, JobTypeState>(
                      builder: (context, jobTypeState) {
                        if (jobTypeState.status == JobTypeStatus.loading) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (jobTypeState.status == JobTypeStatus.error) {
                          return Text('Lỗi: ${jobTypeState.errorMessage ?? 'Không xác định'}');
                        }
                        if (jobTypeState.status == JobTypeStatus.success && jobTypeState.jobTypes.isNotEmpty) {
                          final jobTypes = jobTypeState.jobTypes;
                          return SizedBox(
                            height: 100, // Giới hạn chiều cao để tránh tràn
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: jobTypes.map((jobType) {
                                  final isSelected = _selectedJobIds.any((job) => job.job.id == jobType.id);
                                  return ChoiceChip(
                                    label: Text(jobType.name ?? 'Unnamed', style: Theme.of(context).textTheme.bodyLarge),
                                    selected: isSelected,
                                    onSelected: (selected) {
                                      setState(() {
                                        if (selected) {
                                          _selectedJobIds.add(JobEntity(
                                            id: '',
                                            job: jobType,
                                            level: 'basic',
                                            pointsPerHour: 0,
                                            description: '',
                                            user: userState.userEntity!.id
                                          ));
                                        } else {
                                          _selectedJobIds.removeWhere((job) => job.job.id == jobType.id);
                                        }
                                      });
                                    },
                                    selectedColor: Theme.of(context).colorScheme.error,
                                    backgroundColor: Theme.of(context).colorScheme.surface,                                  );
                                }).toList(),
                              ),
                            ),
                          );
                        }
                        return const Text('Không có dữ liệu job type');
                      },
                    ),
                    const SizedBox(height: 20),
                    DefaultButton(
                      text: 'Save',
                      onPressed: () {
                        context.read<UserBloc>().add(EditProfileEvent(
                          name: _nameController.text,
                          bio: _bioController.text,
                          avatar: _avatarFile,
                          jobs: _selectedJobIds.toList(),
                        ));
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        listener: (context, state) {
          if (state.status == UserStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? 'Lỗi không xác định')),
            );
          }
          if (state.status == UserStatus.successfullyEditedProfile) {
            context.pop();
          }
        },
      ),
    );
  }
}