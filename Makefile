.PHONY: clean image push all
image=miniflux/miniflux
ARCHS=amd64 arm32v6 arm64v8
VERSIONS=$(version) latest

clean:
	@$(foreach arch,$(ARCHS),docker image rm -f $(image):$(arch)-${version} $(image):$(arch)-latest ;)

image:
	@{ \
	set -e ;\
	for arch in $(ARCHS); do \
	  case $${arch} in \
		amd64   ) miniflux_arch="amd64";; \
		arm32v6 ) miniflux_arch="armv6";; \
		arm64v8 ) miniflux_arch="armv8";; \
	  esac ;\
	  cp Dockerfile.template Dockerfile.$${arch} ;\
	  sed -i "" "s|__BASEIMAGE_ARCH__|$${arch}|g" Dockerfile.$${arch} ;\
	  sed -i "" "s|__MINIFLUX_VERSION__|$${version}|g" Dockerfile.$${arch} ;\
	  sed -i "" "s|__MINIFLUX_ARCH__|$${miniflux_arch}|g" Dockerfile.$${arch} ;\
	done ;\
	}

	@$(foreach arch,$(ARCHS),docker build --no-cache --pull -q -f Dockerfile.$(arch) -t $(image):$(arch)-$(version) . ;)
	@$(foreach arch,$(ARCHS),docker tag $(image):$(arch)-${version} $(image):$(arch)-latest ;)

push:
	@$(foreach ver,$(VERSIONS),$(foreach arch,$(ARCHS),docker push $(image):$(arch)-$(ver);))
	@$(foreach ver,$(VERSIONS),docker manifest create $(image):$(ver) $(image):amd64-$(ver) $(image):arm32v6-$(ver) $(image):arm64v8-$(ver);)
	@$(foreach ver,$(VERSIONS),docker manifest annotate $(image):$(ver) $(image):arm32v6-$(ver) --os linux --arch arm --variant v6;)
	@$(foreach ver,$(VERSIONS),docker manifest annotate $(image):$(ver) $(image):arm64v8-$(ver) --os linux --arch arm64 --variant v8;)
	@$(foreach ver,$(VERSIONS),docker manifest push --purge $(image):$(ver);)

all:
	clean image push
