<?php

namespace App\Controller;

use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;

function foo(int $level) {
    if($level <= 0) {
        throw new \Exception('My Exception');
    }

    foo($level-1);
}

class DefaultController
{
    public function index(Request $request): Response
    {
        for($i=0;$i<30*8;++$i) {
            try {
                foo(10);
            } catch (\Exception $e) {
                // continue
            }
        }

        return new Response('Pray for it');
    }
}