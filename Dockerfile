FROM codercom/enterprise-base:ubuntu

USER root

ENV DEBIAN_FRONTEND=noninteractive
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV ANDROID_HOME=/opt/android-sdk
ENV ANDROID_SDK_ROOT=/opt/android-sdk
ENV PATH=${PATH}:${JAVA_HOME}/bin:${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools
ENV ANDROID_CMDLINE_TOOLS_VERSION=13114758
ENV NODE_MAJOR=20

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    gnupg \
    openjdk-17-jdk \
    unzip \
    wget \
    lib32stdc++6 \
    lib32z1 \
  && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/apt/keyrings \
  && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg \
  && echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_${NODE_MAJOR}.x nodistro main" > /etc/apt/sources.list.d/nodesource.list \
  && apt-get update \
  && apt-get install -y --no-install-recommends nodejs \
  && corepack enable \
  && corepack prepare yarn@stable --activate \
  && rm -rf /var/lib/apt/lists/*

RUN mkdir -p ${ANDROID_HOME}/cmdline-tools \
  && wget -q https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_CMDLINE_TOOLS_VERSION}_latest.zip -O /tmp/android-cmdline-tools.zip \
  && unzip -q /tmp/android-cmdline-tools.zip -d ${ANDROID_HOME}/cmdline-tools \
  && mv ${ANDROID_HOME}/cmdline-tools/cmdline-tools ${ANDROID_HOME}/cmdline-tools/latest \
  && yes | sdkmanager --sdk_root=${ANDROID_HOME} --licenses > /dev/null \
  && sdkmanager --sdk_root=${ANDROID_HOME} \
    "platform-tools" \
    "platforms;android-35" \
    "build-tools;35.0.0" \
  && rm -f /tmp/android-cmdline-tools.zip \
  && chown -R coder:coder ${ANDROID_HOME}

USER coder