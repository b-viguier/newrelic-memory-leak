<?php

function recursiveCount(int $level): int
{
    if ($level <= 1) {
        return 1;
    }

    return 1 + recursiveCount($level - 1);
}

$count = recursiveCount(100);

echo "Count: $count\n";
