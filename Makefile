.PHONY: all build test run clean

BUILD_DIR = .build
MODULE_DIR = $(BUILD_DIR)/modules
SWIFTC = xcrun swiftc -module-cache-path $(BUILD_DIR)/clang-module-cache

all: build

$(MODULE_DIR):
	mkdir -p $(MODULE_DIR)

build-core: $(MODULE_DIR)
	$(SWIFTC) -emit-module -emit-library -module-name CowsAndBullsCore Sources/CowsAndBullsCore/*.swift -o $(MODULE_DIR)/libCowsAndBullsCore.dylib

build: build-core
	$(SWIFTC) -I $(MODULE_DIR) -L $(MODULE_DIR) -lCowsAndBullsCore -Xlinker -rpath -Xlinker @executable_path/$(MODULE_DIR) Sources/CowsAndBullsCLI/*.swift -o cows-and-bulls

test: build-core
	$(SWIFTC) -I $(MODULE_DIR) -L $(MODULE_DIR) -lCowsAndBullsCore -Xlinker -rpath -Xlinker @executable_path/$(MODULE_DIR) Tests/CowsAndBullsCoreTests/TestRunner.swift -o $(BUILD_DIR)/test_runner
	./$(BUILD_DIR)/test_runner

run: build
	./cows-and-bulls

clean:
	rm -rf $(BUILD_DIR) cows-and-bulls
