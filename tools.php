<?php

function execFpm(string $scriptPath): array
{
    $output = [];
    $result = 0;
    exec(
        "SCRIPT_NAME=$scriptPath SCRIPT_FILENAME=$scriptPath REQUEST_METHOD=GET REMOTE_ADDR='127.0.0.1' cgi-fcgi -bind -connect /run/php-fpm.sock",
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
