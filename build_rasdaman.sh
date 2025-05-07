#!/bin/bash

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "Docker is not installed. Please install Docker first."
    exit 1
fi

# Create a temporary directory for building
BUILD_DIR=$(mktemp -d)
cd $BUILD_DIR

# Clone the Rasdaman repository
echo "Cloning Rasdaman repository..."
if ! git clone https://github.com/rasdaman/rasdaman-community.git; then
    echo "Failed to clone Rasdaman repository"
    rm -rf $BUILD_DIR
    exit 1
fi

cd rasdaman-community

# Build the Docker images
echo "Building Rasdaman Docker images..."
if ! docker build -t rasdaman/rasdaman:latest -f docker/rasdaman/Dockerfile .; then
    echo "Failed to build Rasdaman image"
    cd -
    rm -rf $BUILD_DIR
    exit 1
fi

if ! docker build -t rasdaman/petascope:latest -f docker/petascope/Dockerfile .; then
    echo "Failed to build Petascope image"
    cd -
    rm -rf $BUILD_DIR
    exit 1
fi

# Clean up
cd -
rm -rf $BUILD_DIR

echo "Rasdaman Docker images have been built successfully!" 