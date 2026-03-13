import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/constants/credentials.dart';
import 'package:cirilla/constants/strings.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';
import 'package:google_geocoding/google_geocoding.dart';
import 'package:provider/provider.dart';

import 'package:cirilla/models/location/user_location.dart';
import 'package:cirilla/store/auth/auth_store.dart';
import 'package:cirilla/store/auth/location_store.dart';
import 'package:cirilla/widgets/cirilla_tile.dart';

enum _StatusHandlePermission { allowed, needLocationService, needAppLocationPermission }

class UseMyCurrentLocation extends StatefulWidget {
  const UseMyCurrentLocation({Key? key}) : super(key: key);

  @override
  State<UseMyCurrentLocation> createState() => _UseMyCurrentLocationState();
}

class _UseMyCurrentLocationState extends State<UseMyCurrentLocation> with SnackMixin {
  late LocationStore _locationStore;

  bool _loading = false;

  @override
  void didChangeDependencies() {
    _locationStore = Provider.of<AuthStore>(context).locationStore;

    super.didChangeDependencies();
  }

  Future<_StatusHandlePermission> _handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return _StatusHandlePermission.needLocationService;
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return _StatusHandlePermission.needAppLocationPermission;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return _StatusHandlePermission.needAppLocationPermission;
    }

    return _StatusHandlePermission.allowed;
  }

  Future<String> _dialog({
    required String content,
    required TranslateType translate,
  }) async {
    ThemeData theme = Theme.of(context);

    String? value = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(content),
            actions: [
              ElevatedButton(onPressed: () => Navigator.of(context).pop("OK"), child: Text(translate("setting"))),
              OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  foregroundColor: theme.colorScheme.error,
                  side: BorderSide(color: theme.colorScheme.error),
                ),
                child: Text(translate("cancel")),
              )
            ],
          );
        });
    return value ?? "Cancel";
  }

  Future<void> _getLocation() async {
    setState(() {
      _loading = true;
    });
    TranslateType translate = AppLocalizations.of(context)!.translate;

    _StatusHandlePermission status = await _handlePermission();

    switch (status) {
      case _StatusHandlePermission.needLocationService:
        if (!isWeb) {
          setState(() {
            _loading = false;
          });
          String check = await _dialog(
            content: translate("required_location", {"appName": Strings.appName}),
            translate: translate,
          );

          if (check == "OK") {
            await Geolocator.openLocationSettings();
          }
        }
        break;
      case _StatusHandlePermission.needAppLocationPermission:
        if (!isWeb) {
          setState(() {
            _loading = false;
          });
          await Geolocator.openAppSettings();
        }
        break;
      default:
        final position = await Geolocator.getCurrentPosition();

        GoogleGeocoding googleGeocoding = GoogleGeocoding(googleMapApiKey);
        GeocodingResponse? reverse = await googleGeocoding.geocoding.getReverse(LatLon(
          position.latitude,
          position.longitude,
        ));
        _locationStore.setLocation(
          location: UserLocation(
            lat: position.latitude,
            lng: position.longitude,
            address:
                reverse?.results != null && reverse!.results!.isNotEmpty ? reverse.results![0].formattedAddress : '',
            tag: '',
          ),
        );

        setState(() {
          _loading = false;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;

    return CirillaTile(
      title: Text(
        translate('location_current_location'),
        style: theme.textTheme.bodySmall?.copyWith(color: theme.textTheme.titleMedium?.color),
      ),
      trailing: _loading
          ? const SizedBox(width: 25, height: 25, child: CircularProgressIndicator(strokeWidth: 2))
          : Icon(
              Icons.my_location,
              size: 20,
              color: theme.textTheme.titleMedium?.color,
            ),
      isChevron: false,
      height: 50,
      onTap: () => _getLocation(),
    );
  }
}
