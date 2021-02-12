<?php

require 'tools.php';

echo "NewRelic Status:\n" . join(PHP_EOL, execFpm('status.php')) . PHP_EOL;

$nb = $argv[1] ?? 1000;
echo "====\nLaunching $nb requests…\n";

$lastProgress = -1;
for($i = 0; $i < $nb; ++$i) {
    execFpm('myPage.php');

    $progress = intval(100*$i / $nb);
    if($progress !== $lastProgress) {
        $mem = memUsage();
        echo "$progress%   $mem\n";
        $lastProgress = $progress;
    }
}