.PHONY: image push all

image:
	@ docker build -t miniflux/miniflux:${version} .

push:
	@ docker push miniflux/miniflux:${version}
	@ docker tag miniflux/miniflux:${version} miniflux/miniflux:latest
	@ docker push miniflux/miniflux:latest

all:
	image push
