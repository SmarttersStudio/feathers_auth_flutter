part of feathers_auth_flutter;

enum TransportType { WEB_SOCKET, POLLING }

class FeathersSocketOptions {
    final String uri;
    final Map<String, String> query;

    /// Enable debug logging
    final bool enableLogging;

    /// List of transport names.
    List<TransportType> transports;

    /// Connection timeout (ms). Set -1 to disable.
    int timeout = 20000;

    /// Namespace parameter
    String nameSpace;

    /// Path parameter if socket.io runs on a different endpoint
    String path;

    FeathersSocketOptions(this.uri,
        {this.query: const {},
            this.enableLogging: false,
            this.transports: const [TransportType.WEB_SOCKET, TransportType.POLLING],
            this.nameSpace = "/",
            this.path = '/socket.io'})
        : assert(nameSpace.startsWith("/"),
    "Namespace must be a non null string and should start with a '/'");

    Map asMap() {
        return {
            "uri": uri,
            "query": query,
            "path": path,
            "enableLogging": enableLogging,
            "namespace": nameSpace,
            "transports": transports.map((TransportType t) {
                return {
                    TransportType.WEB_SOCKET: "websocket",
                    TransportType.POLLING: "polling"
                }[t];
            }).toList(),
            "timeout": timeout
        };
    }
}
