<?php

$output = [];
exec("SCRIPT_NAME=status.php SCRIPT_FILENAME=status.php REQUEST_METHOD=GET REMOTE_ADDR='127.0.0.1' cgi-fcgi -bind -connect /run/php-fpm.sock", $output);
echo "NewRelic Status:\n" . join(PHP_EOL, $output) . PHP_EOL;

$nb = $argv[1] ?? 1000;
echo "====\nLaunching $nb requests…\n";

const CMD = 'SCRIPT_NAME=status.php SCRIPT_FILENAME=status.php REQUEST_METHOD=GET REMOTE_ADDR="127.0.0.1" cgi-fcgi -bind -connect /run/php-fpm.sock';
const MEMORY = 'cat /sys/fs/cgroup/memory/memory.usage_in_bytes';

$lastProgress = -1;
for($i = 0; $i < $nb; ++$i) {
    $output = [];
    $result = 0;
    exec(CMD, $output, $result);

    if($result !== 0) {
        echo "ERROR\n";
    } else {
        $mem = exec(MEMORY);

        $progress = intval(100*$i / $nb);
        if($progress !== $lastProgress) {
            echo "$progress%   $mem\n";
            $lastProgress = $progress;
        }
    }
}