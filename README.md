# NewRelic Memory Leak investigation

We identified an huge memory consumption in our Php application under particular conditions with NewRelic.
Also discussed [here](https://discuss.newrelic.com/t/php-agent-9-serious-memory-leak-issues/80863/56).
This code try to provide a minimal _step to reproduce_.

## Conditions
* Version `9.11` does not have the issue.
* Versions `9.12` to `9.16` have the issue.
* With `-dnewrelic.transaction_tracer.detail=0`, no more memory issue (default value is `1`).

## How to
First, build the docker image
```
make build
```

Then launch `php-fpm` with expected value for `transaction_tracer.detail`
```
make fpm-detail-0
```
or
```
make fpm-detail-1
```

While FPM is running, in another terminal session, launch the memory test:
```
make memory-test
```
Lot of requests will be sent to `Php-Fpm` and memory consumption will be displayed during progress.
``` 
NewRelic Status:
X-Powered-By: PHP/7.4.15
Content-type: text/html; charset=UTF-8

newrelic loaded: true
newrelic.transaction_tracer.enabled: true
newrelic.transaction_tracer.detail: false
====
Launching 100000 requests…
0%   31186944
1%   32583680
2%   32698368
…
96%   30523392
97%   30638080
98%   30515200
99%   30535680
```