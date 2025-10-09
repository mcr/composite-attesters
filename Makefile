DIAGRAMS=
DIAGRAMS+=diagrams/class0.txt
DIAGRAMS+=diagrams/class1.txt
DIAGRAMS+=diagrams/class2.txt
DIAGRAMS+=diagrams/class3B.txt
DIAGRAMS+=diagrams/class3P.txt
LIBDIR := lib
include $(LIBDIR)/main.mk

$(LIBDIR)/main.mk:
ifneq (,$(shell grep "path *= *$(LIBDIR)" .gitmodules 2>/dev/null))
	git submodule sync
	git submodule update --init
else
ifneq (,$(wildcard $(ID_TEMPLATE_HOME)))
	ln -s "$(ID_TEMPLATE_HOME)" $(LIBDIR)
else
	git clone -q --depth 10 -b main \
	    https://github.com/martinthomson/i-d-template $(LIBDIR)
endif
endif

draft-richardson-rats-composite-attesters.md: ${DIAGRAMS}

%.txt: %.asciio
	asciio_to_text $*.asciio >$@


