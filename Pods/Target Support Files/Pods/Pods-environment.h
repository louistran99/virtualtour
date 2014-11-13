
// To check if a library is compiled with CocoaPods you
// can use the `COCOAPODS` macro definition which is
// defined in the xcconfigs so it is available in
// headers also when they are imported in the client
// project.


// OpenCV
#define COCOAPODS_POD_AVAILABLE_OpenCV
// This library does not follow semantic-versioning,
// so we were not able to define version macros.
// Please contact the author.
// Version: 2.4.9.1.

// SCRecorder
#define COCOAPODS_POD_AVAILABLE_SCRecorder
#define COCOAPODS_VERSION_MAJOR_SCRecorder 2
#define COCOAPODS_VERSION_MINOR_SCRecorder 1
#define COCOAPODS_VERSION_PATCH_SCRecorder 4

