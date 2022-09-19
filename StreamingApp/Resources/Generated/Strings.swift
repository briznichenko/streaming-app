// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// Camera
  internal static let cameraLabelText = L10n.tr("Localizable", "CameraLabelText")
  /// To broadcast your video to your viewers.
  internal static let cameraSubtitleLabelText = L10n.tr("Localizable", "CameraSubtitleLabelText")
  /// Continue
  internal static let continueButtonTitle = L10n.tr("Localizable", "ContinueButtonTitle")
  /// Email
  internal static let emailPlaceholder = L10n.tr("Localizable", "EmailPlaceholder")
  /// I’m Not Done
  internal static let endStreamCancelText = L10n.tr("Localizable", "EndStreamCancelText")
  /// Are you sure you want to end the live?
  internal static let endStreamSubtitleText = L10n.tr("Localizable", "EndStreamSubtitleText")
  /// End Now
  internal static let endStreamText = L10n.tr("Localizable", "EndStreamText")
  /// End the stream?
  internal static let endStreamTitleText = L10n.tr("Localizable", "EndStreamTitleText")
  /// Email field is empty
  internal static let errorEmailEmpty = L10n.tr("Localizable", "ErrorEmailEmpty")
  /// Input email is in wrong format
  internal static let errorEmailInvalid = L10n.tr("Localizable", "ErrorEmailInvalid")
  /// Password field is empty
  internal static let errorPasswordEmpty = L10n.tr("Localizable", "ErrorPasswordEmpty")
  /// Input password is invalid
  internal static let errorPasswordInvalid = L10n.tr("Localizable", "ErrorPasswordInvalid")
  /// Error
  internal static let errorTitle = L10n.tr("Localizable", "ErrorTitle")
  /// Start Event
  internal static let eventsBottomButtonText = L10n.tr("Localizable", "EventsBottomButtonText")
  /// Events
  internal static let eventsButtonTitle = L10n.tr("Localizable", "EventsButtonTitle")
  /// Access your dashboard to schedule some campaigns…
  internal static let eventsPlaceholderText = L10n.tr("Localizable", "EventsPlaceholderText")
  /// Events
  internal static let eventsTitleText = L10n.tr("Localizable", "EventsTitleText")
  /// ScanQR
  internal static let landingScanButtonText = L10n.tr("Localizable", "LandingScanButtonText")
  /// Sign In
  internal static let landingSignInButtonText = L10n.tr("Localizable", "LandingSignInButtonText")
  /// Build your community, supercharge your sales, and engagement with livestream shopping.
  internal static let landingSubtitleText = L10n.tr("Localizable", "LandingSubtitleText")
  /// E-commerce reimagined.
  internal static let landingTitleLabelText = L10n.tr("Localizable", "LandingTitleLabelText")
  /// StreamingApp
  internal static let landingTitleText = L10n.tr("Localizable", "LandingTitleText")
  /// By signing in you agree to our Terms Of Service and Privacy Policy.
  internal static let legalText = L10n.tr("Localizable", "LegalText")
  /// Privacy Policy
  internal static let legalTextPrivacy = L10n.tr("Localizable", "LegalTextPrivacy")
  /// Terms Of Service
  internal static let legalTextTerms = L10n.tr("Localizable", "LegalTextTerms")
  /// Microphone
  internal static let microphoneLabelText = L10n.tr("Localizable", "MicrophoneLabelText")
  /// For you to engage with your viewers with audio.
  internal static let microphoneSubtitleLabelText = L10n.tr("Localizable", "MicrophoneSubtitleLabelText")
  /// Password
  internal static let passwordPlaceholder = L10n.tr("Localizable", "PasswordPlaceholder")
  /// We need a few things before going Streaming.
  internal static let permissionsLabelText = L10n.tr("Localizable", "PermissionsLabelText")
  /// Highlight Product
  internal static let productsBottomButtonText = L10n.tr("Localizable", "ProductsBottomButtonText")
  /// Don’t highlight product
  internal static let productsBottomButtonTextSelected = L10n.tr("Localizable", "ProductsBottomButtonTextSelected")
  /// Tap a product you want to showcase.
  internal static let productsSubtitleText = L10n.tr("Localizable", "ProductsSubtitleText")
  /// Highlight Product
  internal static let productsTitleText = L10n.tr("Localizable", "ProductsTitleText")
  /// Event QR Scan
  internal static let qrLabelText = L10n.tr("Localizable", "QrLabelText")
  /// Scan your event QR code to get started with the livestream.
  internal static let qrPromptText = L10n.tr("Localizable", "QrPromptText")
  /// Sign In
  internal static let signInText = L10n.tr("Localizable", "SignInText")
  /// Don’t have an account? Signup Here
  internal static let signUpText = L10n.tr("Localizable", "SignUpText")
  /// Signup Here
  internal static let signUpTextBold = L10n.tr("Localizable", "SignUpTextBold")

  internal enum InfoPlist {
    /// To broadcast your video to your viewers.
    internal static let nsCameraUsageDescription = L10n.tr("Localizable", "InfoPlist.NSCameraUsageDescription")
    /// For you to engage with your viewers with audio.
    internal static let nsMicrophoneUsageDescription = L10n.tr("Localizable", "InfoPlist.NSMicrophoneUsageDescription")
  }

  internal enum Alert {
    /// Not Now
    internal static let notNow = L10n.tr("Localizable", "alert.notNow")
    /// Settings
    internal static let settings = L10n.tr("Localizable", "alert.settings")
    internal enum Camera {
      /// Please Allow "%@" to Access the Camera
      internal static func title(_ p1: Any) -> String {
        return L10n.tr("Localizable", "alert.camera.title", String(describing: p1))
      }
    }
    internal enum Microphone {
      /// Please Allow "%@" to Access the Microphone
      internal static func title(_ p1: Any) -> String {
        return L10n.tr("Localizable", "alert.microphone.title", String(describing: p1))
      }
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
