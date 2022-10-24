FROM node:17-buster-slim

# We don't need the standalone Chromium
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD true

# Install Google Chrome Stable and fonts
# Note: this installs the necessary libs to make the browser work with Puppeteer.
# To run Headful mode, you will need to have a display, which is not present in a server.
# To avoid this, we will use Xvfb, and create a fake display, so the chrome will think there is a display and run properly.
# So we just need to install Xvfb and Puppeteer related dependencies.

RUN apt-get update && apt-get install gnupg wget -y && \
  wget --quiet --output-document=- https://dl-ssl.google.com/linux/linux_signing_key.pub | gpg --dearmor > /etc/apt/trusted.gpg.d/google-archive.gpg && \
  sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' && \
  apt-get update && \
  apt-get install google-chrome-stable fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst fonts-freefont-ttf libxss1 gconf-service libasound2 libatk1.0-0 libc6 libcairo2 libcups2 libdbus-1-3 libexpat1 libfontconfig1 libgcc1 libgconf-2-4 libgdk-pixbuf2.0-0 libglib2.0-0 libgtk-3-0 libnspr4 libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6 ca-certificates fonts-liberation libappindicator1 libnss3 lsb-release xdg-utils wget x11vnc x11-xkb-utils xfonts-100dpi xfonts-75dpi xfonts-scalable xfonts-cyrillic x11-apps xvfb -y --no-install-recommends && \
  rm -rf /var/lib/apt/lists/*



RUN groupadd -r pptruser && useradd -m -r -g pptruser -G audio,video pptruser

WORKDIR /home/pptruser
COPY package*.json ./
COPY run.js ./
RUN chmod -R o+rwx /usr/bin/google-chrome

RUN npm ci --only=production


USER pptruser
CMD ["xvfb-run", "--server-args", "-screen 0 1024x768x24", "node", "run.js" ]