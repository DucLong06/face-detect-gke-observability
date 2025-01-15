#!/bin/bash

# Set base directory
BASE_DIR=$(dirname "$(dirname "$(realpath "$0")")")
JENKINS_DIR="${BASE_DIR}/custom_images/jenkins"

# Configuration
IMAGE_NAME="longhd06/jenkins-docker-helm"
IMAGE_TAG="latest"

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print status messages
print_status() {
    echo -e "${GREEN}[*] $1${NC}"
}

print_error() {
    echo -e "${RED}[!] $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}[!] $1${NC}"
}

# Check if required directories exist
if [ ! -d "${JENKINS_DIR}" ]; then
    print_error "Jenkins directory not found at: ${JENKINS_DIR}"
    exit 1
fi

# Check if Dockerfile exists
if [ ! -f "${JENKINS_DIR}/Dockerfile" ]; then
    print_error "Dockerfile not found in: ${JENKINS_DIR}"
    exit 1
fi

# Check if docker is installed
if ! command -v docker &> /dev/null; then
    print_error "Docker is not installed. Please install Docker first."
    exit 1
fi

# Navigate to Jenkins directory
cd "${JENKINS_DIR}" || exit 1

# Build the Docker image
print_status "Building Docker image: $IMAGE_NAME:$IMAGE_TAG"
if ! docker build --platform linux/amd64 -t $IMAGE_NAME:$IMAGE_TAG .; then
    print_error "Failed to build Docker image"
    exit 1
fi
print_status "Docker image built successfully"

# Check if user is logged into DockerHub
print_status "Checking DockerHub authentication"
if ! docker info | grep -q "Username"; then
    print_error "Please log in to DockerHub first using 'docker login'"
    exit 1
fi

# Push the image to DockerHub
print_status "Pushing image to DockerHub: $IMAGE_NAME:$IMAGE_TAG"
if ! docker push $IMAGE_NAME:$IMAGE_TAG; then
    print_error "Failed to push image to DockerHub"
    exit 1
fi

print_status "Image successfully pushed to DockerHub"
print_status "You can now pull the image using: docker pull $IMAGE_NAME:$IMAGE_TAG"

# Optional: Clean up local image
if [ "$1" == "--cleanup" ]; then
    print_warning "Cleaning up local image..."
    docker rmi $IMAGE_NAME:$IMAGE_TAG
fi