#import "FeathersAuthFlutterPlugin.h"
#if __has_include(<feathers_auth_flutter/feathers_auth_flutter-Swift.h>)
#import <feathers_auth_flutter/feathers_auth_flutter-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "feathers_auth_flutter-Swift.h"
#endif

@implementation FeathersAuthFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFeathersAuthFlutterPlugin registerWithRegistrar:registrar];
}
@end
