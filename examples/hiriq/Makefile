# Author:  Yotam Medini  yotam@il.ibm.com -- Created: 2007/April/09

# Hook to Echo Makefile Variable
ifneq ($(emv),)
emv:
	@echo $($(emv))
endif

.DELETE_ON_ERROR:

# DESTDIR is as used by ../../Makefile pkginstall target
ifneq ($(DESTDIR),)

  $(info Setting some TeX related environment variables by given DESTDIR)

  # Determine TEXMFROOT value by the system
  TEXLIVEDIR = /usr/share/texmf-texlive
  TEXLIVE := $(shell if [ -d ${TEXLIVEDIR} ]; then echo 1; else echo 0; fi)
  TEXMFROOT = /usr/share/texmf
  ifeq ($(TEXLIVE),1)
    TEXMFROOT = $(TEXLIVEDIR)
  endif
  DTEXMFROOT = $(DESTDIR)$(TEXMFROOT)
  $(info DTEXMFROOT=$(DTEXMFROOT))

  # destdir := $(shell cd ../../destdir; /bin/pwd)
  # target = $(destdir)/usr/share/texmf-texlive
  fontdir=${DTEXMFROOT}/fonts
  export TEXMFCONFIG=${DTEXMFROOT}
  export TFMFONTS=${fontdir}/tfm//:
  export TEXINPUTS=${DTEXMFROOT}/babel:
  export DVIPSFONTS=${fontdir}//:
  export DVIPSMAKEPK=false
  export XDVIINPUTS=/home/yotam/personal/culmus-tex/run/my-xdvicfg:${fontdir}//:
  # export XDVIINPUTS=${fontdir}//:
  export T1FONTS=${fontdir}/type1//:
endif

all: hiriq.ps

%.dvi: %.tex
	latex -interaction=errorstopmode -no-mktex tfm $< < /dev/null

PAPER = a4
%.ps: %.dvi
	dvips $(DVIPS_EXTRA) -M* -t $(PAPER) -o $@ $<

%.xdvi: %.dvi
	xdvi $<

clean:
	rm -f $(ALL) *.log *.aux *.dvi *.ps

showenv:
	env | grep ${DTEXMFROOT}
