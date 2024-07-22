
PREFIX = /usr/local
PREFIXBIN = $(PREFIX)/bin

all: install

install: $(PREFIXBIN)/miyka-md1

$(PREFIXBIN)/miyka-md1: src/md1/main.sh
	cp -T -- $^ "$@"
	chmod +x "$@"
