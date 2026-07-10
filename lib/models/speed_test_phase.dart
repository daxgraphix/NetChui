enum SpeedTestPhase {
  idle,
  ping,
  download,
  upload,
  done,
  error,
}

extension SpeedTestPhaseX on SpeedTestPhase {
  String get label {
    return switch (this) {
      SpeedTestPhase.idle => 'Ready',
      SpeedTestPhase.ping => 'Measuring ping…',
      SpeedTestPhase.download => 'Testing download…',
      SpeedTestPhase.upload => 'Testing upload…',
      SpeedTestPhase.done => 'Complete',
      SpeedTestPhase.error => 'Something went wrong',
    };
  }

  double get progress {
    return switch (this) {
      SpeedTestPhase.idle => 0,
      SpeedTestPhase.ping => 0.2,
      SpeedTestPhase.download => 0.5,
      SpeedTestPhase.upload => 0.8,
      SpeedTestPhase.done => 1,
      SpeedTestPhase.error => 0,
    };
  }
}
