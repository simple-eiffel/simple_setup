$libs = @(
    'SIMPLE_BASE64',
    'SIMPLE_HASH',
    'SIMPLE_UUID',
    'SIMPLE_RANDOMIZER',
    'SIMPLE_JSON',
    'SIMPLE_XML',
    'SIMPLE_CSV',
    'SIMPLE_MARKDOWN',
    'SIMPLE_DATETIME',
    'SIMPLE_VALIDATION',
    'SIMPLE_REGEX',
    'SIMPLE_PROCESS',
    'SIMPLE_LOGGER',
    'SIMPLE_HTMX',
    'SIMPLE_ENV',
    'SIMPLE_SYSTEM',
    'SIMPLE_CONSOLE',
    'SIMPLE_CLIPBOARD',
    'SIMPLE_REGISTRY',
    'SIMPLE_MMAP',
    'SIMPLE_IPC',
    'SIMPLE_WATCHER',
    'SIMPLE_WIN32_API',
    'SIMPLE_CACHE',
    'SIMPLE_TEMPLATE',
    'SIMPLE_JWT',
    'SIMPLE_CORS',
    'SIMPLE_RATE_LIMITER',
    'SIMPLE_SMTP',
    'SIMPLE_SQL',
    'SIMPLE_WEBSOCKET',
    'SIMPLE_HTTP',
    'SIMPLE_ENCRYPTION',
    'SIMPLE_CONFIG',
    'SIMPLE_PDF',
    'SIMPLE_TESTING',
    'SIMPLE_FOUNDATION_API',
    'SIMPLE_SERVICE_API',
    'SIMPLE_WEB',
    'SIMPLE_APP_API',
    'SIMPLE_ALPINE',
    'SIMPLE_AI_CLIENT',
    'SIMPLE_GUI_DESIGNER',
    'SIMPLE_SETUP'
)

foreach ($name in $libs) {
    $libName = $name.ToLower()
    $path = "D:\prod\$libName"
    [Environment]::SetEnvironmentVariable($name, $path, 'User')
    Write-Host "$name = $path"
}

Write-Host "`nAll environment variables reset to D:\prod"
