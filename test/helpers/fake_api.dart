// =====================================================================
// Faux serveur pour les tests — Répond comme l'API JSONPlaceholder
// =====================================================================
// Les tests ne dépendent pas d'internet : ce MockClient renvoie les
// mêmes données que la vraie API (/users et /posts), ou simule une panne.
// =====================================================================

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

/// Extrait de la réponse réelle de https://jsonplaceholder.typicode.com/users
const List<Map<String, Object>> fakeUsers = [
  {'id': 1, 'name': 'Leanne Graham', 'email': 'Sincere@april.biz'},
  {'id': 2, 'name': 'Ervin Howell', 'email': 'Shanna@melissa.tv'},
  {'id': 3, 'name': 'Clementine Bauch', 'email': 'Nathan@yesenia.net'},
  {'id': 4, 'name': 'Patricia Lebsack', 'email': 'Julianne.OConner@kory.org'},
  {'id': 5, 'name': 'Chelsey Dietrich', 'email': 'Lucio_Hettinger@annie.ca'},
  {'id': 6, 'name': 'Mrs. Dennis Schulist', 'email': 'Karley_Dach@jasper.info'},
  {'id': 7, 'name': 'Kurtis Weissnat', 'email': 'Telly.Hoeger@billy.biz'},
  {'id': 8, 'name': 'Nicholas Runolfsdottir V', 'email': 'Sherwood@rosamond.me'},
  {'id': 9, 'name': 'Glenna Reichert', 'email': 'Chaim_McDermott@dana.io'},
  {'id': 10, 'name': 'Clementina DuBuque', 'email': 'Rey.Padberg@karina.biz'},
];

/// Notifications au format de /posts (la vraie API en renvoie 8).
List<Map<String, Object>> fakePosts([int count = 8]) => [
      for (var i = 1; i <= count; i++)
        {'id': i, 'title': 'Annonce $i', 'body': 'Texte de l\'annonce $i'},
    ];

/// Réponse JSON encodée en UTF-8 (accents compris).
http.Response jsonResponse(Object data, [int status = 200]) {
  return http.Response(
    jsonEncode(data),
    status,
    headers: {'content-type': 'application/json; charset=utf-8'},
  );
}

/// Faux serveur : répond comme JSONPlaceholder, ou échoue si [fail].
MockClient fakeApiClient({bool fail = false}) {
  return MockClient((request) async {
    if (fail) throw http.ClientException('Réseau indisponible');
    if (request.url.path.endsWith('/users')) return jsonResponse(fakeUsers);
    if (request.url.path.endsWith('/posts')) return jsonResponse(fakePosts());
    return http.Response('Not found', 404);
  });
}
