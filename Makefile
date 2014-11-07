all: ios 

clean:
	-rm -rf build_ios/
	-rm -rf build_ios_ninja/
	-rm -rf build_mac/
	-rm -rf build_mac_ninja/
	-rm -rf obj/
	-rm gyptest

gyp: ./deps/gyp

./deps/gyp:
	git clone --depth 1 https://chromium.googlesource.com/external/gyp.git ./deps/gyp

# instruct gyp to build using the "xcode" build generator, also specify the OS
# (so we can conditionally compile using that var later)
build_ios/gyptest.xcodeproj: deps/gyp gyptest.gyp
	deps/gyp/gyp gyptest.gyp -DOS=ios --depth=. -f xcode --generator-output=./build_ios -Icommon.gypi

build_mac/gyptest.xcodeproj: deps/gyp gyptest.gyp
	deps/gyp/gyp gyptest.gyp -DOS=mac --depth=. -f xcode --generator-output=./build_mac -Icommon.gypi

build_mac_ninja/out: deps/gyp gyptest.gyp
	deps/gyp/gyp gyptest.gyp -DOS=mac --depth=. -f ninja --generator-output=./build_mac_ninja -Icommon.gypi


xb-prettifier := $(shell command -v xcpretty >/dev/null 2>&1 && echo "xcpretty -c" || echo "cat")

ios: build_ios/gyptest.xcodeproj
	xcodebuild -project build_ios/gyptest.xcodeproj -configuration Release -target gyptest | ${xb-prettifier}

mac: build_mac/gyptest.xcodeproj 
	xcodebuild -project build_mac/gyptest.xcodeproj -configuration Release -target gyptest | ${xb-prettifier}

macninja: build_mac_ninja/out
	ninja -j 4 -C build_mac_ninja/out/Release/

all: mac
