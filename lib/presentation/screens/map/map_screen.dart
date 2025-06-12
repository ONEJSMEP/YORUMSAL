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
  LatLng _defaultCenter = LatLng(41.015137, 28.979530);
  String _tileUrl = 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png';
  List<String> _subdomains = ['a', 'b', 'c'];

  @override
  void initState() {
    super.initState();
    // Başlangıçta haritayı varsayılan konuma ayarla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mapController.move(_defaultCenter, 13.0);
    });
  }

  void _goToMyLocation() {
    // Gerçek kullanıcı konumunu burada alıp kullanabilirsiniz
    _mapController.move(_defaultCenter, 15.0);
  }

  void _showNearbyOptions() {
    showModalBottomSheet(
      context: context,
      builder: (_) => Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.restaurant),
            title: const Text('Restaurants'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.coffee),
            title: const Text('Coffee'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.local_gas_station),
            title: const Text('Gas'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: const Text('Groceries'),
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
            title: const Text('Explore'),
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
            title: const Text('Driving'),
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
            title: const Text('Transit'),
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
            title: const Text('Satellite'),
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
              FloatingActionButton(
                mini: true,
                heroTag: 'zoom_in',
                onPressed: () => _mapController.move(_mapController.center, _mapController.zoom + 1),
                child: const Icon(Icons.add),
              ),
              const SizedBox(height: 8),
              FloatingActionButton(
                mini: true,
                heroTag: 'zoom_out',
                onPressed: () => _mapController.move(_mapController.center, _mapController.zoom - 1),
                child: const Icon(Icons.remove),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 16,
          left: 16,
          child: FloatingActionButton.extended(
            heroTag: 'nearby',
            onPressed: _showNearbyOptions,
            icon: const Icon(Icons.place),
            label: const Text('Nearby'),
          ),
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            heroTag: 'locate',
            onPressed: _goToMyLocation,
            child: const Icon(Icons.my_location),
          ),
        ),
        Positioned(
          bottom: 16,
          left: MediaQuery.of(context).size.width / 2 - 28,
          child: FloatingActionButton(
            heroTag: 'map_type',
            onPressed: _showMapTypeSheet,
            child: const Icon(Icons.layers),
          ),
        ),
        Positioned(
          bottom: 8,
          right: 8,
          child: Container(
            padding: const EdgeInsets.all(4),
            color: Colors.white70,
            child: const Text(
              '© OpenStreetMap Contributors',
              style: TextStyle(fontSize: 10),
            ),
          ),
        ),
      ],
    );
  }
}
