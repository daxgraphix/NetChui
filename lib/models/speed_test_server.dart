class SpeedTestServer {
  const SpeedTestServer({
    required this.id,
    required this.name,
    required this.pingUrl,
    required this.downloadUrlBuilder,
    required this.uploadUrl,
    this.useCloudflareBytes = false,
    this.isFastApi = false,
  });

  final String id;
  final String name;
  final String pingUrl;
  final String Function(int bytes) downloadUrlBuilder;
  final String uploadUrl;
  final bool useCloudflareBytes;
  final bool isFastApi;

  static const cloudflare = SpeedTestServer(
    id: 'cloudflare',
    name: 'Cloudflare (Global)',
    pingUrl: 'https://speed.cloudflare.com/cdn-cgi/trace',
    downloadUrlBuilder: _cloudflareDown,
    uploadUrl: 'https://speed.cloudflare.com/__up',
    useCloudflareBytes: true,
  );

  static const tele2 = SpeedTestServer(
    id: 'tele2',
    name: 'Tele2 (Europe)',
    pingUrl: 'https://speedtest.tele2.net/',
    downloadUrlBuilder: _tele2Down,
    uploadUrl: 'https://speedtest.tele2.net/upload.php',
  );

  static const auto = SpeedTestServer(
    id: 'auto',
    name: 'Automatic (Best)',
    pingUrl: '',
    downloadUrlBuilder: _cloudflareDown,
    uploadUrl: '',
  );

  static const fast = SpeedTestServer(
    id: 'fast',
    name: 'Netflix Fast.com',
    pingUrl: 'https://api.fast.com/netflix/speedtest/v2?https=true&token=YXNkZmFzZGxmbnNkYWZoYXNkZmhrYWxm&urlCount=5',
    downloadUrlBuilder: _fastDown,
    uploadUrl: 'https://speed.cloudflare.com/__up', // Fallback upload
    isFastApi: true,
  );

  static const all = [auto, fast, cloudflare, tele2];

  static SpeedTestServer byId(String id) {
    return all.firstWhere(
      (s) => s.id == id,
      orElse: () => fast,
    );
  }

  static String _cloudflareDown(int bytes) {
    return 'https://speed.cloudflare.com/__down?bytes=$bytes';
  }

  static String _tele2Down(int bytes) {
    final mb = (bytes / (1024 * 1024)).ceil().clamp(1, 100);
    return 'https://speedtest.tele2.net/${mb}MB.zip';
  }

  static String _fastDown(int bytes) {
    // This will be overridden by the SpeedTestService logic for Fast.com
    return '';
  }
}
