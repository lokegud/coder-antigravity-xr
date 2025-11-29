#!/bin/bash
set -e

# Coder Agent Startup Script for Antigravity XR Workspace

echo "🚀 Starting Antigravity XR Development Environment..."

# Start Coder agent
echo "📡 Starting Coder agent..."
/tmp/coder agent

# Accept Android SDK licenses (if not already accepted)
if [ -d "$ANDROID_HOME/cmdline-tools/latest/bin" ]; then
    echo "✅ Accepting Android SDK licenses..."
    yes | $ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager --licenses > /dev/null 2>&1 || true
fi

# Initialize Firebase (if needed)
if [ ! -f "$HOME/.firebaserc" ]; then
    echo "🔥 Firebase tools available - run 'firebase login' to authenticate"
fi

# Start Antigravity IDE
if command -v antigravity &> /dev/null; then
    echo "🌟 Starting Antigravity IDE on port 13337..."
    antigravity serve --port 13337 --host 0.0.0.0 &
fi

echo "✨ Antigravity XR workspace ready!"
echo ""
echo "Available tools:"
echo "  • Antigravity IDE: http://localhost:13337"
echo "  • Android Studio: /snap/bin/android-studio"
echo "  • Blender: /snap/bin/blender"
echo "  • ADB: adb devices"
echo "  • Genkit: genkit --help"
echo "  • Firebase: firebase --help"
echo "  • Google Cloud: gcloud --version"
echo ""
echo "📚 Documentation: /home/coder/dev-docs/"
