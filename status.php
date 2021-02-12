<?php

echo 'newrelic loaded: ' . (extension_loaded('newrelic') ? 'true' : 'false') . PHP_EOL;
echo 'newrelic.transaction_tracer.enabled: ' . (ini_get('newrelic.transaction_tracer.enabled') ? 'true' : 'false') . PHP_EOL;
echo 'newrelic.transaction_tracer.detail: ' . (ini_get('newrelic.transaction_tracer.detail') ? 'true' : 'false') . PHP_EOL;



