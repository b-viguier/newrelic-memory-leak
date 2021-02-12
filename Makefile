build:
	@docker build ./ --rm --tag "newrelic-memory-leak:latest"

memory-test:
	@docker exec -it newrelic-memory-leak php memory-test.php 100000

status:
	@docker exec -it newrelic-memory-leak php status.php

attach:
	@docker exec -it newrelic-memory-leak bash -c "test=$(PWD) bash"

fpm-detail-0:
	@docker run --rm  --name newrelic-memory-leak --volume $(PWD):/app -it newrelic-memory-leak:latest php-fpm -dnewrelic.appname="Memory Test" -dnewrelic.license=$(NR_LICENSE) -dnewrelic.transaction_tracer.detail=0

fpm-detail-1:
	@docker run --rm  --name newrelic-memory-leak --volume $(PWD):/app -it newrelic-memory-leak:latest php-fpm -dnewrelic.appname="Memory Test" -dnewrelic.license=$(NR_LICENSE) -dnewrelic.transaction_tracer.detail=1
