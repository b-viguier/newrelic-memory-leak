<?php


function foo(int $level) {
    if($level <= 0) {
        throw new \Exception('My Exception');
    }
    foo($level-1);
}


for($i=0;$i<100;++$i) {
    try {
        //$resolver->resolve($request);
        foo(10);
    } catch (\Exception $e) {
        // continue
    }
}

die("This is it 2");

