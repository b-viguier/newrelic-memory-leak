.PHONY: help

help:
	@grep -E '^[0-9a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

build:  ## Build the docker image
	@docker build ./ --rm --tag "newrelic-memory-leak:latest"

memory-test:    ## Launch memory tests (requires fpm-detail-* target running distinctly)
	@docker exec -it newrelic-memory-leak php memory-test.php 1000

status: ## Display status page content
	@docker exec -it newrelic-memory-leak php tools.php status.php

hello:  ## Display default page content
	@docker exec -it newrelic-memory-leak php tools.php sf-project/public/index.php

attach: ## Connect to the running fpm container
	@docker exec -it newrelic-memory-leak bash

fpm-detail-0:   ## Run the FPM container, with details disabled
	@docker run --rm  --name newrelic-memory-leak --volume $(PWD):/app -it newrelic-memory-leak:latest php-fpm -O -F -dnewrelic.appname="Memory Test" -dnewrelic.license=$(NR_LICENSE) -dnewrelic.transaction_tracer.detail=0

fpm-detail-1:   ## Run the FPM container with details enabled
	@docker run --rm  --name newrelic-memory-leak --volume $(PWD):/app -it newrelic-memory-leak:latest php-fpm -O -F -dnewrelic.appname="Memory Test" -dnewrelic.license=$(NR_LICENSE) -dnewrelic.transaction_tracer.detail=1
