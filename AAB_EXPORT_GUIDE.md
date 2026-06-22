# Android App Bundle (AAB) Export Guide
## For Google Play Store Submission

---

## QUICK START (Windows)

### Step 1: Create a Keystore File (ONE TIME ONLY)

Run this command in PowerShell:

```powershell
keytool -genkey -v -keystore weather_release.keystore -keyalg RSA -keysize 2048 -validity 10000 -alias weather_key
```

You'll be asked for:
- **Keystore Password:** (create a strong password)
- **Key Password:** (same as keystore password recommended)
- **First & Last Name:** Ahmad
- **Organization Unit:** Weather App
- **Organization:** Ahmad Weather
- **City:** (your city)
- **State:** (your state)
- **Country Code:** (e.g., PK for Pakistan)

**Save this information securely!** You'll need it for future updates.

---

### Step 2: Create Signing Configuration

Create or edit `android/key.properties`:

```properties
storePassword=YOUR_KEYSTORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=weather_key
storeFile=../weather_release.keystore
```

Replace `YOUR_KEYSTORE_PASSWORD` and `YOUR_KEY_PASSWORD` with your actual passwords.

---

### Step 3: Update build.gradle

Edit `android/app/build.gradle.kts` and add this before the `android {` block:

```kotlin
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    // ... existing code ...

    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }

    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
```

---

### Step 4: Build the AAB

Run this command:

```powershell
cd e:\dart\wether_app
flutter clean
flutter pub get
flutter build appbundle --release
```

This will create: `build/app/outputs/bundle/release/app-release.aab`

---

## DETAILED INSTRUCTIONS

### Understanding the Process

1. **Keystore**: A secure file that holds your private signing key
2. **Key Properties**: Configuration file with keystore credentials
3. **Signing**: The AAB is signed with your key (proves you're the developer)
4. **AAB File**: Ready for Play Store submission

---

## STEP-BY-STEP GUIDE

### STEP 1: Open PowerShell as Administrator

```powershell
# Navigate to your project
cd e:\dart\wether_app
```

### STEP 2: Generate Keystore

```powershell
# Generate keystore file (valid for 10000 days ~27 years)
keytool -genkey -v -keystore weather_release.keystore `
  -keyalg RSA -keysize 2048 -validity 10000 -alias weather_key
```

**Example Input:**
```
Enter keystore password: MySecurePassword123
Re-enter new password: MySecurePassword123
What is your first and last name? [Unknown]: Ahmad
What is your organizational unit name? [Unknown]: Weather App
What is your organization name? [Unknown]: Ahmad Weather
What is your City or Locality name? [Unknown]: Lahore
What is your State or Province name? [Unknown]: Punjab
What is the two-letter country code for this unit? [Unknown]: PK
Is CN=Ahmad, OU=Weather App, O=Ahmad Weather, L=Lahore, ST=Punjab, C=PK correct? yes
```

**Output:**
```
Keystore size: 2,384 bytes
Keystore saved in: e:\dart\wether_app\weather_release.keystore
```

---

### STEP 3: Create key.properties File

Create file: `android/key.properties`

```properties
storePassword=MySecurePassword123
keyPassword=MySecurePassword123
keyAlias=weather_key
storeFile=../weather_release.keystore
```

---

### STEP 4: Update build.gradle.kts

Open: `android/app/build.gradle.kts`

Add this at the very top (before plugins):

```kotlin
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}
```

Find the `buildTypes { release { ... } }` section and update it:

```kotlin
buildTypes {
    release {
        signingConfig signingConfigs.release
    }
}
```

Add signingConfigs before buildTypes:

```kotlin
signingConfigs {
    release {
        keyAlias keystoreProperties['keyAlias']
        keyPassword keystoreProperties['keyPassword']
        storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
        storePassword keystoreProperties['storePassword']
    }
}
```

---

### STEP 5: Build Release AAB

```powershell
# Clean previous builds
flutter clean

# Get dependencies
flutter pub get

# Build the App Bundle
flutter build appbundle --release
```

Wait for completion. You should see:

```
✓ Built build/app/outputs/bundle/release/app-release.aab (17.3 MB)
```

---

## LOCATE YOUR AAB FILE

The signed AAB is created at:

```
e:\dart\wether_app\build\app\outputs\bundle\release\app-release.aab
```

---

## UPLOAD TO PLAY CONSOLE

1. Go to [Google Play Console](https://play.google.com/console)
2. Select your app
3. Navigate to: **Release** → **Production**
4. Click **Create new release**
5. Upload `app-release.aab`
6. Review details and publish

---

## IMPORTANT NOTES

⚠️ **BACKUP YOUR KEYSTORE**
- Save `weather_release.keystore` in a safe location
- Save `android/key.properties` securely
- **NEVER lose these files** - you can't update your app without them

⚠️ **PASSWORD SECURITY**
- Use a strong, unique password
- Don't share with anyone
- Store safely (password manager recommended)

⚠️ **KEYSTORE INFORMATION**
```
Keystore File: weather_release.keystore
Key Alias: weather_key
Validity: 27 years (10000 days)
```

---

## VERIFY YOUR AAB

Before uploading, verify the file:

```powershell
# Check file exists and size
Get-Item e:\dart\wether_app\build\app\outputs\bundle\release\app-release.aab

# Expected output:
# Mode                 LastWriteTime         Length Name
# ----                 -------------         ------ ----
# -a---          4/22/2026 10:30 AM       17829042 app-release.aab
```

---

## TROUBLESHOOTING

### "keytool not found"
- Install Java JDK from [oracle.com](https://oracle.com)
- Add Java to PATH
- Restart PowerShell

### "Keystore file not found"
- Check file path in `key.properties`
- Ensure `weather_release.keystore` is in project root
- Use relative path: `../weather_release.keystore`

### "Wrong password"
- Verify password in `key.properties` matches keystore password
- Regenerate keystore if forgotten

### Build fails with signing error
- Verify `key.properties` syntax (no quotes around values)
- Check file path is correct
- Ensure file permissions allow read access

---

## WHAT'S IN THE AAB?

The app-release.aab contains:
- ✓ Compiled app code
- ✓ Resources (images, layouts, strings)
- ✓ Native libraries
- ✓ Your digital signature
- ✓ All supported configurations

---

## NEXT STEPS

After successful upload:

1. Fill in app details on Play Console
2. Add app icon, screenshots, and description
3. Complete questionnaire
4. Submit for review
5. Wait for Google approval (usually 24-48 hours)

---

## USEFUL COMMANDS

Check signed app certificate info:
```powershell
keytool -list -v -keystore weather_release.keystore
```

Verify AAB integrity:
```powershell
bundletool validate --bundle=build/app/outputs/bundle/release/app-release.aab
```

---

## FILES CREATED

After this process:
```
e:\dart\wether_app\
├── weather_release.keystore      # Your signing key (BACKUP!)
├── android/
│   └── key.properties            # Signing configuration
└── build/
    └── app/outputs/bundle/
        └── release/
            └── app-release.aab   # YOUR UPLOAD FILE ✓
```

---

**Need help?** Contact: support@weatherapp.com
**Developer:** Muhammad Moaz
**App:** Weather App (com.ahmad.weather)

---

Last Updated: April 22, 2026
