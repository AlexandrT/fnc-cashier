FROM java:8

ENV TEST_ENV development
ENV DEBIAN_FRONTEND noninteractive
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

# install rbenv and ruby-build
RUN \
     git clone https://github.com/rbenv/rbenv.git $HOME/.rbenv \
  && echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> $HOME/.bash_profile \
  && echo 'eval "$(rbenv init -)"' >> $HOME/.bash_profile \
  && export PATH="$HOME/.rbenv/bin:$PATH" \
  && git clone https://github.com/rbenv/ruby-build.git $HOME/.rbenv/plugins/ruby-build \
  && rbenv install 2.3.0

# install Android SDK
RUN wget http://dl.google.com/android/android-sdk_r24.4.1-linux.tgz \
  && tar -xvzf android-sdk_r24.4.1-linux.tgz \
  && rm android-sdk_r24.4.1-linux.tgz \
  && mv android-sdk-linux /usr/local/android-sdk \
  && chown -R root:root /usr/local/android-sdk/

# Other tools and resources of Android SDK
ENV ANDROID_HOME /usr/local/android-sdk
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools
RUN echo y | android update sdk -a --no-ui --force --filter platform-tools,build-tools-24.0.0,android-19,sys-img-armeabi-v7a-android-19

# Set up and run emulator
RUN echo n | android create avd --force -n test -t android-19
ENV HOME /root

RUN  \
     mkdir -p /root/www/fnc-cashier \
  && mkdir /var/log/tests

WORKDIR www/fnc-cashier

# clone tests
COPY . /root/www/fnc-cashier

RUN /bin/bash -l -c \
     "gem install bundler \
  && bundle install"

RUN curl -sL https://deb.nodesource.com/setup_6.x | bash - && \
    apt-get install nodejs && \
    cd ~ && \
    npm install -g appium

VOLUME ["/var/log/tests"]
CMD ["/root/www/fnc-cashier/run.sh"]
