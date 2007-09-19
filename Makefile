# Determine TEXMFROOT value by the system
TEXLIVEDIR = /usr/share/texmf-texlive
TEXLIVE := $(shell if [ -d ${TEXLIVEDIR} ]; then echo 1; else echo 0; fi)
TEXMFROOT = /usr/share/texmf
ifeq ($(TEXLIVE),1)
  TEXMFROOT = $(TEXLIVEDIR)
endif


TEXMFDIR=$(DESTDIR)$(TEXMFROOT)

# Determine place of CULMUSDIR, try two options
ifeq ($(CULMUSDIR),)
  CULMUSDIR_OPT1 = /usr/share/fonts/hebrew
  CULMUSDIR_OPT2 = /usr/share/fonts/X11/Type1
  FCANDID = DavidCLM-Bold.afm
  FCANDID1 = $(CULMUSDIR_OPT1)/$(FCANDID)
  FCANDID2 = $(CULMUSDIR_OPT2)/$(FCANDID)
  CLM_FOUND := $(shell  if [ -f ${FCANDID1} ]; then echo 1; else echo 0; fi)
  ifeq ($(CLM_FOUND),1)
    CULMUSDIR = $(CULMUSDIR_OPT1)
  else
    CLM_FOUND := $(shell  if [ -f ${FCANDID2} ]; then echo 1; else echo 0; fi)
    ifeq ($(CLM_FOUND),1)
      CULMUSDIR = $(CULMUSDIR_OPT2)
    else
      $(error CULMUSDIR is undefined.)
    endif
  endif
endif

NIKUD_FDS = \
	he8franknikud.fd \
	he8miriamnikud.fd \
	he8nachlielinikud.fd

# Debug-hook to Echo Makefile Variable
ifneq ($(emv),)
emv:
	@echo $($(emv))
endif

all: tfms nikud-fds

tfms: tfms.DONE

nikud-fds: $(NIKUD_FDS)

he8%.fd: he8zzznikud.zfd Makefile
	nm=$$(echo $@ | sed -e 's/he8\(.*\)nikud.fd/\1/'); \
	   sed -e s/zzz/$${nm}/g < $< > $@
	@ls -l $@

tfms.DONE: Makefile ./mkCLMtfm.sh ./mkCLMnkd.sh
	./mkCLMtfm.sh $(CULMUSDIR)
	./mkCLMnkd.sh $(CULMUSDIR) culmus.map
	touch $@

install: pkginstall
	mktexlsr
	updmap-sys --enable Map=culmus.map

pkginstall: tfms
	mkdir -p $(TEXMFDIR)/dvips/culmus/ \
		$(TEXMFDIR)/fonts/afm/public/culmus/ \
		$(TEXMFDIR)/fonts/type1/public/culmus/ \
		$(TEXMFDIR)/fonts/enc/dvips/culmus/ \
		$(TEXMFDIR)/fonts/map/dvips/ \
		$(TEXMFDIR)/fonts/tfm/public/culmus/ \
		$(TEXMFDIR)/fonts/vf/public/culmus/ \
		$(TEXMFDIR)/tex/latex/culmus/ \
		$(TEXMFDIR)/tex/generic/0babel/
#this needs to be a 'cp' as 'ln -s' will cause the files not to be 
# found by tex under certain systems. We only move the neccessary files.
	cp -p $(CULMUSDIR)/*.afm $(TEXMFDIR)/fonts/afm/public/culmus/
	cp -p $(CULMUSDIR)/*.pfa $(TEXMFDIR)/fonts/type1/public/culmus/
	cp -p *.pfb $(TEXMFDIR)/fonts/type1/public/culmus/
	cp -p *.t3 $(TEXMFDIR)/fonts/type1/public/culmus/
	cp -p he8.enc $(TEXMFDIR)/fonts/enc/dvips/culmus/he8.enc
	cp -p culmus.map $(TEXMFDIR)/fonts/map/dvips/culmus.map
	cp -p *.tfm $(TEXMFDIR)/fonts/tfm/public/culmus/
	cp -p *.vf  $(TEXMFDIR)/fonts/vf/public/culmus/
	cp -p culmus.sty $(TEXMFDIR)/tex/latex/culmus/
	cp -p *.fd  $(TEXMFDIR)/tex/latex/culmus/
	cp -p hebrew.ldf $(TEXMFDIR)/tex/generic/0babel/
#	cp -p he8enc.def he8frank.fd he8nachlieli.fd $(TEXMFDIR)/tex/latex/culmus/

local-updmap:
	./local-updmap.sh ${DESTDIR}

clean:
	rm -f *.tfm *.vf *.vpl *.pfb *.t3 culmus.map tfms.DONE
	rm -rf tafm.d
	rm -f ${NIKUD_FDS}

uninstall:
#	this is just a partial uninstall as it't won't remove the folders that
#	were created during installation
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
