Docker Image For Miniflux
=========================

Available architectures: `amd64`, `arm32v6`, and `arm64v8`

- Build the image locally: `make image version=2.0.12`
- Change the name of the image: `make image image=your-username/miniflux version=2.0.12`
- Push images to a registry: `make push image=your-username/miniflux version=2.0.12`
- Purge images: `make clean image=your-username/miniflux version=2.0.12`
