import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/local/country_codes.dart';
import '../data/remote/api_exception.dart';
import '../domain/entities/country.dart';
import 'providers.dart';

enum AccountSetupStage { phone, otp, language }

class AccountSetupState {
  const AccountSetupState({
    this.stage = AccountSetupStage.phone,
    this.country = CountryCodes.defaultCountry,
    this.phoneDigits = '',
    this.isSendingOtp = false,
    this.phoneError,
    this.otpCode = '',
    this.isVerifyingOtp = false,
    this.otpError,
    this.resendCooldownSeconds = 0,
    this.language = 'Hindi',
  });

  final AccountSetupStage stage;
  final Country country;
  final String phoneDigits;
  final bool isSendingOtp;
  final String? phoneError;
  final String otpCode;
  final bool isVerifyingOtp;
  final String? otpError;
  final int resendCooldownSeconds;
  final String language;

  String get fullPhoneNumber => '${country.dialCode}$phoneDigits';

  /// Light sanity check, not full phone-number validation — good enough to
  /// gate the button; the backend/Twilio is the real source of truth.
  bool get canSendOtp => phoneDigits.trim().length >= 6 && !isSendingOtp;
  bool get canVerifyOtp => otpCode.length == 6 && !isVerifyingOtp;

  AccountSetupState copyWith({
    AccountSetupStage? stage,
    Country? country,
    String? phoneDigits,
    bool? isSendingOtp,
    String? phoneError,
    bool clearPhoneError = false,
    String? otpCode,
    bool? isVerifyingOtp,
    String? otpError,
    bool clearOtpError = false,
    int? resendCooldownSeconds,
    String? language,
  }) {
    return AccountSetupState(
      stage: stage ?? this.stage,
      country: country ?? this.country,
      phoneDigits: phoneDigits ?? this.phoneDigits,
      isSendingOtp: isSendingOtp ?? this.isSendingOtp,
      phoneError: clearPhoneError ? null : (phoneError ?? this.phoneError),
      otpCode: otpCode ?? this.otpCode,
      isVerifyingOtp: isVerifyingOtp ?? this.isVerifyingOtp,
      otpError: clearOtpError ? null : (otpError ?? this.otpError),
      resendCooldownSeconds:
          resendCooldownSeconds ?? this.resendCooldownSeconds,
      language: language ?? this.language,
    );
  }
}

/// Drives the phone → OTP → language sub-flow that sits inside onboarding
/// step 3. Talks to AuthRepository (Twilio-backed /send-otp, /verify-otp)
/// and persists tokens/language via the local repositories.
class AccountSetupController extends StateNotifier<AccountSetupState> {
  AccountSetupController(this._ref) : super(const AccountSetupState());

  static const _resendCooldownSeconds = 30;

  final Ref _ref;
  Timer? _cooldownTimer;

  void selectCountry(Country country) {
    state = state.copyWith(country: country);
  }

  void updatePhoneDigits(String value) {
    final digitsOnly = value.replaceAll(RegExp(r'[^0-9]'), '');
    state = state.copyWith(phoneDigits: digitsOnly, clearPhoneError: true);
  }

  Future<void> sendOtp() async {
    if (!state.canSendOtp) return;
    state = state.copyWith(isSendingOtp: true, clearPhoneError: true);
    try {
      await _ref.read(authRepositoryProvider).sendOtp(state.fullPhoneNumber);
      state = state.copyWith(
        isSendingOtp: false,
        stage: AccountSetupStage.otp,
        otpCode: '',
        clearOtpError: true,
      );
      _startCooldown();
    } on ApiException catch (e) {
      state = state.copyWith(isSendingOtp: false, phoneError: e.message);
    }
  }

  Future<void> resendOtp() async {
    if (state.resendCooldownSeconds > 0 || state.isSendingOtp) return;
    await sendOtp();
  }

  void changeNumber() {
    _cooldownTimer?.cancel();
    state = state.copyWith(
      stage: AccountSetupStage.phone,
      otpCode: '',
      resendCooldownSeconds: 0,
      clearOtpError: true,
    );
  }

  void updateOtpCode(String value) {
    final digitsOnly = value.replaceAll(RegExp(r'[^0-9]'), '');
    final trimmed =
        digitsOnly.length > 6 ? digitsOnly.substring(0, 6) : digitsOnly;
    state = state.copyWith(otpCode: trimmed, clearOtpError: true);
  }

  Future<void> verifyOtp() async {
    if (!state.canVerifyOtp) return;
    state = state.copyWith(isVerifyingOtp: true, clearOtpError: true);
    try {
      final tokens = await _ref.read(authRepositoryProvider).verifyOtp(
            phoneNumber: state.fullPhoneNumber,
            otpCode: state.otpCode,
          );
      await _ref.read(secureTokenStorageProvider).save(tokens);
      state = state.copyWith(
        isVerifyingOtp: false,
        stage: AccountSetupStage.language,
      );
    } on ApiException catch (e) {
      state = state.copyWith(
        isVerifyingOtp: false,
        otpError: e.message,
        otpCode: '',
      );
    }
  }

  void selectLanguage(String language) {
    state = state.copyWith(language: language);
  }

  /// Saves the chosen language locally (source of truth for the app) and
  /// best-effort syncs it to the account via `PATCH /add-language`. A sync
  /// failure doesn't block onboarding — the user already verified their
  /// phone; losing them here over a flaky connection isn't worth it.
  Future<void> confirmLanguage() async {
    await _ref
        .read(languagePreferenceRepositoryProvider)
        .save(state.language);
    try {
      await _ref.read(userRepositoryProvider).updateLanguage(state.language);
    } on ApiException {
      // Local save already succeeded; the next successful call anywhere
      // authenticated will naturally retry via the interceptor's tokens.
    }
  }

  void _startCooldown() {
    _cooldownTimer?.cancel();
    state = state.copyWith(resendCooldownSeconds: _resendCooldownSeconds);
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final remaining = state.resendCooldownSeconds - 1;
      if (remaining <= 0) {
        timer.cancel();
        state = state.copyWith(resendCooldownSeconds: 0);
      } else {
        state = state.copyWith(resendCooldownSeconds: remaining);
      }
    });
  }

  @override
  void dispose() {
    _cooldownTimer?.cancel();
    super.dispose();
  }
}

final accountSetupControllerProvider =
    StateNotifierProvider<AccountSetupController, AccountSetupState>((ref) {
  return AccountSetupController(ref);
});
