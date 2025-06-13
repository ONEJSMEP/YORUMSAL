import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  final LatLng _defaultCenter = LatLng(41.015137, 28.979530);
  String _tileUrl = 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png';
  List<String> _subdomains = ['a', 'b', 'c'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mapController.move(_defaultCenter, 13.0);
    });
  }

  void _goToMyLocation() {
    _mapController.move(_defaultCenter, 15.0);
  }

  void _showNearbyOptions() {
    showModalBottomSheet(
      context: context,
      builder: (_) => Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.restaurant),
            title: const Text('Restoranlar'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.coffee),
            title: const Text('Kafeler'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.local_gas_station),
            title: const Text('Benzin İstasyonları'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: const Text('Marketler'),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void _showMapTypeSheet() {
    showModalBottomSheet(
      context: context,
      builder: (_) => Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.map),
            title: const Text('Keşfet'),
            onTap: () {
              setState(() {
                _tileUrl = 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png';
                _subdomains = ['a', 'b', 'c'];
              });
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.directions_car),
            title: const Text('Sürüş'),
            onTap: () {
              setState(() {
                _tileUrl = 'https://{s}.tile.opentopomap.org/{z}/{x}/{y}.png';
                _subdomains = ['a', 'b', 'c'];
              });
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.directions_transit),
            title: const Text('Toplu Taşıma'),
            onTap: () {
              setState(() {
                _tileUrl = 'https://{s}.tile-cyclosm.openstreetmap.fr/cyclosm/{z}/{x}/{y}.png';
                _subdomains = ['a'];
              });
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.satellite),
            title: const Text('Uydu'),
            onTap: () {
              setState(() {
                _tileUrl =
                    'https://services.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}';
                _subdomains = [''];
              });
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _mapButton(IconData icon, VoidCallback onPressed, {String? heroTag}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return FloatingActionButton(
      mini: true,
      heroTag: heroTag,
      backgroundColor: isDark ? Colors.grey.shade800 : null,
      foregroundColor: isDark ? Colors.white : null,
      onPressed: onPressed,
      child: Icon(icon),
    );
  }

  Widget _mapButtonExtended(IconData icon, String label, VoidCallback onPressed) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return FloatingActionButton.extended(
      heroTag: label,
      backgroundColor: isDark ? Colors.grey.shade800 : null,
      foregroundColor: isDark ? Colors.white : null,
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            center: _defaultCenter,
            zoom: 13.0,
          ),
          children: [
            TileLayer(
              urlTemplate: _tileUrl,
              subdomains: _subdomains,
              userAgentPackageName: 'com.ONEJSMEP.yorumsal',
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: _defaultCenter,
                  width: 80,
                  height: 80,
                  builder: (ctx) => const Icon(
                    Icons.location_on,
                    color: Colors.redAccent,
                    size: 40,
                  ),
                ),
              ],
            ),
          ],
        ),
        Positioned(
          top: 16,
          right: 16,
          child: Column(
            children: [
              _mapButton(Icons.add, () => _mapController.move(_mapController.center, _mapController.zoom + 1), heroTag: 'zoom_in'),
              const SizedBox(height: 8),
              _mapButton(Icons.remove, () => _mapController.move(_mapController.center, _mapController.zoom - 1), heroTag: 'zoom_out'),
            ],
          ),
        ),
        Positioned(
          bottom: 16,
          left: 16,
          child: _mapButtonExtended(Icons.place, 'Yakındakiler', _showNearbyOptions),
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: _mapButton(Icons.my_location, _goToMyLocation, heroTag: 'locate'),
        ),
        Positioned(
          bottom: 16,
          left: MediaQuery.of(context).size.width / 2 - 28,
          child: _mapButton(Icons.layers, _showMapTypeSheet, heroTag: 'map_type'),
        ),
      ],
    );
  }
}
