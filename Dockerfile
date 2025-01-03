FROM dunglas/frankenphp:1.2.5-php8.3.13-bookworm

LABEL authors="Cybrarist"

ENV SERVER_NAME=":80"
ENV FRANKENPHP_CONFIG="worker /app/public/index.php"
ENV FRANKEN_HOST="localhost"

RUN apt update && apt install -y supervisor  \
        libbz2-dev \
        libzip-dev \
        libmcrypt-dev \
        libicu-dev \
        gnupg \
        ca-certificates \
        libx11-xcb1 \
        libxcomposite1 \
        libxdamage1 \
        libxrandr2 \
        libatk1.0-0 \
        libnspr4 \
        libnss3 \
        libgtk-3-0 \
        libgbm-dev \
        libpango-1.0-0 \
        libatspi2.0-0 \
        libxshmfence1 \
        libxtst6 \
        chromium \
        chromium-driver \
        xvfb \
        xdg-utils \
        wget \
        && apt-get clean



# Set environment variables for Chromium
ENV CHROME_BIN="/usr/bin/chromium-browser"
ENV CHROME_OPTS=" --disable-dev-shm-usage --headless --disable-gpu --no-sandbox --enable-features=ConversionMeasurement --remote-debugging-port=9222 "

RUN docker-php-ext-install   pcntl \
        opcache \
        pdo_mysql \
        pdo \
        bz2 \
        intl \
        iconv \
        bcmath \
        calendar \
        pdo_mysql \
        sockets \
        zip

ENV GET_COMPOSER_VERSION="76a7060ccb93902cd7576b67264ad91c8a2700e2"
ENV COMPOSER_VERSION=2.8.2

RUN wget https://raw.githubusercontent.com/composer/getcomposer.org/$GET_COMPOSER_VERSION/web/installer -O - -q | php -- --quiet --version="$COMPOSER_VERSION" \
	&& mv composer.phar /usr/local/bin/composer

COPY ./docker/base_supervisord.conf /etc/supervisor/conf.d/supervisord.conf

COPY . /app

WORKDIR /app

EXPOSE 80 443 2019 8080

RUN chmod +x /app/*

RUN mkdir -p /config/chromium


ENV DISPLAY=:99


ENTRYPOINT ["docker/entrypoint.sh"]
