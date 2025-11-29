# Antigravity XR Development Workspace Template

A comprehensive Coder template for Android XR development with Google Antigravity IDE, Android Studio, and the complete Google Cloud AI stack.

## What's Included

### Development Tools
- **Google Antigravity IDE (v1.11.9+)** - AI-powered development platform with Gemini 3 Pro, Claude Sonnet 4.5, and GPT-OSS support
- **Android Studio** - Full IDE for Android development
- **Blender 4.2+** - 3D modeling and rendering for XR content creation
- **Visual Studio Code** - Available via Coder's built-in support

### Android Development Stack
- **Android SDK** - Platforms 34 & 35
- **Android XR SDK** - System images for XR development (x86_64 and arm64-v8a)
- **Build Tools** - Latest Android build tools (35.0.0, 34.0.0)
- **ADB & Fastboot** - Android debugging and flashing tools
- **Emulator** - Android emulator with XR support

### Google Cloud & AI
- **Google Cloud SDK** - Command-line tools for Google Cloud Platform
- **Genkit** - Google's AI development framework
- **Firebase Tools** - Backend services and hosting
- **Google Generative AI** - AI/ML SDK for Google's generative models

### Runtime & Languages
- **Java OpenJDK 21** - Required for Android development
- **Node.js 20.x** - JavaScript runtime for AI tools
- **Python 3** - Pre-installed for scripting

## Prerequisites

- Coder server (self-hosted or Coder Cloud)
- Docker runtime on Coder host
- **GPU/VRAM access** - CRITICAL limitation:
  - Without GPU: Emulator won't work or will be unusably slow
  - Without GPU: Blender 3D work will be extremely limited
  - **Recommended**: GPU passthrough to Docker or physical device testing via ADB

### Resource Requirements

| Use Case | CPU | RAM | Disk | GPU | Notes |
|----------|-----|-----|------|-----|-------|
| **Code editing only** | 4 cores | 8 GB | 50 GB | None | No emulator/Blender |
| **Physical device dev** | 8 cores | 16 GB | 100 GB | None | Use ADB to real hardware |
| **Full emulator + 3D** | 12+ cores | 24+ GB | 200 GB | **Required** | GPU passthrough needed |

