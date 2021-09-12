///
/// Describe: Tencent X5 State
///
/// @Author: LiWeNHuI
/// @Date: 2021/9/10
///

enum EX5Status {
  /// Not initialized
  init,

  /// Initializing
  initLoading,

  /// Initialization succeeded
  success,

  /// Initialization failed
  fail,

  /// Download succeeded
  downloadSuccess,

  /// Download failed
  downloadFail,

  /// Downloading
  downloadLoading,

  /// Installation succeeded
  installSuccess,

  /// Installation failed
  installFail,
}

extension EX5StatusExtension on EX5Status {
  static EX5Status getTypeValue(int i) {
    switch (i) {
      case 0:
        return EX5Status.init;
      case 1:
        return EX5Status.initLoading;
      case 10:
        return EX5Status.success;
      case 11:
        return EX5Status.fail;
      case 20:
        return EX5Status.downloadSuccess;
      case 21:
        return EX5Status.downloadFail;
      case 22:
        return EX5Status.downloadLoading;
      case 30:
        return EX5Status.installSuccess;
      case 31:
        return EX5Status.installFail;
      default:

        ///
        /// It returns to [EX5Status.init] status by default
        ///
        return EX5Status.init;
    }
  }
}
