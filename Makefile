
PREFIX = /usr/local
PREFIXBIN = /usr/local/bin

all: install

install: $(PREFIXBIN)/miyka-md1

$(PREFIXBIN)/miyka-md1: src/md1/main.sh
	cp -T -- $^ "$@"
	chmod +x "$@"
