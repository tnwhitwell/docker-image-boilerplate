DOCKER_REPO=dockerhub_username/appimage
IMAGE_NAME=${DOCKER_REPO}:latest

build:
	IMAGE_NAME=${IMAGE_NAME} bash hooks/build

push:
	@docker push ${IMAGE_NAME}
	IMAGE_NAME=${IMAGE_NAME} DOCKER_REPO=${DOCKER_REPO} bash hooks/post_push
