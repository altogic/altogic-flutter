import 'package:altogic_dart/altogic_dart.dart' as alt;
import 'package:altogic_flutter/altogic_flutter.dart';

/// Creates a new client to interact with your backend application developed in
/// Altogic. You need to specify the `envUrl` and `clientKey` to create a new
/// client object. You can create a new environment or access your app `envUrl`
/// from the **Environments** view and create a new `clientKey` from **App
/// Settings/Client library** view in Altogic designer.
///
/// [envUrl] The base URL of the Altogic application  environment where a
/// snapshot of the application is deployed.
///
/// [clientKey] The client library key of the app.
///
/// [options] Additional configuration parameters.
///
/// [ClientOptions.apiKey] A valid API key of the environment.
///
/// [ClientOptions.localStorage] Client storage handler to store user and
/// session data.
///
/// [ClientOptions.signInRedirect] The sign in page URL to redirect the user
/// when user's session becomes invalid.
///
/// Returns the newly created client instance.
AltogicClient createClient(String envUrl, String clientKey,
        [ClientOptions? options]) =>
    AltogicClient(envUrl, clientKey, options);

/// Dart client for interacting with your backend applications
/// developed in Altogic.
///
/// AltogicClient is the main object that you will be using to issue commands
/// to your backend apps. The commands that you can run are grouped below:
///
/// * [auth] : [AuthManager] - Manage users and user sessions
/// * [endpoint] : [EndpointManager] - Make http requests to your app
/// endpoints and execute associated services
/// * [db] : [DatabaseManager] - Perform CRUD (including lookups,
/// filtering, sorting, pagination) operations in your app database
/// * [queue] : [QueueManager] - Enables you to run long-running jobs
/// asynchronously by submitting messages to queues
/// * [cache] : [CacheManager] - Store and manage your data objects in
/// high-speed data storage layer (Redis)
/// * [task] : [TaskManager] - Manually trigger execution of
/// scheduled tasks (e.g., cron jobs)
///
/// Each AltogicClient can interact with one of your app environments
/// (e.g., development, test, production). You cannot create a single
/// client to interact with multiple development, test or production
/// environments at the same time. If you would like to issue commands
/// to other environments, you need to create additional AltogicClient
/// objects using the target environment's `envUrl`.
class AltogicClient extends alt.AltogicClient {
  AltogicClient(String envUrl, String clientKey, [alt.ClientOptions? options])
      : super(
            envUrl,
            clientKey,
            alt.ClientOptions(
                localStorage:
                    options?.localStorage ?? SharedPreferencesStorage(),
                apiKey: options?.apiKey,
                signInRedirect: options?.signInRedirect));
}
