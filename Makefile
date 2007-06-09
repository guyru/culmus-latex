TEXMFDIR=/usr/share/texmf
CULMUSDIR=/usr/share/fonts/hebrew

tfms:
	./mkCLMtfm.sh $(CULMUSDIR)

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
	
	cp -p he8.enc $(TEXMFDIR)/fonts/enc/dvips/culmus/he8.enc
	cp -p culmus.map $(TEXMFDIR)/fonts/map/dvips/culmus.map
	cp -p *.tfm $(TEXMFDIR)/fonts/tfm/public/culmus/
	cp -p *.vf  $(TEXMFDIR)/fonts/vf/public/culmus/
	cp -p culmus.sty $(TEXMFDIR)/tex/latex/culmus/
	cp -p hebrew.ldf $(TEXMFDIR)/tex/generic/0babel/
#	cp -p he8enc.def he8frank.fd he8nachlieli.fd $(TEXMFDIR)/tex/latex/culmus/

clean:
	rm *.tfm *.vf *.vpl culmus.map

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
	rm $(TEXMFDIR)/tex/generic/0babel/hebrew.ldf

	mktexlsr
	updmap-sys --disable culmus.map
