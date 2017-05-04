#xset b off
if [[ $- != *i* ]]; then
    return;
fi

export EDITOR="emacs -nw -q"
# export EDITOR="emacsclient t"

# Adding to PATH
PATH=$PATH:$HOME/scripts/sh:$HOME/scripts/py

export CVSROOT=:gserver:cmscvs.cern.ch:/cvs_server/repositories/CMSSW
export CVS_RSH=ssh

# PDFLATEX
export PATH=/nfs-7/texlive/2015/bin/x86_64-linux:$PATH

# CMS
export CMS_PATH=/code/osgcode/cmssoft/cms

# CMSSW
source /code/osgcode/cmssoft/cmsset_default.sh > /dev/null
export SCRAM_ARCH=slc6_amd64_gcc491
# source /nfs-7/cmssoft/cms.cern.ch/cmssw/cmsset_default.sh

# Crab
# source /code/osgcode/ucsdt2/Crab/etc/crab.sh
alias scrab='source /cvmfs/cms.cern.ch/crab3/crab.sh'
export GLITE_VERSION="gLite-3.2.11-1"
export LCG_GFAL_INFOSYS=lcg-bdii.cern.ch:2170
export GLOBUS_TCP_PORT_RANGE=20000,25000

alias evscr='eval `scramv1 runtime -sh`'

# Apperance
export TERM=xterm-256color
alias grep='grep --color=auto'
alias g++='g++ --std=c++14'

# User aliases
alias shrc='. ~/.bashrc'
alias ls='ls --color=auto'
alias lt='ls -l -t -r -h -G'
alias le='ls -ltrhG --ignore=*.{o,d,aux,pcm,so,nav,snm,pyc,toc,out}'
alias la='ls -l -t -r -a -h'
alias lta='ls -l -t -r -a -h -G'
alias lse='ls -l -t -r -h -G --sort=extension'
alias lc='cl'
alias cpi='cp -ri'
alias root='root -l'
alias req='root -l -q'
alias rbq='root -l -b -q'
alias rot='root -l -b -q'
alias emac='~/play/emacs-25.1/src/emacs &'
alias emsvr='~/play/emacs-25.1/src/emacs --daemon'
alias emc='~/play/emacs-25.1/lib-src/emacsclient -t'
alias enw='~/play/emacs-25.1/src/emacs -q -nw'
alias ei='em'
alias py='python'
alias dui='du -hc --max-depth=1'
alias gst='git st'
alias gad='git add'
alias gcm='git cm'
alias gca='git ca'
alias gam='git cam'
# alias gdf='git diff'
alias gco='git co'
alias gsh='git sh'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ..4='cd ../../../..'
alias ..5='cd ../../../../..'
alias ..6='cd ../../../../../..'
alias c..='cl ..'
alias c...='cl ../..'

export HDP=/hadoop/cms/store/user/$USER
export GHDP=/hadoop/cms/store/group/snt
export PYTHONPATH=~/tas/Software/:$PYTHONPATH
export PYTHONPATH=~/tas/Software/pyRootPlotMaker/:$PYTHONPATH
export CMSSW_HEADER_FILES=/cvmfs/cms.cern.ch/slc6_amd64_gcc530/cms/cmssw/CMSSW_8_0_26/src/

# Fast calls and cds
alias mg='~/Generator/MG5_aMC_v2_3_2/bin/mg5_aMC'
alias cweb='cl ~/public_html/'
alias cdmp='cl ~/public_html/dump'
alias chdp='cd $HDP'
alias cghdp='cd $GHDP/run2_25ns'
alias cnfs='cd /nfs-6/userdata/mt2'
alias cnfs7='cd /nfs-7/userdata/'

