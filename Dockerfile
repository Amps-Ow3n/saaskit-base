#  Base PHP image with FPM and MySQL support
FROM php:8.3-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git curl libpng-dev libonig-dev libxml2-dev zip unzip \
    && docker-php-ext-install pdo pdo_mysql mbstring exif pcntl bcmath gd \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

#  Install Composer
COPY --from=composer:2.7 /usr/bin/composer /usr/bin/composer

#  Set working directory
WORKDIR /var/www

#  Copy project files
COPY . .

#  Install PHP dependencies
RUN composer install --no-interaction --no-dev --prefer-dist

#  Install Node.js + frontend dependencies and build
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && npm install \
    && npm run build \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

#  Copy .env if not exists
RUN cp .env.example .env || true

#  Generate Laravel app key (only if APP_KEY not set in Render env)
RUN php artisan key:generate || true

#  Expose port for Render
EXPOSE 8000

#  Run migrations and start Laravel
CMD php artisan migrate --force && php -S 0.0.0.0:$PORT -t public

