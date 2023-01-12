#include <napi.h>
#include <stdio.h>
#import <Foundation/Foundation.h>


static Napi::Value InstallAudioDriver(const Napi::CallbackInfo& info) {
  NSURL *bundleUrl = [NSBundle.mainBundle.bundleURL URLByAppendingPathComponent:@"Contents/Resources/binaries/"];

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

static Napi::Object Init(Napi::Env env, Napi::Object exports) {
  exports["InstallAudioDriver"] = Napi::Function::New(env, InstallAudioDriver);
  return exports;
}

NODE_API_MODULE(NODE_GYP_MODULE_NAME, Init)
