.PHONY: test lint build-rootfs configure package smoke clean

profile ?= profiles/diag-appliance.yaml
rootfs ?= build/rootfs
image ?= build/aegis-diagos.img

lint:
	python3 -m unittest discover -s tests -v
	@command -v shellcheck >/dev/null 2>&1 && shellcheck scripts/*.sh overlay/usr/local/bin/distro-diag || echo "shellcheck not installed (optional)"

test:
	python3 -m unittest discover -s tests -v

build-rootfs:
	./scripts/build-rootfs.sh --profile "$(profile)" --rootfs "$(rootfs)"

configure:
	./scripts/configure-system.sh --rootfs "$(rootfs)"

package:
	./scripts/package-image.sh --profile "$(profile)" --rootfs "$(rootfs)" --image "$(image)"

smoke:
	./scripts/smoke-test-vm.sh --image "$(image)"

clean:
	rm -rf build
