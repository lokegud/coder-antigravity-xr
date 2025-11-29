FROM ubuntu:22.04

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Set up basic environment
ENV LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    TZ=UTC

# Install base dependencies
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    build-essential \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release \
    unzip \
    zip \
    vim \
    nano \
    sudo \
    locales \
    && locale-gen en_US.UTF-8 \
    && rm -rf /var/lib/apt/lists/*

# Install Java OpenJDK 21 (required for Android development)
RUN apt-get update && apt-get install -y openjdk-21-jdk \
    && rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64

# Install Node.js 20.x (for Genkit, Firebase tools)
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Install Google Cloud SDK
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | \
    tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | \
    gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg && \
    apt-get update && apt-get install -y google-cloud-cli \
    && rm -rf /var/lib/apt/lists/*

# Install ADB and Fastboot
RUN apt-get update && apt-get install -y \
    android-tools-adb \
    android-tools-fastboot \
    && rm -rf /var/lib/apt/lists/*

# Install Antigravity IDE
RUN curl -fsSL https://us-central1-apt.pkg.dev/projects/antigravity-auto-updater-dev/antigravity-debian/gpg.key | \
    gpg --dearmor -o /etc/apt/keyrings/antigravity-repo-key.gpg && \
    echo "deb [signed-by=/etc/apt/keyrings/antigravity-repo-key.gpg] https://us-central1-apt.pkg.dev/projects/antigravity-auto-updater-dev/ antigravity-debian main" | \
    tee /etc/apt/sources.list.d/antigravity.list && \
    apt-get update && apt-get install -y antigravity \
    && rm -rf /var/lib/apt/lists/*

# Create coder user with sudo privileges
RUN useradd -m -s /bin/bash -G sudo coder && \
    echo "coder ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Switch to coder user for remaining installations
USER coder
WORKDIR /home/coder

# Install Node.js global packages (Genkit, Firebase, Google AI)
RUN npm install -g genkit firebase-tools @google/generative-ai

# Set up Android SDK
ENV ANDROID_HOME=/home/coder/Android/Sdk \
    ANDROID_SDK_ROOT=/home/coder/Android/Sdk

ENV PATH=${PATH}:${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/emulator:${ANDROID_HOME}/tools

# Download and install Android command-line tools
RUN mkdir -p ${ANDROID_HOME}/cmdline-tools && \
    cd ${ANDROID_HOME}/cmdline-tools && \
    wget -q https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip && \
    unzip commandlinetools-linux-11076708_latest.zip && \
    rm commandlinetools-linux-11076708_latest.zip && \
    mv cmdline-tools latest

# Install Android SDK packages
RUN yes | ${ANDROID_HOME}/cmdline-tools/latest/bin/sdkmanager --licenses && \
    ${ANDROID_HOME}/cmdline-tools/latest/bin/sdkmanager \
    "platform-tools" \
    "platforms;android-34" \
    "platforms;android-35" \
    "build-tools;35.0.0" \
    "build-tools;34.0.0" \
    "emulator" \
    "system-images;android-35;google_apis;x86_64" \
    "system-images;android-34;google-xr;x86_64" \
    "system-images;android-34;google-xr;arm64-v8a"

# Download Android Studio (user can launch from command line)
RUN mkdir -p /home/coder/android-studio && \
    cd /home/coder && \
    wget -q https://redirector.gvt1.com/edgedl/android/studio/ide-zips/2024.2.1.10/android-studio-2024.2.1.10-linux.tar.gz && \
    tar -xzf android-studio-2024.2.1.10-linux.tar.gz && \
    rm android-studio-2024.2.1.10-linux.tar.gz

ENV PATH=${PATH}:/home/coder/android-studio/bin

# Download Blender (user can launch from command line)
RUN mkdir -p /home/coder/blender && \
    cd /home/coder && \
    wget -q https://download.blender.org/release/Blender4.2/blender-4.2.0-linux-x64.tar.xz && \
    tar -xf blender-4.2.0-linux-x64.tar.xz && \
    rm blender-4.2.0-linux-x64.tar.xz && \
    mv blender-4.2.0-linux-x64 blender

ENV PATH=${PATH}:/home/coder/blender

# Create dev-docs directory structure
RUN mkdir -p /home/coder/dev-docs

# Set up workspace directory
RUN mkdir -p /home/coder/workspace

WORKDIR /home/coder/workspace

# Expose Antigravity port
EXPOSE 13337

# Health check for Antigravity
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:13337/healthz || exit 1

CMD ["/bin/bash"]
