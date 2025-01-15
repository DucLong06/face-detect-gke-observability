# Jenkins Docker Image with Docker, Kubectl and Helm

## 🛠 Installation

### Option 1: Using Docker Run

```bash
docker run -d \
  --name jenkins \
  -p 8080:8080 \
  -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  -v /var/run/docker.sock:/var/run/docker.sock \
  --restart unless-stopped \
  your-dockerhub-username/jenkins-docker-helm:latest
```

### Option 2: Using Docker Compose

1. Create a `docker-compose.yml` file:

```yaml
version: '3.8'
services:
  jenkins:
    build: .
    container_name: jenkins-docker-helm
    ports:
      - "8080:8080"
      - "50000:50000"
    volumes:
      - jenkins_home:/var/jenkins_home
      - /var/run/docker.sock:/var/run/docker.sock
    restart: unless-stopped

volumes:
  jenkins_home:
```

2. Start Jenkins:
```bash
docker compose up --build -d
```

## 🔨 Building Custom Image

1. Update the `IMAGE_NAME` in [`build_and_push_image_jenkins.sh`](https://github.com/DucLong06/face-detection-ml-system/blob/38c517b0861ed4b0ed3960e63dd036e3dcbe617b/scripts/build_and_push_image_jenkins.sh#L8-L9) with your DockerHub username:
```bash
# In build.sh
IMAGE_NAME="longhd06/jenkins-docker-helm"
IMAGE_TAG="latest"
```

1. Make the build script executable and run it:
```bash
chmod +x scripts/build_and_push_image_jenkins.sh
./scripts/build_and_push_image_jenkins.sh
```