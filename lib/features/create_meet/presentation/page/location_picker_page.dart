import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_site_app/core/get_it/get_it.dart';
import 'package:social_site_app/core/ui/default_button.dart';
import 'package:social_site_app/features/create_meet/presentation/bloc/location_picker_bloc.dart';
import 'package:social_site_app/features/create_meet/presentation/bloc/location_picker_event.dart';
import 'package:social_site_app/features/create_meet/presentation/bloc/location_picker_state.dart';
import 'package:go_router/go_router.dart';
class LocationPickerPage extends StatefulWidget {
  static const String route = '/location_picker';

  const LocationPickerPage({super.key});

  @override
  State<LocationPickerPage> createState() => _LocationPickerPageState();
}

class _LocationPickerPageState extends State<LocationPickerPage> {
  GoogleMapController? mapController;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<LocationPickerBloc>()..add(GetUserLocationEvent()),
      child: BlocConsumer<LocationPickerBloc, LocationPickerState>(
        listener: (context, state) {
          if (state.status == LocationPickerStatus.success &&
              state.location != null) {
            mapController?.animateCamera(CameraUpdate.newCameraPosition(
                CameraPosition(target: state.location!, zoom: 20)));
          }
        },
        builder: (context, state) {
          if (state.status == LocationPickerStatus.loading) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            );
          }
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Select location',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              centerTitle: false,
            ),
            body: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                      target: state.location ?? LatLng(10.7769, 106.7009),
                      zoom: 10),
                  myLocationEnabled: true,
                  onCameraMove: (camera){
                    context.read<LocationPickerBloc>().add(SetLocationEvent(location: camera.target));
                  },
                  onMapCreated: (controller){
                    mapController = controller;
                  },
                ),
                Center(
                  child: Icon(
                    Icons.location_pin,
                    color: Theme.of(context).colorScheme.error,
                    size: 40,
                  ),
                ),
                Positioned(bottom: 20,left: 20,right: 20,child: DefaultButton(
                  text: 'Select',
                  onPressed:state.location!=null ? (){
                    context.pop(state.location);
                  } : null,
                ))
              ],
            ),
          );
        },
      ),
    );
  }
}