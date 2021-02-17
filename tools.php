<?php

function execFpm(string $scriptPath, array $headers = []): array
{
    $headers = join(' ', array_map(fn($k,$v) => "$k=\"$v\"", array_keys($headers), array_values($headers)));

    $output = [];
    $result = 0;
    exec(
        "$headers SCRIPT_NAME=$scriptPath SCRIPT_FILENAME=$scriptPath REQUEST_METHOD=GET REMOTE_ADDR='127.0.0.1' SHELL_VERBOSITY=1 cgi-fcgi -bind -connect /run/php/php7.4-fpm.sock",
        $output,
        $result
    );

    if($result !== 0) {
        echo "ERROR while executing [$scriptPath]\n";
    }

    return $output;
}

function memUsage(): string
{
    return exec('cat /sys/fs/cgroup/memory/memory.usage_in_bytes');
}

if(($argv[1] ?? null) !== null && get_included_files() === [__FILE__]) {
    echo "Executing [$argv[1]] through Php-Fpm\n=====================\n\n";
    echo join(PHP_EOL, execFpm($argv[1])) . PHP_EOL;
}