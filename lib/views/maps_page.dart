import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maps/services/database_service.dart';

class MapsPage extends StatefulWidget {
  const MapsPage({super.key});

  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  GoogleMapController? mapController;
  final ContatoService _databaseService = ContatoService.instance;

  String? _maps_nome = null;
  String? _maps_latitude = null;
  String? _maps_longitude = null;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(-5.095424, -42.8146688),
    zoom: 14.4746,
  );

  Set<Marker> _marcadores = {};

  //final LatLng _center = const LatLng(-5.1022707, -42.9531379);

  @override
  void initState() {
    super.initState();
    _carregarMarcadores();
    _localizacaoAtual();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> _localizacaoAtual() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Serviço de localização está desativado.');
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Permissão de localização negada.');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print(
          'Permissão de localização foi negada permanentemente. Não podemos solicitar.');
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    print('Localização: ${position.toString()}');
  }

  void _carregarMarcadores() {
    _databaseService.getContatos().then((contatos) {
      Set<Marker> marcadoresLocal = {};

      for (var contato in contatos) {
        Marker marcador = Marker(
          markerId: MarkerId(contato.nome), // Nome do contato como ID
          position: LatLng(
              double.parse(contato.latitude), double.parse(contato.longitude)),
          infoWindow: InfoWindow(
            title: contato.nome,
            snippet: "Lat: ${contato.latitude}, Lon: ${contato.longitude}",
          ),
        );
        marcadoresLocal.add(marcador);
      }

      setState(() {
        _marcadores = marcadoresLocal;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: Text('App de Contatos'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(-5.095424, -42.8146688),
          zoom: 10,
        ),
        onMapCreated: _onMapCreated,
        myLocationEnabled: true,
        mapType: MapType.normal,
        markers: _marcadores,
      ),
    );
  }
}
