<?php

require 'tools.php';

echo "NewRelic Status:\n" . join(PHP_EOL, execFpm('status.php')) . PHP_EOL;

const HEADERS = [
];

echo "Result of first request:\n========\n";
echo join(PHP_EOL, execFpm('sf-project/public/index.php', HEADERS));
echo "\n===============\n";

$nb = $argv[1] ?? 1000;
echo "====\nLaunching $nb requests…\n";

$lastProgress = -1;
for($i = 0; $i < $nb; ++$i) {
    execFpm('sf-project/public/index.php', HEADERS);

    $progress = intval(100*$i / $nb);
    if($progress !== $lastProgress) {
        $mem = memUsage();
        echo "$progress%   $mem\n";
        $lastProgress = $progress;
    }
}