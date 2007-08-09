#!/bin/bash
# Inspired by http://nikud.berlios.de/

set -u # We do not accept undefined

rc=0
culmusdir=${1}
psmap=${2}

# map major name
psnam2texnamMajor() {
   pair=$(grep ${1}: <<EOF
FrankRuehlCLM:frankClmNkd
MiriamMonoCLM:miriamClmNkd
NachlieliCLM:nachlieliClmNkd
EOF
)
   v=$(echo ${pair} | cut -d: -f2)
   echo ${v}
   return 0
}

# map variant name
psnam2texnamVariant() {
   pair=$(grep ${1}: <<EOF
Bold:b
BoldOblique:bi
BookOblique:i
Light:
LightOblique:i
Medium:
MediumOblique:i
EOF
)
   v=$(echo ${pair} | cut -d: -f2)
   echo ${v}
   return 0
}

# Map from PostScript name to TeX name.
psnam2texnam() {
   ps1=$(echo ${1} | cut -d- -f1)
   ps2=$(echo ${1} | cut -d- -f2)
   tnm1=$(psnam2texnamMajor ${ps1})
   tnm2=$(psnam2texnamVariant ${ps2})
   echo ${tnm1}${tnm2}
   return 0
}


syscmd() {
    echo $@
    $@
    local rc=$?
    if [[ ${rc} -ne 0 ]]
    then
       ${1} Failed rc=${rc}
    fi
    return ${rc}
}


clm2t3=./nikud/culmusafm2t3menukad.pl
mkdir -p tafm.d
for psname in \
    FrankRuehlCLM-Bold \
    FrankRuehlCLM-BoldOblique \
    FrankRuehlCLM-Medium \
    FrankRuehlCLM-MediumOblique \
    MiriamMonoCLM-Bold \
    MiriamMonoCLM-BoldOblique \
    MiriamMonoCLM-Book \
    MiriamMonoCLM-BookOblique \
    NachlieliCLM-Bold \
    NachlieliCLM-BoldOblique \
    NachlieliCLM-Light \
    NachlieliCLM-LightOblique
do
    texnm=$(psnam2texnam ${psname})
    nkdname=${psname}-Menukad
    t3name=${nkdname}.t3
    echo psname=${psname} texnm=${texnm}
    afm=${culmusdir}/${psname}.afm
    tafm=tafm.d/${psname}.afm
    syscmd ${clm2t3} ${afm} -s nikud/${psname}.special -o ${t3name}
    rc1=$?
    syscmd ./nikud/zero_nikud_width.pl ${afm} ${tafm}
    rc2=$?
    syscmd afm2tfm ${tafm} -T he8.enc -v ${texnm}.vpl r${texnm}.tfm
    rc3=$?
    syscmd vptovf ${texnm}.vpl ${texnm}.vf ${texnm}.tfm
    rc4=$?
    syscmd t1binary ${culmusdir}/${psname}.pfa ${psname}.pfb
    rc5=$?
    if [[ ${rc1} -ne 0 || ${rc2} -ne 0 || ${rc3} -ne 0 || ${rc4} -ne 0 ]]
    then
        echo some command fail \
             rcs=${rc1},${rc2},${rc3},${rc4},${rc5} for ${psname}
	rc=1
    fi
    ls -l ${afm} ${tafm} ${t3name} ${psname}.pfb \
       ${texnm}.vpl ${texnm}.vf r${texnm}.tfm ${texnm}.tfm 
    names="${texnm} ${nkdname} \"HE8Encoding ReEncodeFont\""
    lts="<he8.enc <<${t3name} <${psname}.pfb"
    psmapline="${names} ${lts}"
    echo ${psmapline} >> ${psmap}
    echo r${psmapline} >> ${psmap}
done

exit ${rc}
