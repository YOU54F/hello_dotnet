all: build

APP_NAME = "hello_dotnet"

RIDS = "linux-x64" "linux-arm64" "linux-musl-x64" "linux-musl-arm64" "osx-x64" "osx-arm64" "win-x64" "win-arm64"
# build:
# 	@echo "Building..."
# 	@dotnet build -c Release -p:PublishSingleFile=true --self-contained true -r linux-musl-arm64 -o bin/linux-musl-arm64

# dotnet publish -c Release -p:PublishSingleFile=true -p:SelfContained=true -p:PublishReadyToRun=true -p:PublishTrimmed=true -p:PublishAot=true -p:EnableCompressionInSingleFile=true -p:PublishAotCompressed=true -r $$rid -o bin/$$rid; \
		dotnet publish -c Release -p:PublishSingleFile=true -p:SelfContained=true -p:PublishReadyToRun=true -p:PublishTrimmed=true -p:StaticLink=true -r $$rid -o bin/$$rid; \

build: clean
	for rid in $(RIDS); do \
		echo "Building for $$rid..."; \
		dotnet publish -c Release -p:'StaticExecutable=true;StripSymbols=false;PublishSingleFile=true;PublishTrimmed=true;StaticLink=true' --self-contained -r $$rid -o bin/$$rid; \
	done

debug: clean
	@echo "Building in debug mode..."
	for rid in $(RIDS); do \
		echo "Building for $$rid..."; \
		dotnet publish -c Debug -p:PublishSingleFile=true -p:SelfContained=true -p:PublishReadyToRun=true-r $$rid -o bin/$$rid; \
	done

size:
	@echo "Size of the binaries:"
	for rid in $(RIDS); do \
		echo "Size of bin/$$rid:"; \
		du -sh bin/$$rid/*; \
	done

file:
	@echo "File type of the binaries:"
	for rid in $(RIDS); do \
		echo "File type of bin/$$rid:"; \
		file bin/$$rid/*; \
	done

clean:
	@echo "Cleaning..."
	@rm -rf bin
	@rm -rf obj

run:
	@echo "Running..."
	@orb -m alpine ./bin/linux-musl-arm64/$(APP_NAME)
	@orb -m alpamd ./bin/linux-musl-x64/$(APP_NAME)
	@orb -m debian ./bin/linux-arm64/$(APP_NAME)
	@orb -m debamd ./bin/linux-x64/$(APP_NAME)
	@./bin/osx-x64/$(APP_NAME)
	@./bin/osx-arm64/$(APP_NAME)
	@WINEDEBUG=-all wine ./bin/win-x64/$(APP_NAME).exe
	# # @/bin/win-arm64/$(APP_NAME).exe

docker_build_linux_musl_arm64:
	docker run --platform=linux/arm64 --rm -v $(PWD):/app -w /app alpine /bin/sh -c \
	'apk add dotnet8-sdk --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community && \
	apk add gcc musl-dev zlib-static && \
	apk add file make && \
	dotnet publish -c Release -p:"PublishAot=true;StaticExecutable=true;StaticLink=true;SelfContained=true" -r linux-musl-arm64 -o bin/linux-musl-arm64 && \
	file bin/linux-musl-arm64/hello_dotnet && \
	du -sh bin/linux-musl-arm64/hello_dotnet && \
	ldd bin/linux-musl-arm64/hello_dotnet && \
	./bin/linux-musl-arm64/hello_dotnet'
docker_build_linux_musl_x64:
	docker run --platform=linux/amd64 --rm -v $(PWD):/app -w /app alpine /bin/sh -c \
	'apk add dotnet8-sdk --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community && \
	apk add gcc musl-dev zlib-static && \
	apk add file make && \
	dotnet publish -c Release -p:"PublishAot=true;StaticExecutable=true;StaticLink=true;SelfContained=true" -r linux-musl-x64 -o bin/linux-musl-x64 && \
	file bin/linux-musl-x64/hello_dotnet && \
	du -sh bin/linux-musl-x64/hello_dotnet && \
	ldd bin/linux-musl-x64/hello_dotnet && \
	./bin/linux-musl-x64/hello_dotnet'

# alpine needs gcc minimum, as currently building dynamic
# static build, requires dotnet 8
# dotnet publish -c Release -p:'PublishAot=true;StaticExecutable=true;' --self-contained -r linux-musl-arm64 -o bin/foo
# https://github.com/dotnet/sdk/issues/37643
# https://github.com/dotnet/runtime/blob/main/src/coreclr/nativeaot/docs/compiling.md#using-statically-linked-icu
# bin/foo/hello_dotnet: ELF 64-bit LSB pie executable, ARM aarch64, version 1 (SYSV), static-pie linked, BuildID[sha1]=ae7f5d30d4964fc426e8a03534f36356ceb45d3f, stripped