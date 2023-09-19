import 'package:appwrite/appwrite.dart';

Client client = Client()
    .setEndpoint('https://cloud.appwrite.io/v1')
    .setProject('64ac1b54935437aa7538');
// For self signed certificates, only use for development

final Account account = Account(client);
final String uniqueId = ID.unique();
final Databases databases = Databases(client);
final Avatars avatars = Avatars(client);
final Storage storage = Storage(client);
// Subscribe to files channel
final Realtime realtime = Realtime(client);