**Without GPU Access:**
- ✅ Antigravity IDE, Android Studio, code editing
- ✅ Building and compiling Android apps
- ✅ ADB to physical Android XR devices
- ❌ Android emulator (won't work or unusably slow)
- ❌ Blender 3D modeling (software rendering only, very slow)
- ⚠️ XR development requires physical XR hardware for testing

**With GPU Access:**
- ✅ Everything above
- ✅ Hardware-accelerated Android emulator
- ✅ Blender with GPU rendering
- ✅ Complete XR development workflow

## Usage

### 1. Import Template to Coder

```bash
# Clone or copy this template to your Coder templates directory
cd /path/to/coder/templates
cp -r /path/to/antigravity-xr .

# Push to your Coder server
coder templates push antigravity-xr
```

### 2. Create Workspace

```bash
# Via CLI
coder create my-xr-workspace --template antigravity-xr

# Or use the Coder web UI to create a new workspace
```

### 3. Configure Resources

During workspace creation, you can customize:
- **CPU**: 2, 4, or 8 cores (default: 4)
- **Memory**: 4 GB, 8 GB, or 16 GB (default: 8 GB)
- **Disk Size**: 30 GB, 50 GB, or 100 GB (default: 50 GB)

### 4. Access Development Environment

Once your workspace starts, you can access:

**Antigravity IDE**: `http://localhost:13337` (or via Coder's app portal)
**VS Code**: Via Coder's built-in VS Code support
**Android Studio**: Run `/home/coder/android-studio/bin/studio.sh`
**Blender**: Run `/home/coder/blender/blender`

## Getting Started with Android XR

### GPU-Less Development Workflow (Recommended for Most)

**Without GPU, develop on physical hardware:**

```bash
# 1. Connect physical Android XR device via USB
adb devices

# 2. Enable developer mode on device
# (Settings > About > Tap Build Number 7 times)

# 3. Deploy and test directly
./gradlew installDebug
adb logcat

# 4. Use scrcpy for screen mirroring (optional)
snap install scrcpy
scrcpy
```

### With GPU: Set Up Android XR Emulator

```bash
# List available system images
sdkmanager --list | grep xr

# Create an XR AVD (Android Virtual Device)
avdmanager create avd -n xr_device -k "system-images;android-34;google-xr;x86_64"

# Launch the emulator (requires GPU)
emulator -avd xr_device

# If slow, check GPU acceleration
emulator -avd xr_device -verbose
```

### 2. Create Your First XR Project

```bash
# Using Antigravity IDE
antigravity create-project --template android-xr

# Or use Android Studio's XR templates
android-studio/bin/studio.sh
```

### 3. Integrate AI with Genkit

```bash
# Initialize Genkit in your project
genkit init

# Follow the prompts to set up AI capabilities
```

## Environment Variables

The following environment variables are pre-configured:

```bash
ANDROID_HOME=/home/coder/Android/Sdk
ANDROID_SDK_ROOT=/home/coder/Android/Sdk
JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
```

## Documentation

All tool documentation is available in `/home/coder/dev-docs/`:

- `INDEX.md` - Quick reference hub
- `development-stack-reference-guide.md` - Android, Genkit, Firebase, Blender, Cloud SDK
- `claude-ai-guide.md` - Claude API and Claude Code
- `goose-guide.md` - Open-source AI agents
- `xreal-beam-pro-guide.md` - AR glasses and spatial computing
- `kali-linux-guide.md` - Security testing tools

## Troubleshooting

### Antigravity Won't Start

```bash
# Check if Antigravity is installed
antigravity --version

# Check logs
journalctl -u antigravity --no-pager -n 50

# Restart Antigravity
sudo systemctl restart antigravity
```

### Android SDK Issues

```bash
# Re-accept licenses
yes | sdkmanager --licenses

# Update all packages
sdkmanager --update

# Verify installation
sdkmanager --list_installed
```

### ADB Not Finding Devices

```bash
# Check ADB server status
adb devices

# Restart ADB server
adb kill-server
adb start-server
```

### Emulator Won't Start

```bash
# Enable KVM acceleration (if on Linux host)
sudo apt-get install qemu-kvm

# Check emulator configuration
emulator -list-avds

# Start with verbose logging
emulator -avd xr_device -verbose
```

## Customization

### Adding More SDK Packages

Edit `build/Dockerfile` and add packages to the sdkmanager install command:

```dockerfile
RUN ${ANDROID_HOME}/cmdline-tools/latest/bin/sdkmanager \
    "your-package-here" \
    # ... existing packages
```

### Changing Android Studio Version

Update the download URL in `build/Dockerfile`:

```dockerfile
RUN wget -q https://redirector.gvt1.com/edgedl/android/studio/ide-zips/VERSION/android-studio-VERSION-linux.tar.gz
```

### Adding Custom Tools

Add installation commands to `build/Dockerfile` before the final `CMD` instruction.

## Resource Requirements by Workload

| Workload | CPU | RAM | Disk | Notes |
|----------|-----|-----|------|-------|
| Template testing only | 2 cores | 4 GB | 30 GB | Not for actual dev work |
| Light code editing | 4 cores | 8 GB | 50 GB | No emulator, basic editing |
| Full IDE + single emulator | 8 cores | 16 GB | 100 GB | Realistic minimum for XR dev |
| XR + 3D editing workflow | 12 cores | 24 GB | 200 GB | Blender + emulator + IDE |
| Multiple emulators + builds | 16 cores | 32 GB | 200 GB | Heavy parallel development |

**GPU Requirements (CRITICAL):**
- **Android Emulator**: Requires GPU acceleration (KVM + GPU on Linux)
  - Without GPU: Use physical Android XR device via ADB instead
  - Software emulation is 10-100x slower, essentially unusable for XR
- **Blender 3D**: Requires GPU for any serious 3D work
  - Without GPU: Limited to very basic modeling, no real-time rendering
  - Software rendering takes minutes instead of seconds
- **XR Development**: Physical XR hardware strongly recommended regardless
  - Emulators can't fully replicate XR sensors and tracking
  - Budget for actual XR device (e.g., Meta Quest, Magic Leap, etc.)

**Docker GPU Passthrough Setup:**
```bash
# For NVIDIA GPUs with nvidia-docker2
docker run --gpus all -it antigravity-xr-workspace

# Verify GPU access in container
nvidia-smi
```

If your Coder host doesn't have GPU access, this template is best for:
1. **Code editing and builds** (no emulator)
2. **Physical device development** (ADB to real hardware)
3. **Backend/logic development** (no UI/3D work)

## Support

- **Antigravity Issues**: https://cloud.google.com/antigravity/docs
- **Coder Issues**: https://github.com/coder/coder/issues
- **Android XR**: https://developers.google.com/ar/develop/xr
- **Genkit**: https://firebase.google.com/docs/genkit

## License

This template is provided as-is for use with Coder. Individual tools have their own licenses:
- Antigravity: Google Terms of Service
- Android Studio: Apache 2.0 / IntelliJ Platform License
- Blender: GPL v3
- Google Cloud SDK: Google Terms of Service

## Version History

- **v1.0.0** - Initial release with Antigravity 1.11.9, Android XR SDK, full Google Cloud AI stack
