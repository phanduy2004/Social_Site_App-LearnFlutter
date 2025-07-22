import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_site_app/core/entity/job_type_entity.dart';
import '../../../job_type/bloc/job_type_bloc.dart';
import '../../../job_type/bloc/job_type_event.dart';
import '../../../job_type/bloc/job_type_state.dart';

class ServiceTypesCheckbox extends StatefulWidget {
  final List<JobTypeEntity> selectedItems;

  const ServiceTypesCheckbox({
    super.key,
    required this.selectedItems,
  });

  @override
  State<ServiceTypesCheckbox> createState() => _ServiceTypesCheckboxState();
}

class _ServiceTypesCheckboxState extends State<ServiceTypesCheckbox> {
  late List<JobTypeEntity> _tempSelectedItems;

  @override
  void initState() {
    super.initState();
    _tempSelectedItems = List.from(widget.selectedItems);
    context.read<JobTypeBloc>().add(GetJobTypeEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<JobTypeBloc, JobTypeState>(
      builder: (context, jobTypeState) {
        if (jobTypeState.status == JobTypeStatus.loading) {
          return const AlertDialog(
            title: Text('Chọn dịch vụ'),
            content: Center(child: CircularProgressIndicator.adaptive()),
          );
        }
        if (jobTypeState.status == JobTypeStatus.error) {
          return AlertDialog(
            title: const Text('Chọn dịch vụ'),
            content: Text('Lỗi: ${jobTypeState.errorMessage ?? 'Không tải được danh sách dịch vụ'}'),
            actions: [
              TextButton(
                child: const Text('Hủy'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        }
        return AlertDialog(
          title: const Text('Chọn dịch vụ'),
          content: SingleChildScrollView(
            child: ListBody(
              children: jobTypeState.jobTypes.map((jobType) {
                return CheckboxListTile(
                  title: Text(jobType.name!),
                  value: _tempSelectedItems.contains(jobType),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        _tempSelectedItems.add(jobType);
                      } else {
                        _tempSelectedItems.remove(jobType);
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Hủy'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text('Xác nhận'),
              onPressed: () => Navigator.pop(context, _tempSelectedItems),
            ),
          ],
        );
      },
    );
  }
}