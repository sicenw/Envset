#xset b off
if [[ $- != *i* ]]; then
    return;
fi

export EDITOR="emacs -nw -q"
# export EDITOR="emacsclient t"

# Adding to PATH
PATH=$PATH:$HOME/scripts/sh

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

# User aliases
alias ls='ls --color=auto'
alias lt='ls -l -t -r -h'
alias lk='ls -l -t -r -h -G'
alias la='ls -l -t -r -a -h'
alias lta='ls -l -t -r -a -h -G'
alias lc='cl'
alias cpi='cp -ri'
alias root='root -l'
alias req='root -l -q'
alias rbq='root -l -b -q'
alias rot='root -l -b -q'
alias emsvr='emacs --daemon'
alias em='emacsclient -t'
alias enw='emacs -nw'
alias dui='du -hc --max-depth=1'
alias gst='git st'
alias gad='git add'
alias gcm='git cm'
alias gca='git ca'
alias gam='git cam'
alias gdf='git diff'
alias gco='git co'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ..3='cd ../../..'
alias ..4='cd ../../../..'
alias ..5='cd ../../../../..'
alias ..6='cd ../../../../../..'
alias c..='cl ..'
alias c...='cl ../..'

export HDP=/hadoop/cms/store/user/$USER
export GHDP=/hadoop/cms/store/group/snt

# Temporary aliases
alias mg='~/Generator/MG5_aMC_v2_3_2/bin/mg5_aMC'
alias chdp='cd $HDP'
alias cghdp='cd $GHDP/run2_25ns'
alias cnfs='cd /nfs-6/userdata/mt2'
alias clpr='cd ~/MT2Analysis/MT2looper && cms805'
alias cbmk='cd ~/MT2Analysis/babymaker && cms805'
alias ctap='cd ~/working/MuonTagAndProbe/looper && cms805'

# Functional aliases
# -- general  --
cl() {
    if [[ -z $1 ]]; then
        ls -ltrhG
    elif [[ -d $1 ]]; then
        cd $1 && ls -ltrhG
    elif [[ -f $1 ]]; then
        cd $(dirname $1) && ls -ltrhG
    else
        echo "$1: No such directory or file"; return 1
    fi
}

ei() {
    if [ -e "$1" ]; then
        enw "$1" --eval '(setq buffer-read-only t)'
    else
        echo "File $1 not found!"; return 1
    fi
}

mkcd() {
    mkdir -p "$1" && cd "$1"
}

cpcd() {
    while [[ $1 == "-*" ]]; do
        local ops="$ops $1"; shift
    done
    if [ $# -lt 2 ]; then
        echo "Must have at least 2 arguments!"; return 1
    fi
    if [ -d ${!#} ]; then
        cp -r $ops ${*%${!#}} ${!#} && cd ${!#}
    else
        echo "${!#} is not an directory or does not exist!"; return 1
    fi
}

cpcl() {
    cpcd $@ && ls -ltrhG
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

mailme() {
    if [ $? -eq 0 ]
    then str="[UAFNotify] Command ended SUCCESSFULLY on $(date) with status code $?"
    else str="[UAFNotify] Command FAILED on $(date) with return value $?"
    fi
    str=$(echo $str | sed 's/:/_/g')
    echo "$(pwd) $(ls -lthr)" | mail -s "$str" ${EMAIL}
}

# -- temporal --
cms741() {
    pushd ~/MT2Analysis/CMSSW_7_4_1_patch1/src/ > /dev/null
    cmsenv
    popd > /dev/null
}

cms805() {
    pushd ~/MT2Analysis/CMSSW_8_0_5/src/ > /dev/null
    cmsenv
    popd > /dev/null
}
