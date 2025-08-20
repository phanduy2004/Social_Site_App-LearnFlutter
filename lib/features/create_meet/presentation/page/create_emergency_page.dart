import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:geocoding/geocoding.dart' as geocoding;

import 'package:social_site_app/core/entity/job_type_entity.dart';
import 'package:social_site_app/core/get_it/get_it.dart';
import 'package:social_site_app/core/ui/default_button.dart';
import 'package:social_site_app/core/ui/default_text_field.dart';

import 'package:social_site_app/features/create_meet/presentation/bloc_emergency/create_emergency_bloc.dart';
import 'package:social_site_app/features/create_meet/presentation/page/service_types_checkbox.dart';
import 'package:social_site_app/features/job_type/bloc/job_type_bloc.dart';
import 'package:social_site_app/features/job_type/bloc/job_type_event.dart';
import 'package:social_site_app/features/job_type/bloc/job_type_state.dart';

import '../bloc_emergency/create_emergency_event.dart';
import '../bloc_emergency/create_emergency_state.dart';
import 'location_picker_page.dart';

class CreateEmergencyPage extends StatefulWidget {
  static const String route = '/create_emergency';
  const CreateEmergencyPage({super.key});

  @override
  State<CreateEmergencyPage> createState() => _CreateEmergencyPageState();
}

