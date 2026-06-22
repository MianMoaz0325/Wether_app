# Flutter-specific ProGuard rules

# Flutter native bindings
-keep class io.flutter.** { *; }
-keep class com.google.android.** { *; }

# Keep Flutter plugins
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep enum values
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# Keep Parcelable implementations
-keep class * implements android.os.Parcelable {
    public static final android.os.Parcelable$Creator *;
}

# Gson rules
-keep class sun.misc.Unsafe { *; }
-keep class com.google.gson.stream.* { *; }

# Application-specific rules
-keep class com.ahmad.weather.** { *; }
