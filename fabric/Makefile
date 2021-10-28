include project.properties

DETACH :=
CMD := bash inside/dev.sh && bash

# -----------------
# commands
# -----------------

.PHONY: help
help: Makefile
	@echo "Choose a command in:"
	@sed -n 's/^##//p' $< | column -t -s ':' |  sed -e 's/^/ /'

## build - собрать образ
.PHONY: build
build:
	@docker build -f ./Dockerfile -t $(DOCKER_IMG) .

## dev - контейнер для разработки. Запуск приложения внутри контейнера: `dev/run.sh`
.PHONY: dev
dev:
	@docker run --rm -it $(DETACH) \
		--name $(DOCKER_CONTAINER_NAME) \
		-w /app \
		-v $(PWD):/app:ro \
		-v afsc-fabric-crypto-db:$(MOUNT_DIR):rw \
		-e PRODUCTION=off \
		-e BCCSP_DEFAULT=PKCS11 \
		-e LOGS_DIR=/tmp \
		-e HSM_LIB=/usr/lib/softhsm/libsofthsm2.so \
		-e HSM_SLOT=afsc \
		-e HSM_PIN=RecnCbhtyb \
		-e SOFTHSM2_CONF=/app/cfg/softhsm.conf \
		"$(DOCKER_IMG)" bash -c "$(CMD)"
