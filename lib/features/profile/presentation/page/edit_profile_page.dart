import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_site_app/core/ui/default_button.dart';
import 'package:social_site_app/features/auth/presentation/bloc/user_bloc.dart';
import 'package:social_site_app/features/auth/presentation/bloc/user_event.dart';
import 'package:social_site_app/features/auth/presentation/bloc/user_state.dart';
import 'package:social_site_app/features/profile/presentation/widgets/circle_user_avatar.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/ui/default_text_field.dart';
import 'package:go_router/go_router.dart';

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

  @override
  void initState() {
    super.initState();
    var name = context.read<UserBloc>().state.userEntity?.name ?? '';
    var bio = context.read<UserBloc>().state.userEntity?.bio ?? '';
    _nameController.text = name;
    _bioController.text = bio;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: Theme
              .of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: false,
      ),
      body: BlocConsumer<UserBloc, UserState>(
        builder: (context, state) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: InkWell(
                      onTap: () async {
                        var image = await ImagePicker().pickImage(
                          source: ImageSource.gallery,
                        );
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
                        url: state.userEntity?.avatar,
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Text('Name', style: Theme
                      .of(context)
                      .textTheme
                      .bodyMedium,),
                  SizedBox(height: 10,),
                  DefaultTextField(
                    hintText: 'Enter your name',
                    controller: _nameController,
                  ),
                  SizedBox(height: 10,),
                  Text('Bio', style: Theme
                      .of(context)
                      .textTheme
                      .bodyMedium,),
                  SizedBox(height: 10,),
                  DefaultTextField(
                    hintText: 'Writing something about you...',
                    controller: _bioController,
                    minLines: 1,
                    maxLines: 2,
                    maxLength: 60,
                  ),
                  Spacer(),
                  DefaultButton(
                    text: 'Save',
                    onPressed: (){
                      context.read<UserBloc>().add(EditProfileEvent(name: _nameController.text, bio: _bioController.text, avatar: _avatarFile));
                    },
                  )
                ],
              ),
            ),
          );
        },
        listener: (context, state) {
          if(state.status == UserStatus.error){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${state.errorMessage}')));
          }
          if(state.status == UserStatus.successfullyEditedProfile){
            context.pop();
          }

      },
      ),
    );
  }
}
