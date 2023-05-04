FROM gradle:7.4.0-jdk11

RUN mkdir /java-agent-espresso
COPY .  /java-agent-espresso
WORKDIR /java-agent-espresso

ENV ANDROID_HOME=/java-agent-espresso/android-sdk
ENV ANDROID_CLI_TOOLS_URL="https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip"
ENV ANDROID_API_LEVEL="33"
ENV ANDROID_BUILD_TOOLS_VERSION="33.0.0"

# Download android command line tools from remote repository
RUN mkdir -p /java-agent-espresso/android-sdk/cmdline-tools && \
    wget ${ANDROID_CLI_TOOLS_URL} && \
    unzip *tools*linux*.zip -d /java-agent-espresso/android-sdk/cmdline-tools && \
    mv /java-agent-espresso/android-sdk/cmdline-tools/cmdline-tools /java-agent-espresso/android-sdk/cmdline-tools/tools && \
    rm *tools*linux*.zip

ENV PATH ${PATH}:/java-agent-espresso/android-sdk/cmdline-tools/latest/bin:/java-agent-espresso/android-sdk/cmdline-tools/tools/bin:/java-agent-espresso/android-sdk/platform-tools:/java-agent-espresso/android-sdk/emulator

# Install appropriate Android SDK version
RUN yes | sdkmanager --licenses && \
		sdkmanager "platforms;android-${ANDROID_API_LEVEL}" "build-tools;${ANDROID_BUILD_TOOLS_VERSION}" && \
		cd /java-agent-espresso
