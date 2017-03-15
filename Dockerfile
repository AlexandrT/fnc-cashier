FROM java:8

ENV TEST_ENV production
WORKDIR /root

# install needed packages
RUN \
     apt-get update -q \
  && apt-get install -yq \
       software-properties-common \
       build-essential \
       libssl-dev \
       libreadline-dev \
       zlib1g-dev \
       libyaml-dev \
       libxml2-dev \
       libxslt-dev \
       git \
       wget

# install Android SDK
#RUN cd /opt && wget -q --output-document=android-sdk-linux.zip https://dl.google.com/android/repository/tools_r25.2.5-linux.zip
#RUN cd /opt && unzip android-sdk-linux.zip -d android-sdk-linux
#RUN cd /opt && rm -f android-sdk-linux.zip
RUN wget http://dl.google.com/android/android-sdk_r23-linux.tgz
RUN tar -xvzf android-sdk_r23-linux.tgz && rm android-sdk_r23-linux.tgz
RUN mv android-sdk-linux /usr/local/android-sdk
RUN chown -R root:root /usr/local/android-sdk/

# Other tools and resources of Android SDK
ENV DEBIAN_FRONTEND noninteractive
ENV ANDROID_HOME /usr/local/android-sdk
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools
RUN echo y | android update sdk -a --no-ui --force --filter platform-tools
#RUN echo y | android update sdk -a --no-ui --force --filter platform
#RUN echo y | android update sdk -a --no-ui --force --filter build-tools-23.0.1
RUN echo y | android update sdk -a --no-ui --force --filter android-23
RUN echo y | android update sdk -a --no-ui --force --filter sys-img-x86_64-android-23
RUN echo y | android update adb
#RUN echo y | android update sdk -a --no-ui --force --filter extra-android-support,extra-android-m2repository,extra-google-google_play_services,extra-google-m2repository

# install rbenv and ruby-build
RUN \
     git clone https://github.com/rbenv/rbenv.git $HOME/.rbenv \
  && echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> $HOME/.bash_profile \
  && echo 'eval "$(rbenv init -)"' >> $HOME/.bash_profile \
  && export PATH="$HOME/.rbenv/bin:$PATH" \
  && git clone https://github.com/rbenv/ruby-build.git $HOME/.rbenv/plugins/ruby-build \
  && rbenv install 2.3.0

# Set up and run emulator
RUN echo n | android create avd --force -n test -t android-23
ENV HOME /root
COPY dev/scripts/wait-for-emulator /usr/local/bin/
COPY dev/scripts/start-emulator /usr/local/bin/
RUN cd /usr/local/bin && chmod +x start-emulator && chmod +x wait-for-emulator

RUN  mkdir -p /root/www/fnc-cashier

WORKDIR www/fnc-cashier

# clone tests
COPY . /root/www/fnc-cashier

RUN /bin/bash -l -c \
     "gem install bundler \
  && bundle install"

RUN curl -sL https://deb.nodesource.com/setup_6.x | bash - && \
    apt-get install nodejs

RUN cd ~ && npm install -g appium

RUN appium & >> appium.log

RUN start-emulator

CMD ["./run.sh"]
