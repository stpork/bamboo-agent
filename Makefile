IMAGE_NAME = bamboo-agent

.PHONY: build
build:
	docker build -t $(IMAGE_NAME) .

.PHONY: rebuild
rebuild:
	docker build --no-cache -t $(IMAGE_NAME) .

.PHONY: test
test:
	docker build -t $(IMAGE_NAME)-candidate .
	IMAGE_NAME=$(IMAGE_NAME)-candidate test/run
