<?php

function recursiveCount(int $level): void
{
    if ($level <= 1) {
        throw new \Exception('Oops');
    }

    recursiveCount($level - 1);
}

for($i= 0; $i<100; ++$i) {
    try {
        recursiveCount(10);
    } catch(\Exception $e) {
        // continue
    }
}

echo "That's all folks\n";
