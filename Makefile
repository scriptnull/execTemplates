.PHONY: lint

lint:
	docker run --rm -v "$(shell pwd):/mnt" koalaman/shellcheck -s bash $(shell find ./integrations -name "*.sh")
