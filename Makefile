all: build

APP_NAME = "hello_dotnet"

RIDS = "linux-x64" "linux-arm64" "linux-musl-x64" "linux-musl-arm64" "osx-x64" "osx-arm64" "win-x64" "win-arm64"
# build:
# 	@echo "Building..."
# 	@dotnet build -c Release -p:PublishSingleFile=true --self-contained true -r linux-musl-arm64 -o bin/$(APP_NAME)-linux-musl-arm64

# dotnet publish -c Release -p:PublishSingleFile=true -p:SelfContained=true -p:PublishReadyToRun=true -p:PublishTrimmed=true -p:PublishAot=true -p:EnableCompressionInSingleFile=true -p:PublishAotCompressed=true -r $$rid -o bin/$(APP_NAME)-$$rid; \
		dotnet publish -c Release -p:PublishSingleFile=true -p:SelfContained=true -p:PublishReadyToRun=true -p:PublishTrimmed=true -p:StaticLink=true -r $$rid -o bin/$(APP_NAME)-$$rid; \

build: clean
	for rid in $(RIDS); do \
		echo "Building for $$rid..."; \
		dotnet publish -c Release -p:PublishSingleFile=true -p:SelfContained=true -p:PublishReadyToRun=true -p:PublishTrimmed=true -p:StaticLink=true -r $$rid -o bin/$(APP_NAME)-$$rid; \
	done

debug: clean
	@echo "Building in debug mode..."
	for rid in $(RIDS); do \
		echo "Building for $$rid..."; \
		dotnet publish -c Debug -p:PublishSingleFile=true -p:SelfContained=true -p:PublishReadyToRun=true-r $$rid -o bin/$(APP_NAME)-$$rid; \
	done

size:
	@echo "Size of the binaries:"
	for rid in $(RIDS); do \
		echo "Size of bin/$(APP_NAME)-$$rid:"; \
		ls -lh bin/$(APP_NAME)-$$rid/; \
	done

file:
	@echo "File type of the binaries:"
	for rid in $(RIDS); do \
		echo "File type of bin/$(APP_NAME)-$$rid:"; \
		file bin/$(APP_NAME)-$$rid/*; \
	done

clean:
	@echo "Cleaning..."
	@rm -rf bin
	@rm -rf obj

run:
	@echo "Running..."
	@orb -m alpine ./bin/$(APP_NAME)-linux-musl-arm64/$(APP_NAME)
	@orb -m alpamd ./bin/$(APP_NAME)-linux-musl-x64/$(APP_NAME)
	@orb -m debian ./bin/$(APP_NAME)-linux-arm64/$(APP_NAME)
	@orb -m debamd ./bin/$(APP_NAME)-linux-x64/$(APP_NAME)
	@./bin/$(APP_NAME)-osx-x64/$(APP_NAME)
	@./bin/$(APP_NAME)-osx-arm64/$(APP_NAME)
	@WINEDEBUG=-all wine ./bin/$(APP_NAME)-win-x64/$(APP_NAME).exe
	# # @/bin/$(APP_NAME)-win-arm64/$(APP_NAME).exe


# alpine needs gcc minimum, as currently building dynamic


# static build, requires dotnet 8
# dotnet publish -c Release -p:'PublishAot=true;StaticExecutable=true;' --self-contained -r linux-musl-arm64 -o bin/foo
# https://github.com/dotnet/sdk/issues/37643
# https://github.com/dotnet/runtime/blob/main/src/coreclr/nativeaot/docs/compiling.md#using-statically-linked-icu
# bin/foo/hello_dotnet: ELF 64-bit LSB pie executable, ARM aarch64, version 1 (SYSV), static-pie linked, BuildID[sha1]=ae7f5d30d4964fc426e8a03534f36356ceb45d3f, stripped