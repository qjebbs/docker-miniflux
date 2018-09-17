Docker Image For Miniflux
=========================

The Docker image is available for multiple architectures: `arm64`, `arm32v6`, and `arm64v8`

- Build the image locally: `make image version=2.0.11`
- Change the name of the image: `make image image=your-username/miniflux version=2.0.11`
- Push images to a registry: `make push image=your-username/miniflux version=2.0.11`
- Purge images: `make clean image=your-username/miniflux version=2.0.11`
