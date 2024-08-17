class Injector {
  final String device;
  final int volume;
  final String mode;
  final int preMix;
  final int fertigation;
  final int postMix;

  Injector({
    required this.device,
    required this.volume,
    required this.mode,
    required this.preMix,
    required this.fertigation,
    required this.postMix,
  });

  factory Injector.fromJson(Map<String, dynamic> json) {
    return Injector(
      device: json['device'],
      volume: json['volume'],
      mode: json['mode'],
      preMix: json['pre_mix'],
      fertigation: json['fertigation'],
      postMix: json['post_mix'],
    );
  }
}