# Functional aliases
# -- general  --
gdf() {
    local fn=$1
    if [ ! -f $1 ]; then
        if [ "${fn: -1}" != "." ]; then fn="${fn}."; fi
        if [ -f "${fn}sh" ]; then
            fn="${fn}sh"
        elif [ -f "${fn}cc" ]; then
            fn="${fn}cc"
        elif [ -f "${fn}C" ]; then
            fn="${fn}C"
        elif [ -f "${fn}py" ]; then
            fn="${fn}py"
        else
            echo "Fail to append the extenstion?"
        fi
        echo "The filename is automatically corrected to $fn !"
    fi
    if [[ $2 == "add" ]]; then
        git add $fn
    elif [[ $2 == "co" ]]; then
        git checkout $fn
    elif [[ $# == 1 ]]; then
        git diff $fn
    else
        git diff $@
        # git diff $1 | ~/scripts/sh/diff-so-fancy
    fi
}

em() {
    local fn=$1
    if [ ! -f $fn ]; then
        if [ "${fn: -1}" != "." ]; then fn="${fn}."; fi
        if [ -f "${fn}sh" ]; then
            fn=${fn}sh
        elif [ -f "${fn}cc" ]; then
            fn=${fn}cc
        elif [ -f "${fn}C" ]; then
            fn=${fn}C
        elif [ -f "${fn}h" ]; then
            fn=${fn}h
        elif [ -f "${fn}py" ]; then
            fn=${fn}py
        elif [ -f "${fn}tex" ]; then
            fn=${fn}tex
        else
            echo "Fail to append the extenstion?"
            return
        fi
    fi
    if [[ ! -z $2 ]]; then
        if [[ $2 == "." ]]; then
            . $fn
        elif [[ $2 == "py" ]]; then
            python $1
        elif [[ $2 == "rot" ]]; then
            rot $fn
        fi
    elif [[ $# == 1 ]]; then
        ~/play/emacs-25.1/lib-src/emacsclient -t $fn
    else
        ~/play/emacs-25.1/lib-src/emacsclient -t $@
    fi
}

mkpdf() {
    if [ -f "$1" ]; then
        pdflatex $1
    elif [ -f "${1}tex" ]; then
        pdflatex ${1}tex
    elif [ -f "${1}.tex" ]; then
        pdflatex ${1}.tex
    else
        echo "Fail to append the extenstion?"
    fi
    if [[ $2 == "web" ]]; then
        web ${1}pdf
    fi
}

cl() {
    if [[ -z $1 ]]; then
        ls -ltrhG --ignore=*.{o,d,aux,pcm,so,d,nav,snm,pyc,toc}
    elif [[ -d $1 ]] || [[ $1 == '-' ]]; then
        cd $1 && ls -ltrhG --ignore=*.{o,d,aux,pcm,so,d,nav,snm,pyc,toc}
    elif [[ -f $1 ]]; then
        cd $(dirname $1) && ls -ltrhG
    else
        local des=$(echo $1 | cut -d'/' --complement -f2-)
        if [[ -d $des ]]; then
            cd $des && ls -ltrhG
            echo "\"$1\" is not a directory or file, come to \"$des\" instead"
        else
            echo "$1: No such directory or file"; return 1
        fi
    fi
}

mkcd() {
    mkdir -p "$1" && cd "$1"
}

mkcp() {
    mkdir -p ${!#} && cp -r $@
}

mkmv() {
    mkdir -p ${!#} && mv $@
}

mdcp() {
    mkdir -p ${!#} && cpcd $@
}

mdmv() {
    mkdir -p ${!#} && mvcd $@
}

cpcd() {
    if [ $# -lt 2 ]; then
        echo "Must have at least 2 arguments!"; return 1
    fi
    if [ -d ${!#} ]; then
        cp -r $@ && cd -- ${!#}
    else
        cp -r $@ && cd $(dirname ${!#})
    fi
}

cpcl() {
    cpcd $@ && ls -ltrhG
}

mvcd() {
    if [ $# -lt 2 ]; then
        echo "Must have at least 2 arguments!"; return 1
    fi
    if [ -d ${!#} ]; then
        mv $@ && cd -- ${!#}
    else
        mv $@ && cd $(dirname ${!#})
    fi
}

gcl() {
    if [ ! -z $2 ]; then
        git clone $@ && cl $2
    else
        git clone "$1" && cl $(basename "$1" ".git")
    fi
}

cmsrelev() {
    cmsrel "$1" && cd "$1/src" && cmsenv
}

kajobs() {
    local pid=$(jobs -p)
    if [ -n "${pid}" ]; then
        kill -9 $pid
    fi
}

web() {
    local fname=$(basename $1)
    cp -r $1 ~/public_html/dump/
    local addr="http://uaf-8.t2.ucsd.edu/~${USER}/dump/$fname"
    echo "Posted online at $addr"
}

function rtb {
    root $* ~/macros/openTBrowser.C -dir $PWD
}

function col {
    if [ $# -lt 1 ]; then
        echo "usage: col <col #>"; return 1
    fi
    if [[ $1 -lt 0 ]]; then
        awk "{print \$(NF+$(($1+1)))}"
    else
        awk -v x=$1 '{print $x}'
    fi
}

function cjs {
    if [ $# -lt 1 ]; then
        echo "Usage: cjs <input root files>"; return 1
    fi
    if [[ $(hostname) == *uaf-* ]]; then
        cp -rp $@ ~/public_html/jsroot/files/
        chmod -R a+r ~/public_html/jsroot/files/
    else
        scp -rp $@ ${USER}@uaf-1.t2.ucsd.edu:~/public_html/jsroot/files/
    fi
    for file in "$@"; do
        echo "http://uaf-8.t2.ucsd.edu/~${USER}/jsroot/index.htm?file=files/$(basename $file)"
    done
}

function jsr {
    if [ $# -lt 1 ]; then
        echo "Usage: jsr <input root files> <additional suffix (optional)>"; return 1
    fi
    local lnname=$(basename $1)
    if [[ ! $lnname == *.root ]]; then
        echo "Error: Meaningless to put non-root file to jsroot"
        echo "Usage: jsr <input root files> <additional suffix (optional)>"; return 1
    fi
    if [ ! -z $2 ]; then
        lnname=$(basename $lnname .root)
        lnname="${lnname}_$2.root"
    fi
    if [ -L ~/public_html/jsroot/files/$lnname ]; then
        local oldlink=$(readlink ~/public_html/jsroot/files/$lnname)
        if [ ! $oldlink == $(readlink -f $1) ]; then
            echo "Warning: Replacing link $lnname existed in jsroot for $oldlink"
        fi
    fi
    ln -sf $(pwd)/$1 ~/public_html/jsroot/files/$lnname

    echo "http://uaf-8.t2.ucsd.edu/~${USER}/jsroot/index.htm?file=files/$lnname"
}

mailme() {
    if [ $? -eq 0 ]
    then str="[UAFNotify] Command ended SUCCESSFULLY on $(date) with status code $?"
    else str="[UAFNotify] Command FAILED on $(date) with return value $?"
    fi
    str=$(echo $str | sed 's/:/_/g')
    echo "$(pwd) $(ls -lthr)" | mail -s "$str" ${EMAIL}
}

# -- temporal --
alias clpr='cd ~/working/MT2Analysis/MT2looper && sw805'
alias cspt='cd ~/working/MT2Analysis/scripts && sw805'
alias cbmk='cd ~/working/MT2Analysis/babymaker && sw805'
alias ctap='cd ~/working/MuonTagAndProbe/looper && sw805'
alias ccrd='cd ~/working/MT2Analysis/scripts/cards && hclev'
alias rpmh="rot plotMakerHcand.C"
alias mktab="rot plotMakerHcand.C && cd latex/compile/ && cp ../table.tex . && pdflatex table.tex && web table.pdf && ..."

alias sw805="pushd ~/working/MT2Analysis/CMSSW_8_0_5/src/ > /dev/null && cmsenv && popd > /dev/null"
alias sw747="pushd ~/working/MT2Analysis/CMSSW_7_4_7/src/ > /dev/null && cmsenv && popd > /dev/null"
alias sw826="pushd ~/working/CMSSW_8_0_26_patch1/src/ > /dev/null && cmsenv && popd > /dev/null"
alias hclev="pushd ~/working/CMSSW_7_4_7/src/HiggsAnalysis/CombinedLimit/ > /dev/null && cmsenv && . env_standalone.sh > /dev/null && popd > /dev/null"
