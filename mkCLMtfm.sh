#!/bin/bash

# Inspired by Yotam Medini http://www.medini.org/hebrew/

culmusdir=$1

name=(
aharonib	AharoniCLM-Bold
aharonibi	AharoniCLM-BoldOblique
aharoni		AharoniCLM-Book
aharonii	AharoniCLM-BookOblique
caladings	CaladingsCLM
davidb		DavidCLM-Bold
david		DavidCLM-Medium
davidi		DavidCLM-MediumItalic
drugulinb	DrugulinCLM-Bold
drugulinbi	DrugulinCLM-BoldItalic
elliniab	ElliniaCLM-Bold
elliniabi	ElliniaCLM-BoldItalic
ellinia		ElliniaCLM-Light
elliniai	ElliniaCLM-LightItalic
frankb		FrankRuehlCLM-Bold
frankbi		FrankRuehlCLM-BoldOblique
frank		FrankRuehlCLM-Medium
franki		FrankRuehlCLM-MediumOblique
#yadbi		KtavYadCLM-BoldItalic
#yadi		KtavYadCLM-MediumItalic
miriamb		MiriamMonoCLM-Bold
miriambi	MiriamMonoCLM-BoldOblique
miriam		MiriamMonoCLM-Book
miriami		MiriamMonoCLM-BookOblique
nachlielib	NachlieliCLM-Bold
nachlielibi	NachlieliCLM-BoldOblique
nachlieli	NachlieliCLM-Light
nachlielii	NachlieliCLM-LightOblique
yehuda		YehudaCLM-Light
yehudab		YehudaCLM-Bold
)

cp /dev/null culmus.map
for (( i=0 ; $i<${#name[@]} ; i=$i+2));
do
  texname=${name[$i]}
  t1name=${name[$i+1]}
  afm2tfm $culmusdir/$t1name.afm -T he8.enc $texname.tfm >/dev/null
  afm2tfm $culmusdir/$t1name.afm -T he8.enc -V $texname.vpl r$texname.tfm
  vptovf $texname.vpl $texname.vf $texname.tfm 
  vptovf $texname.vpl $texname.vf r$texname.tfm
  echo "$texname $t1name \"HE8Encoding ReEncodeFont\" <he8.enc <$t1name.pfa" >> culmus.map
  echo "r$texname $t1name \"HE8Encoding ReEncodeFont\" <he8.enc <$t1name.pfa"  >> culmus.map
done;

