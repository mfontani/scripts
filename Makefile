NOT_PREREQS := Makefile LICENSE README.md
PREREQS := $(filter-out $(NOT_PREREQS),$(wildcard *))

.PHONY: all
all: $(PREREQS) Makefile
	./.licensify.sh
	./.readmeify.sh
