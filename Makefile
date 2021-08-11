IMAGE_NAME := buildroot

VOLUMES_CONTAINER_NAME := $(IMAGE_NAME)_volumes

.PHONY: all
all: run

.PHONY: image
image:
	docker build -t $(IMAGE_NAME) .

# Run a new container with no-op command to create a volume only
# container.
# The volumes created with this container retained until, for example,
# this container is removed by `docker rm` with `-v`.
# See `clean`.
.PHONY: volumes
volumes:
	docker run \
	--name $(VOLUMES_CONTAINER_NAME) \
	$(IMAGE_NAME) \
	echo done

# Use anonymous volumes associated to the stub container created
# by `volumes` target.
# Give ARGS="..." to pass extra arguments to `docker run`.
.PHONY: run
run:
	docker run \
	--rm \
	--interactive \
	--tty \
	--volumes-from $(VOLUMES_CONTAINER_NAME) \
	-v `pwd`/images:/output/images \
	$(ARGS) \
	$(IMAGE_NAME)

.PHONY: clean
clean:
	docker rm -v $(VOLUMES_CONTAINER_NAME) || true
	docker rmi $(IMAGE_NAME) || true
	git clean -dfX
