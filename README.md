# Flutter Mapas com OpenStreetMap

Um app Flutter que exibe mapas utilizando o pacote [flutter_map](https://pub.dev/packages/flutter_map) integrado ao **OpenStreetMap**, mostrando a localização atual do usuário com atualização em tempo real.

---

## Funcionalidades
- Exibe o mapa inicial centralizado na localização atual.
- Marcador fixo na posição inicial.
- Marcador de **localização atual** que acompanha o movimento do dispositivo.
- Busca de endereço (via Nominatim API).

---

## Dependências principais
- [flutter_map](https://pub.dev/packages/flutter_map) → Exibição do mapa OSM  
- [latlong2](https://pub.dev/packages/latlong2) → Suporte para coordenadas  
- [geolocator](https://pub.dev/packages/geolocator) → Obter localização do dispositivo  
- [geocoding](https://pub.dev/packages/geocoding) → Conversão de coordenadas em endereços
- [provider](https://pub.dev/packages/provider) → Gerenciamento de estado (MVVM)  
- [http](https://pub.dev/packages/http) → Requisições REST (para busca de endereço)  
- [battery_plus](https://pub.dev/packages/battery_plus) → Ajuste de precisão baseado na bateria  

---

## Estrutura do projeto

```
lib/
├── models/
│ └── location_model.dart
├── services/
│ └── location_service.dart
│ └── geocoding_service.dart
├── viewmodels/
│ └── location_viewmodel.dart
├── views/
│ └── map_view.dart
└── main.dart
```

---

## Como rodar
1. Clone este repositório:
   ```bash
   git clone https://github.com/LuisPereira05/atividadeMapaOsm.git
   ```

2. Instale as dependências:
    ```bash
   flutter pub get
   ```
2. Execute em emulador ou dispositivo físico:
    ```bash
   flutter run
   ```