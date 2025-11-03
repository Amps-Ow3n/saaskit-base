<?php

/**
 * Laravel server.php for Render Free Docker SPA routing
 */

$uri = urldecode(
    parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH)
);

// Serve the requested resource as-is if it exists in public
if ($uri !== '/' && file_exists(__DIR__.'/public'.$uri)) {
    return false;
}

// Otherwise, route all requests through index.php
require_once __DIR__.'/public/index.php';
