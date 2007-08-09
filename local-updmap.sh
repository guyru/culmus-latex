#!/bin/bash
#
# Locally update LaTeX/dvips/xdvi maps with culmus
# Currently devlopped for TeXlive/{Debian,Ubuntu}.
# Author:  Yotam Medini  yotam.medini@gmail.com -- Created: 2007/May/20
#

set -u

if [[ $# -ne 1 ]]
then
    echo Usage $0 '<destdir>' 1>&2 
    exit 1
fi
destdir=$(cd ${1}; /bin/pwd)

target=${destdir}/usr/share/texmf-texlive
fontdir=${target}/fonts
std_updmapdir=/etc/texmf/updmap.d
updmapdir=${destdir}${std_updmapdir}

export TEXMFCONFIG=${target}
export TEXMFVAR=${target}
texmfconfig=$(kpsewhich --expand-path '$TEXMFCONFIG')
echo texmfconfig=${texmfconfig}


# instead of the standard:  /var/lib/texmf/web2c/updmap.cfg
updmapcfg=${texmfconfig}/web2c/updmap.cfg
echo updmapcfg=${updmapcfg}
mkdir -p $(dirname ${updmapcfg})
(cd fontdir/map; mkdir -p dvipdfm/updmap dvipdfm/updmap pdftex/tex)


# Initialize updmapdir
mkdir -p ${updmapdir}
cat > ${updmapdir}/70culmus-latex.cfg <<EOF
# 70culmus-latex.cfg
# Some distribution (Debian) add magic comment to control updmap action.
#
Map culmus.map
EOF


set -x
tar -C /etc/texmf/updmap.d -c -f - . | tar -C ${updmapdir} -x -v -f -
cat ${updmapdir}/*.cfg > ${updmapcfg}
ls -l ${updmapcfg}

export WEB2C=${texmfconfig}/web2c
updmap
