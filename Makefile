all: images

image-pr-helper: image-seitan
	docker build --no-cache -t pr-helper -f dockerfiles/pr-helper/Dockerfile .

image-qemu: image-seitan image-disk
	docker build -t qemu -f dockerfiles/qemu/Dockerfile .

image-seitan:
	docker build -t seitan dockerfiles/seitan

image-disk:
	docker build --network host -t disk dockerfiles/create-disk

images: image-pr-helper image-qemu