class _CreateEmergencyPageState extends State<CreateEmergencyPage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();

  GoogleMapController? _mapController;
  LatLng? _location;
  List<JobTypeEntity> _selectedJobTypes = [];

  // UI state
  int _locationInputMode = 0; // 0 = Map, 1 = Address
  double _urgency = 2; // 1..3 (Thấp/Vừa/Cao)
  bool _shareLiveLocation = true;
  bool _geocodingBusy = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<CreateEmergencyBloc>()),
        BlocProvider(create: (_) => getIt<JobTypeBloc>()..add(GetJobTypeEvent())),
      ],
      child: BlocConsumer<CreateEmergencyBloc, CreateEmergencyState>(
        listener: (context, state) {
          if (state.status == CreateEmergencyStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? 'Có lỗi xảy ra')),
            );
          } else if (state.status == CreateEmergencyStatus.success) {
            context.pop(); // quay lại sau khi tạo thành công
          }
        },
        builder: (context, state) {
          if (state.status == CreateEmergencyStatus.loading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator.adaptive()),
            );
          }

          return Scaffold(
            appBar: AppBar(
              title: Text('Tạo yêu cầu hỗ trợ', style: Theme.of(context).textTheme.headlineSmall),
              centerTitle: false,
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label(context, 'Tiêu đề'),
                    const SizedBox(height: 8),
                    DefaultTextField(
                      hintText: 'Ví dụ: Cứu hộ hư xe giữa đường',
                      controller: _titleController,
                      maxLength: 100,
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 16),

                    _label(context, 'Loại hỗ trợ'),
                    const SizedBox(height: 6),
                    _buildServiceTypesSelector(context),
                    const SizedBox(height: 16),

                    _label(context, 'Độ khẩn cấp'),
                    const SizedBox(height: 6),
                    _buildUrgencySlider(),
                    const SizedBox(height: 16),

                    _label(context, 'Mô tả chi tiết'),
                    const SizedBox(height: 6),
                    DefaultTextField(
                      hintText: 'Mô tả tình huống: bể lốp, không đề được, có người bị thương... ',
                      controller: _descriptionController,
                      maxLength: 255,
                      minLines: 2,
                      maxLines: 6,
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 16),

                    _label(context, 'Liên hệ'),
                    const SizedBox(height: 6),
                    DefaultTextField(
                      hintText: 'Số điện thoại liên hệ',
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 16),

                    _label(context, 'Vị trí'),
                    const SizedBox(height: 6),
                    _buildLocationModeTabs(context),
                    const SizedBox(height: 10),
                    if (_locationInputMode == 0) _buildLocationPicker(context) else _buildAddressInput(context),

                    const SizedBox(height: 8),
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      value: _shareLiveLocation,
                      onChanged: (v) => setState(() => _shareLiveLocation = v),
                      title: const Text('Chia sẻ vị trí trực tiếp cho đội hỗ trợ'),
                      subtitle: const Text('Bật để theo dõi lộ trình của bạn (nếu app có tính năng).'),
                    ),

                    const SizedBox(height: 28),
                    DefaultButton(
                      text: 'Gửi yêu cầu',
                      onPressed: _canSubmit
                          ? () async {
                        // Nếu ở tab "Address" mà chưa có tọa độ -> geocode
                        if (_locationInputMode == 1 && _location == null && _addressController.text.trim().isNotEmpty) {
                          await _geocodeFromAddress();
                        }

                        if (!_canSubmit) {
                          _showSnack('Vui lòng nhập đủ thông tin và vị trí.');
                          return;
                        }

                        final desc = _buildDescriptionWithExtras();
                        final List<String> serviceIds = _mapJobTypesToIds(_selectedJobTypes);

                        context.read<CreateEmergencyBloc>().add(
                          CreateEmergencyEvent(
                            title: _titleController.text.trim(),
                            contactPhone: _phoneController.text.trim(),
                            urgency: _toUrgencyString(_urgency), // 'low'|'medium'|'high'
                            description: desc,
                            location: _location!, // đảm bảo không null sau geocode/map
                            services: serviceIds, // List<String>?
                            shareLiveLocation: _shareLiveLocation,
                            scheduledAt: null,
                          ),
                        );
                      }
                          : null,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// ===================== Widgets =====================
  Widget _buildServiceTypesSelector(BuildContext context) {
    return BlocBuilder<JobTypeBloc, JobTypeState>(
      builder: (context, jobTypeState) {
        final isBusy = jobTypeState.status == JobTypeStatus.loading || jobTypeState.status == JobTypeStatus.error;

        return InkWell(
          onTap: isBusy
              ? null
              : () async {
            final selected = await showDialog<List<JobTypeEntity>>(
              context: context,
              builder: (context) => ServiceTypesCheckbox(selectedItems: _selectedJobTypes),
            );
            if (selected != null) {
              setState(() => _selectedJobTypes = selected);
            }
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _selectedJobTypes.isEmpty ? 'Chọn loại hỗ trợ' : _selectedJobTypes.map((e) => e.name).join(', '),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down_rounded),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildUrgencySlider() {
    String label(double v) => v <= 1.5 ? 'Thấp' : (v < 2.5 ? 'Vừa' : 'Cao');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Slider(
          min: 1,
          max: 3,
          divisions: 2,
          value: _urgency,
          label: label(_urgency),
          onChanged: (v) => setState(() => _urgency = v),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [Text('Thấp'), Text('Vừa'), Text('Cao')],
        ),
      ],
    );
  }

  Widget _buildLocationModeTabs(BuildContext context) {
    return SegmentedButton<int>(
      segments: const [
        ButtonSegment(value: 0, label: Text('Chọn trên bản đồ'), icon: Icon(Icons.map_outlined)),
        ButtonSegment(value: 1, label: Text('Nhập địa chỉ'), icon: Icon(Icons.place_outlined)),
      ],
      selected: {_locationInputMode},
      onSelectionChanged: (s) => setState(() => _locationInputMode = s.first),
    );
  }

  Widget _buildAddressInput(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DefaultTextField(
          hintText: 'Ví dụ: 1 Võ Văn Ngân, Thủ Đức, TP.HCM',
          controller: _addressController,
          minLines: 1,
          maxLines: 2,
          onChanged: (_) => setState(() {}),
          suffixIcon: _geocodingBusy
              ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
              : IconButton(
            onPressed: _geocodeFromAddress,
            icon: const Icon(Icons.search),
            tooltip: 'Tìm toạ độ từ địa chỉ',
          ),
        ),
        const SizedBox(height: 8),
        if (_location != null)
          Text(
            'Tọa độ: ${_location!.latitude.toStringAsFixed(6)}, ${_location!.longitude.toStringAsFixed(6)}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
      ],
    );
  }

  Widget _buildLocationPicker(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 260,
          width: double.maxFinite,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          child: GoogleMap(
            myLocationEnabled: false,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            onMapCreated: (controller) => _mapController = controller,
            onTap: (_) async {
              final selectedLocation = await context.push(LocationPickerPage.route);
              if (selectedLocation != null) {
                setState(() => _location = selectedLocation as LatLng);
                await _mapController?.animateCamera(
                  CameraUpdate.newLatLngZoom(_location!, 15),
                );
              }
            },
            markers: _location != null
                ? {Marker(markerId: const MarkerId('selectedLocation'), position: _location!)}
                : {},
            initialCameraPosition: const CameraPosition(
              target: LatLng(10.7769, 106.7009),
              zoom: 12,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text('Chạm bản đồ để mở trình chọn vị trí', style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  /// ===================== Helpers =====================
  bool get _canSubmit {
    final hasTitle = _titleController.text.trim().isNotEmpty;
    final hasDesc = _descriptionController.text.trim().isNotEmpty;
    final hasJob = _selectedJobTypes.isNotEmpty;

    final hasLocation = _location != null;
    final hasAddress = _addressController.text.trim().isNotEmpty;

    // Chấp nhận: có location (map) HOẶC có address (text)
    final hasPosition = hasLocation || hasAddress;

    // Nếu đang ở tab Address, cho phép submit khi có address (location có thể null)
    // Nếu đang ở tab Map, yêu cầu có location
    final validPosition = _locationInputMode == 1 ? hasPosition : hasLocation;

    // Optional: yêu cầu phone nếu muốn
    final hasPhone = _phoneController.text.trim().length >= 9;

    return hasTitle && hasDesc && hasJob && validPosition && hasPhone;
  }

  Future<void> _geocodeFromAddress() async {
    final addr = _addressController.text.trim();
    if (addr.isEmpty) {
      _showSnack('Nhập địa chỉ trước');
      return;
    }
    setState(() => _geocodingBusy = true);
    try {
      final results = await geocoding.locationFromAddress(addr);
      if (results.isEmpty) {
        _showSnack('Không tìm thấy toạ độ cho địa chỉ');
        return;
      }
      final first = results.first;
      setState(() => _location = LatLng(first.latitude, first.longitude));
      await _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(_location!, 16),
      );
    } catch (e) {
      _showSnack('Không tìm được vị trí: $e');
    } finally {
      if (mounted) setState(() => _geocodingBusy = false);
    }
  }

  String _urgencyLabel(double v) => v <= 1.5 ? 'Thấp' : (v < 2.5 ? 'Vừa' : 'Cao');

  String _toUrgencyString(double v) {
    if (v <= 1.5) return 'low';
    if (v < 2.5) return 'medium';
    return 'high';
  }

  /// Tạm nhúng address/urgency/phone/live location vào description để không cần đổi backend
  String _buildDescriptionWithExtras() {
    final base = _descriptionController.text.trim();
    final address = _addressController.text.trim();
    final extras = [
      if (address.isNotEmpty) 'Địa chỉ: $address',
      if (_location != null) 'Tọa độ: ${_location!.latitude}, ${_location!.longitude}',
      'Khẩn cấp: ${_urgencyLabel(_urgency)}',
      if (_phoneController.text.trim().isNotEmpty) 'Liên hệ: ${_phoneController.text.trim()}',
      'Live location: ${_shareLiveLocation ? 'Bật' : 'Tắt'}',
    ].join(' | ');
    return base.isEmpty ? extras : '$base\n\n$extras';
  }

  /// Map danh sách JobTypeEntity => List<String> id để gọi API
  List<String> _mapJobTypesToIds(List<JobTypeEntity> items) {
    // TODO: đổi 'id' nếu mô hình của bạn dùng field khác (vd: jobTypeId)
    return items.map((e) => e.id).whereType<String>().toList();
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Widget _label(BuildContext context, String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 16, fontWeight: FontWeight.w600),
    );
  }
}
