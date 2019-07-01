FROM resin/intel-nuc-node:8

RUN printf "deb http://archive.debian.org/debian/ jessie main\ndeb-src http://archive.debian.org/debian/ jessie main\ndeb http://security.debian.org jessie/updates main\ndeb-src http://security.debian.org jessie/updates main" > /etc/apt/sources.list

# Install other apt deps
RUN apt-get update && apt-get install -y --no-install-recommends \
  apt-utils \
  clang \
  xserver-xorg-core \
  xserver-xorg-input-all \
  xserver-xorg-video-fbdev \
  xorg \
  libxcb-image0 \
  libxcb-util0 \
  xdg-utils \
  libdbus-1-dev \
  libgtk2.0-dev \
  libnotify-dev \
  libgnome-keyring-dev \
  libgconf2-dev \
  libasound2-dev \
  libcap-dev \
  libcups2-dev \
  libxtst-dev \
  libxss1 \
  libnss3-dev \
  libsmbclient \
  libssh-4 \
  fbset \
  libexpat-dev && rm -rf /var/lib/apt/lists/*



RUN echo "#!/bin/bash" > /etc/X11/xinit/xserverrc \
  && echo "" >> /etc/X11/xinit/xserverrc \
  && echo 'exec /usr/bin/X -s 0 dpms -nocursor -nolisten tcp "$@"' >> /etc/X11/xinit/xserverrc
# COPY ./xinitrc /root/.xinitrc
# COPY ./10-monitor.conf /usr/share/X11/xorg.conf.d/10-monitor.conf
# COPY ./40-libinput.conf /usr/share/X11/xorg.conf.d/40-libinput.conf

# Move to app dir
WORKDIR /usr/src/app

# Move package.json to filesystem
COPY ./app/package.json ./

# Install npm modules for the application
RUN JOBS=MAX npm install --unsafe-perm --production && npm cache clean --force && \
  rm -rf /tmp/* && node_modules/.bin/electron-rebuild

# Move app to filesystem
COPY ./app ./

# Build react app
RUN JOBS=MAX npm run build

## uncomment if you want systemd
ENV INITSYSTEM on

# Start app
CMD ["bash", "/usr/src/app/start.sh"]
