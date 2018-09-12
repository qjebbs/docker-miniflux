.PHONY: image push all
ARCHS=amd64 arm32v6 arm64v8
VERSIONS=$(version) latest

image:
	@{ \
	set -e ;\
	for arch in $(ARCHS); do \
	  case $${arch} in \
		amd64   ) miniflux_arch="amd64";; \
		arm32v6 ) miniflux_arch="armv6";; \
		arm64v8 ) miniflux_arch="armv8";; \
	  esac ;\
	  cp Dockerfile.cross Dockerfile.$${arch} ;\
	  sed -i "" "s|__BASEIMAGE_ARCH__|$${arch}|g" Dockerfile.$${arch} ;\
	  sed -i "" "s|__MINIFLUX_VERSION__|$${version}|g" Dockerfile.$${arch} ;\
	  sed -i "" "s|__MINIFLUX_ARCH__|$${miniflux_arch}|g" Dockerfile.$${arch} ;\
	done ;\
	}

	@$(foreach arch,$(ARCHS),docker build -q -f Dockerfile.$(arch) -t miniflux/miniflux:$(arch)-$(version) . ;)
	@$(foreach arch,$(ARCHS),docker tag miniflux/miniflux:$(arch)-${version} miniflux/miniflux:$(arch)-latest ;)

push:
	@$(foreach ver,$(VERSIONS),$(foreach arch,$(ARCHS),docker push miniflux/miniflux:$(arch)-$(ver);))
	@$(foreach ver,$(VERSIONS),docker manifest create miniflux/miniflux:$(ver) miniflux/miniflux:amd64-$(ver) miniflux/miniflux:arm32v6-$(ver) miniflux/miniflux:arm64v8-$(ver);)
	@$(foreach ver,$(VERSIONS),docker manifest annotate miniflux/miniflux:$(ver) miniflux/miniflux:arm32v6-$(ver) --os linux --arch arm;)
	@$(foreach ver,$(VERSIONS),docker manifest annotate miniflux/miniflux:$(ver) miniflux/miniflux:arm64v8-$(ver) --os linux --arch arm64 --variant armv8;)
	@$(foreach ver,$(VERSIONS),docker manifest push --purge miniflux/miniflux:$(ver);)

all:
	image push
