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
import 'package:social_site_app/features/create_meet/presentation/bloc/create_meet_bloc.dart';
import 'package:social_site_app/features/create_meet/presentation/bloc/create_meet_event.dart';
import 'package:social_site_app/features/create_meet/presentation/bloc/create_meet_status.dart';
import 'package:social_site_app/features/create_meet/presentation/page/service_types_checkbox.dart';
import 'package:social_site_app/features/job_type/bloc/job_type_bloc.dart';
import 'package:social_site_app/features/job_type/bloc/job_type_event.dart';
import 'package:social_site_app/features/job_type/bloc/job_type_state.dart';
import 'location_picker_page.dart';

/// ------------------------------
/// CreateMeetPage (Emergency) — Drop‑in replacement
///
/// Tập trung vào use case "gọi hỗ trợ khẩn cấp":
/// - Chọn loại hỗ trợ (tận dụng JobTypeEntity có sẵn)
/// - Chọn vị trí bằng bản đồ hoặc nhập địa chỉ tay (EditText)
/// - Độ khẩn cấp (slider), SĐT liên hệ, mô tả chi tiết
/// - Validate: phải chọn 1 trong 2 (location | address)
///
/// Notes tích hợp nhanh với BLoC hiện tại:
/// - Giữ nguyên CreateMeetEvent(title, description, time, location, jobTypes)
/// - Thêm address/urgency/phone/shareLiveLocation nếu muốn => cần mở rộng CreateMeetEvent + backend (// TODO)
/// ------------------------------
class CreateMeetPage extends StatefulWidget {
  static const String route = '/create_meet';

  const CreateMeetPage({super.key});

  @override
  State<CreateMeetPage> createState() => _CreateMeetPageState();
}

class _CreateMeetPageState extends State<CreateMeetPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  GoogleMapController? _mapController;
  TimeOfDay timeOfDay = TimeOfDay.now();
  LatLng? location;
  List<JobTypeEntity> selectedJobTypes = [];

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
        BlocProvider(create: (context) => getIt<CreateMeetBloc>()),
        BlocProvider(
          create: (context) => getIt<JobTypeBloc>()..add(GetJobTypeEvent()),
        ),
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
                'Tạo yêu cầu hỗ trợ',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              centerTitle: false,
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 20,
                ),
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
                      hintText:
                          'Mô tả tình huống: bể lốp, không đề được, có người bị thương... ',
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
                    if (_locationInputMode == 0)
                      _buildLocationPicker(context)
                    else
                      _buildAddressInput(context),

                    const SizedBox(height: 8),
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      value: _shareLiveLocation,
                      onChanged: (v) => setState(() => _shareLiveLocation = v),
                      title: const Text(
                        'Chia sẻ vị trí trực tiếp cho đội hỗ trợ',
                      ),
                      subtitle: const Text(
                        'Bật để theo dõi lộ trình của bạn (nếu app có tính năng).',
                      ),
                    ),

                    const SizedBox(height: 28),
                    DefaultButton(
                      text: 'Gửi yêu cầu',
                      onPressed: _canSubmit
                          ? () async {
                              // (Optional) geocode nếu đang ở tab địa chỉ mà chưa có toạ độ
                              if (_locationInputMode == 1 &&
                                  location == null &&
                                  _addressController.text.trim().isNotEmpty) {
                                await _geocodeFromAddress();
                              }

                              if (!_canSubmit) {
                                _showSnack(
                                  'Vui lòng nhập đủ thông tin và vị trí.',
                                );
                                return;
                              }

                              // TODO: Mở rộng CreateMeetEvent để truyền thêm address/urgency/phone/shareLiveLocation
                              context.read<CreateMeetBloc>().add(
                                CreateMeetEvent(
                                  title: _titleController.text.trim(),
                                  description: _buildDescriptionWithExtras(),
                                  time: timeOfDay,
                                  location: location!,
                                  jobTypes: selectedJobTypes,
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

  /// ========== Widgets ==========
  Widget _buildServiceTypesSelector(BuildContext context) {
    return BlocBuilder<JobTypeBloc, JobTypeState>(
      builder: (context, jobTypeState) {
        final isBusy =
            jobTypeState.status == JobTypeStatus.loading ||
            jobTypeState.status == JobTypeStatus.error;
        return InkWell(
          onTap: isBusy
              ? null
              : () async {
                  final selected = await showDialog<List<JobTypeEntity>>(
                    context: context,
                    builder: (context) =>
                        ServiceTypesCheckbox(selectedItems: selectedJobTypes),
                  );
                  if (selected != null) {
                    setState(() => selectedJobTypes = selected);
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
                    selectedJobTypes.isEmpty
                        ? 'Chọn loại hỗ trợ'
                        : selectedJobTypes.map((e) => e.name).join(', '),
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
        ButtonSegment(
          value: 0,
          label: Text('Chọn trên bản đồ'),
          icon: Icon(Icons.map_outlined),
        ),
        ButtonSegment(
          value: 1,
          label: Text('Nhập địa chỉ'),
          icon: Icon(Icons.place_outlined),
        ),
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
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : IconButton(
                  onPressed: _geocodeFromAddress,
                  icon: const Icon(Icons.search),
                  tooltip: 'Tìm toạ độ từ địa chỉ',
                ),
        ),
        const SizedBox(height: 8),
        if (location != null)
          Text(
            'Tọa độ: ${location!.latitude.toStringAsFixed(6)}, ${location!.longitude.toStringAsFixed(6)}',
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
              final selectedLocation = await context.push(
                LocationPickerPage.route,
              );
              if (selectedLocation != null) {
                setState(() => location = selectedLocation as LatLng);
                await _mapController?.animateCamera(
                  CameraUpdate.newLatLngZoom(location!, 15),
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
              target: LatLng(10.7769, 106.7009),
              zoom: 12,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Chạm bản đồ để mở trình chọn vị trí',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  /// ========== Helpers ==========
  bool get _canSubmit {
    final hasTitle = _titleController.text.trim().isNotEmpty;
    final hasDesc = _descriptionController.text.trim().isNotEmpty;
    final hasJob = selectedJobTypes.isNotEmpty;

    final hasLocation = location != null;
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
      setState(() => location = LatLng(first.latitude, first.longitude));
      await _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(location!, 16),
      );
    } catch (e) {
      _showSnack('Không tìm được vị trí: $e');
    } finally {
      if (mounted) setState(() => _geocodingBusy = false);
    }
  }

  String _urgencyLabel(double v) =>
      v <= 1.5 ? 'Thấp' : (v < 2.5 ? 'Vừa' : 'Cao');

  String _buildDescriptionWithExtras() {
    // Tạm nhúng thêm thông tin phụ vào description để không phải sửa BLoC ngay.
    final base = _descriptionController.text.trim();
    final address = _addressController.text.trim();
    final extras = [
      if (address.isNotEmpty) 'Địa chỉ: $address',
      if (location != null)
        'Tọa độ: ${location!.latitude}, ${location!.longitude}',
      'Khẩn cấp: ${_urgencyLabel(_urgency)}',
      if (_phoneController.text.trim().isNotEmpty)
        'Liên hệ: ${_phoneController.text.trim()}',
      'Live location: ${_shareLiveLocation ? 'Bật' : 'Tắt'}',
    ].join(' | ');
    return base.isEmpty ? extras : '$base\n\n$extras';
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Widget _label(BuildContext context, String text) => Text(
    text,
    style: Theme.of(
      context,
    ).textTheme.bodyLarge?.copyWith(fontSize: 16, fontWeight: FontWeight.w600),
  );
}
