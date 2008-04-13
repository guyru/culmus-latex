# Determine TEXMFROOT value by the system
TEXLIVEDIR = /usr/share/texmf-texlive
TEXLIVE := $(shell if [ -d ${TEXLIVEDIR} ]; then echo 1; else echo 0; fi)
TEXMFROOT = /usr/share/texmf
ifeq ($(TEXLIVE),1)
  TEXMFROOT = $(TEXLIVEDIR)
endif


TEXMFDIR=$(DESTDIR)$(TEXMFROOT)

install: pkginstall
	mktexlsr
	updmap-sys --enable Map=culmus.map

pkginstall:
	cp -vR usr/share/texmf/* ${TEXMFDIR}
	touch $@.DONE

uninstall:
	rm -rf $(TEXMFDIR)/fonts/afm/public/culmus
	rm -rf $(TEXMFDIR)/fonts/type1/public/culmus
	rm $(TEXMFDIR)/fonts/enc/dvips/culmus/he8.enc
	rm $(TEXMFDIR)/fonts/map/dvips/culmus.map
	rm $(TEXMFDIR)/fonts/tfm/public/culmus/*.tfm
	rm $(TEXMFDIR)/fonts/vf/public/culmus/*.vf
	rm $(TEXMFDIR)/tex/latex/culmus/culmus.sty
	(cd $(TEXMFDIR)/tex/latex/culmus; \
	    rm -f $(NIKUD_FDS))
	rm $(TEXMFDIR)/tex/generic/0babel/hebrew.ldf

	mktexlsr
	updmap-sys --disable culmus.map
