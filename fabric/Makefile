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
		-e HSM_LIB=/usr/lib/softhsm/libsofthsm2.so \
		-e HSM_SLOT=afsc \
		-e HSM_PIN=RecnCbhtyb \
		-e SOFTHSM2_CONF=/app/cfg/softhsm.conf \
		"$(DOCKER_IMG)" bash -c "$(CMD)"

## start-ca - старт контейнера с серверами удостоверяющих центров на hldgappdev
.PHONY: start-ca
start-ca:
	@docker run --rm -it \
		--name $(DOCKER_CONTAINER_NAME) \
		--hostname fb-ca \
		-w /app \
		-v $(PWD):/app:ro \
		-v $(PWD)/fabca:/app/fabca:rw \
		-v $(PWD)/crypto:/app/crypto:rw \
		-v /etc/Chrystoki.conf:/etc/Chrystoki.conf:ro \
		-v /usr/safenet/lunaclient/cert:/usr/safenet/lunaclient/cert:ro \
		-v /usr/safenet/lunaclient/lib/libCryptoki2_64.so:/usr/lib/libCryptoki2_64.so:ro \
		-e HSM_LIB=/usr/lib/libCryptoki2_64.so \
		-e HSM_SLOT=afsc \
		-e HSM_PIN=RecnCbhtyb \
		"$(DOCKER_IMG)" bash -c 'bash start-ca.sh && bash'
