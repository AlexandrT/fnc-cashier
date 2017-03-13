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
#       libgd2-xpm \
#       ia32-libs \
#       ia32-libs-multiarch \
       wget
#       lsb-release \

# install Android SDK
RUN cd /opt && wget -q --output-document=android-sdk-linux.zip https://dl.google.com/android/repository/tools_r25.2.5-linux.zip
RUN cd /opt && unzip android-sdk-linux.zip -d android-sdk-linux
RUN cd /opt && rm -f android-sdk-linux.zip

# Other tools and resources of Android SDK
ENV ANDROID_HOME /opt/android-sdk-linux
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools
RUN echo y | android update sdk --filter platform-tools,build-tools-25.0.2,android-25,extra-android-support,extra-android-m2repository,extra-google-google_play_services,extra-google-m2repository --no-ui --force

# install rbenv and ruby-build
RUN \
     git clone https://github.com/rbenv/rbenv.git $HOME/.rbenv \
  && echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> $HOME/.bash_profile \
  && echo 'eval "$(rbenv init -)"' >> $HOME/.bash_profile \
  && export PATH="$HOME/.rbenv/bin:$PATH" \
  && git clone https://github.com/rbenv/ruby-build.git $HOME/.rbenv/plugins/ruby-build \
  && rbenv install 2.3.0

# Set up and run emulator
RUN echo no | android create avd --force -n test -t android-25 --abi default/x86_64
ENV HOME /root
ADD wait-for-emulator /usr/local/bin/
ADD start-emulator /usr/local/bin/

RUN  mkdir -p /root/www/fnc-cashier

WORKDIR www/fnc-cashier

# clone tests
COPY . /root/www/fnc-cashier

RUN /bin/bash -l -c \
     "gem install bundler \
  && bundle install"

CMD ["/bin/bash"]
