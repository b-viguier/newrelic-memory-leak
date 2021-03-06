.PHONY: help

help:
	@grep -E '^[0-9a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

build:  ## Build the docker image
	@docker build ./ --rm --tag "newrelic-memory-leak:latest"

memory-test: opcache-reset    ## Launch memory tests (requires fpm-detail-* target running distinctly)
	@docker exec -it newrelic-memory-leak php memory-test.php 10000

status: opcache-reset ## Display status page content
	@docker exec -it newrelic-memory-leak php tools.php status.php

hello: opcache-reset  ## Display default page content
	@docker exec -it newrelic-memory-leak php tools.php myPage.php

opcache-reset:  ## Reset opcache from FPM
	@docker exec -it newrelic-memory-leak php tools.php opcache-reset.php

attach: ## Connect to the running fpm container
	@docker exec -it newrelic-memory-leak bash

fpm-detail-0:   ## Run the FPM container, with details disabled
	@docker run --rm  --name newrelic-memory-leak --volume $(PWD):/app -it newrelic-memory-leak:latest php-fpm -O -F -dnewrelic.license=$(NR_LICENSE) -dnewrelic.transaction_tracer.detail=0

fpm-detail-1:   ## Run the FPM container with details enabled
	@docker run --rm  --name newrelic-memory-leak --volume $(PWD):/app -it newrelic-memory-leak:latest php-fpm -O -F -dnewrelic.license=$(NR_LICENSE) -dnewrelic.transaction_tracer.detail=1
