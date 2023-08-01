#include <napi.h>
#include <stdio.h>
#import <Foundation/Foundation.h>


static Napi::Value InstallAudioDriver(const Napi::CallbackInfo& info) {
  NSString *bundleIdentifier = NSBundle.mainBundle.bundleIdentifier;
  NSLog(@"Found bundle identifier: %@", bundleIdentifier);
  NSString *claapIdentifier = @"io.claap.desktop";

  NSURL *bundleUrl = [bundleIdentifier isEqualToString:claapIdentifier]
    ? [NSBundle.mainBundle.bundleURL URLByAppendingPathComponent:@"Contents/Resources/binaries/"] 
    : [NSBundle.mainBundle.bundleURL URLByAppendingPathComponent:@"../../../../../../../binaries/"];
  NSLog(@"Found bundle url: %@", bundleUrl);
  
  NSString* installScriptPath = [bundleUrl URLByAppendingPathComponent:@"install_claap_bgm.sh"].path;
  NSString* driverPath = [bundleUrl URLByAppendingPathComponent:@"Claap Background Music Device.driver"].path;
   
  NSString *source = [NSString stringWithFormat:@"do shell script \"\'%@\' \'%@\'\" with administrator privileges", installScriptPath, driverPath];
  NSAppleScript *script = [[NSAppleScript alloc] initWithSource:source];
    
  NSDictionary *error;
  NSAppleEventDescriptor *desc = [script executeAndReturnError:&error];
    
  if (desc) {
    NSLog(@"Install successful: %@", desc);
    return Napi::Boolean::New(info.Env(), true);
  } else {
    NSLog(@"Install failed! %@", error);
    return Napi::Boolean::New(info.Env(), false);
  }

  return info.Env().Undefined();
}

static Napi::Value CheckAudioDriverInstallation(const Napi::CallbackInfo& info) {
  NSString *bundleIdentifier = NSBundle.mainBundle.bundleIdentifier;
  NSLog(@"Found bundle identifier: %@", bundleIdentifier);
  NSString *claapIdentifier = @"io.claap.desktop";

  NSURL *bundleUrl = [bundleIdentifier isEqualToString:claapIdentifier]
    ? [NSBundle.mainBundle.bundleURL URLByAppendingPathComponent:@"Contents/Resources/binaries/"] 
    : [NSBundle.mainBundle.bundleURL URLByAppendingPathComponent:@"../../../../../../../binaries/"];
  NSLog(@"Found bundle url: %@", bundleUrl);
  
  NSString* checkScriptPath = [bundleUrl URLByAppendingPathComponent:@"check_claap_bgm.sh"].path;
  NSString* driverPath = [bundleUrl URLByAppendingPathComponent:@"Claap Background Music Device.driver"].path;
   
  NSString *source = [NSString stringWithFormat:@"do shell script \"\'%@\' \'%@\'\"", checkScriptPath, driverPath];
  NSAppleScript *script = [[NSAppleScript alloc] initWithSource:source];
    
  NSDictionary *error;
  NSAppleEventDescriptor *desc = [script executeAndReturnError:&error];
    
  if (desc) {
    NSLog(@"Check successful: %@", desc);
    return Napi::Boolean::New(info.Env(), true);
  } else {
    NSLog(@"Check failed! %@", error);
    return Napi::Boolean::New(info.Env(), false);
  }

  return info.Env().Undefined();
}

static Napi::Object Init(Napi::Env env, Napi::Object exports) {
  exports["installAudioDriver"] = Napi::Function::New(env, InstallAudioDriver);
  exports["checkAudioDriverInstalled"] = Napi::Function::New(env, CheckAudioDriverInstallation);
  return exports;
}

NODE_API_MODULE(NODE_GYP_MODULE_NAME, Init)
