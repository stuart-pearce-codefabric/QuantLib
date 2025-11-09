#!/bin/bash
# Optimized build script for QuantLib
# This script configures and builds QuantLib with maximum performance optimizations

set -e

# Detect number of CPU cores
if [ -f /proc/cpuinfo ]; then
    JOBS=$(nproc)
elif command -v sysctl &> /dev/null; then
    JOBS=$(sysctl -n hw.ncpu)
else
    JOBS=4
fi

echo "Building with ${JOBS} parallel jobs"

# Create build directory
BUILD_DIR="build-release-optimized"
mkdir -p "${BUILD_DIR}"
cd "${BUILD_DIR}"

# Configure with CMake using Ninja generator for maximum performance
cmake .. \
    -G Ninja \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_CXX_STANDARD=17 \
    -DCMAKE_UNITY_BUILD=ON \
    -DCMAKE_INTERPROCEDURAL_OPTIMIZATION=ON \
    -DQL_ENABLE_OPENMP=ON \
    -DQL_USE_STD_CLASSES=ON \
    -DQL_FASTER_LAZY_OBJECTS=ON \
    -DBUILD_SHARED_LIBS=ON

echo ""
echo "Configuration complete. Building..."
echo ""

# Build with Ninja (automatically uses all cores efficiently)
ninja -j "${JOBS}"

echo ""
echo "Build complete! Library is in: ${BUILD_DIR}/ql"
echo ""
echo "To run tests: ninja test"
echo "To install: sudo ninja install"
