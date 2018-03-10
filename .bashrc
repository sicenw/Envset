#xset b off
if [[ $- != *i* ]]; then
    return;
fi

export EDITOR="emacs -nw -q"

# Adding to PATH
PATH=$PATH:$HOME/scripts/sh:$HOME/scripts/py:$HOME/.local/bin

# export CVSROOT=:gserver:cmscvs.cern.ch:/cvs_server/repositories/CMSSW
# export CVS_RSH=ssh

# PDFLATEX
# export PATH=$PATH:/nfs-7/texlive/2015/bin/x86_64-linux

# CMS
export CMS_PATH=/code/osgcode/cmssoft/cms

# CMSSW
# source /code/osgcode/cmssoft/cmsset_default.sh > /dev/null
source /cvmfs/cms.cern.ch/cmsset_default.sh > /dev/null
export SCRAM_ARCH=slc6_amd64_gcc630
# source /nfs-7/cmssoft/cms.cern.ch/cmssw/cmsset_default.sh

# Crab
# source /code/osgcode/ucsdt2/Crab/etc/crab.sh
alias scrab='source /cvmfs/cms.cern.ch/crab3/crab.sh'
# export GLITE_VERSION="gLite-3.2.11-1"
# export LCG_GFAL_INFOSYS=lcg-bdii.cern.ch:2170
# export GLOBUS_TCP_PORT_RANGE=20000,25000

# Apperance
export TERM=xterm-256color
alias grep='grep --color=auto'
alias g++='g++ -std=c++14'
alias g17='g++ -std=c++17'

# User aliases
alias shrc='. ~/.bashrc'
alias cliped='printf "$_" | clip'
alias ls='ls --color=auto'
alias lt='ls -l -t -r -h -G'
alias le='ls -ltrhG --ignore=*.{o,d,aux,pcm,so,nav,snm,pyc,toc}'
alias la='ls -l -t -r -a -h'
alias lta='ls -l -t -r -a -h -G'
alias lse='ls -l -t -r -h -G --sort=extension'
alias lc='cl'
alias root='root -l'
alias rot='root -l -b -q'
alias Emacs='~/play/emacs-25.1/src/emacs &'
alias emsvr='~/play/emacs-25.1/src/emacs --daemon'
alias emc='~/play/emacs-25.1/lib-src/emacsclient -t'
alias emq='~/play/emacs-25.1/src/emacs -q -nw'
alias enw='emacs -nw -q'
alias dui='du -hc --max-depth=1'
alias gst='git st'
alias gad='git add'
alias gcm='git cm'
alias gca='git ca'
alias gam='git cam'
alias gmd='git amd'
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
export PYTHONPATH=$PYTHONPATH:~/tas/Software/:~/tas/Software/pyRootPlotMaker/
export PYTHONPATH=$PYTHONPATH:~/scripts/py/
export CMSSW_HEADER_FILES=/cvmfs/cms.cern.ch/slc6_amd64_gcc530/cms/cmssw/CMSSW_8_0_26/src/

# Fast calls and cds
alias cr='cmsRun'
alias mg='~/Generator/MG5_aMC_v2_3_2/bin/mg5_aMC'
alias cweb='cl ~/public_html/'
alias cdmp='cl ~/public_html/dump'
alias chdp='cd $HDP'
alias cpjo='cd $HDP/ProjectMetis'
alias cghdp='cd $GHDP/run2_25ns'
alias cnfs='cd /nfs-7/userdata/${USER}'
alias cgnfs='cd /nfs-6/userdata/mt2'
alias rrnd='rnd "root -l" .root'
alias ernd='rnd em'
alias vrnd='rnd vi'
alias crnd='rnd cd'
alias clnd='rnd cl'
alias prnd='rnd pg'
alias crrnd='rnd cmsRun .py'
alias mkj='make -j 12'
alias sbf='cmsenv; cd $CMSSW_BASE ; scram b -f -j25 ; cd -'
alias vpim='voms-proxy-init -hours 5000'
alias condq='condor_q $USER'
alias condn='condor_q $USER -total'
alias scr='screen -r'

# Auto completion
[ -f ~/.fzf/.fzf.bash ] && source ~/.fzf/.fzf.bash
if [ -d ~/.fzf/.bash_completion.d ]; then
    for file in ~/.fzf/.bash_completion.d/*; do
        . $file
    done
fi

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
    elif [[ $2 == "ast" ]]; then
        git add $fn && git status
    elif [[ $# == 1  ]] && [[ ${1:0:1} != "-" ]]; then
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
        ~/play/emacs-25.1/src/emacs -nw $fn
    else
        ~/play/emacs-25.1/src/emacs -nw $@
    fi
}

rnd() {
    # local rndf=`ls -t *${2}* | head -n 1`
    # local rndf=`find . *${2}* -maxdepth 0 | tail -n 1`
    local nthf=${3:-1}
    if [[ -z $2 ]]; then
        local rndf=`ls -ltr | awk '{if ($5 != 0) print $9}' | tail -n $nthf | head -n 1`
    elif [[ -f $2 ]] || [[ -d $2 ]]; then
        local rndf=$2
    elif [[ $2 == "*/*" ]]; then
        local rndf=`ls -ltr *${2}* | awk '{if ($5 != 0) print $9}' | tail -n $nthf | head -n 1`
    else
        local rndf=`ls -ltr | grep ${2} | awk '{if ($5 != 0) print $9}' | tail -n $nthf | head -n 1`
    fi
    if [[ $rndf != "" ]]; then
        echo "$1 $rndf"
        $1 $rndf
        history -s "$1 $rndf"
    else
        echo "Fail to find any random file."
    fi
}

py() {
    if [ -f "${1}py" ] && [ $# == 1 ]; then
        python ${1}py
    else
        python $@
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
            ls -ltrhG $des
            echo "\"$1\" is not a directory or file, do list of \"$des\" instead"
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

lg() {
    ls -l | grep "$*" | col 9 | xargs echo
}

cmsrev() {
    if [[ ${1:0:6} == "CMSSW_" ]]; then
        cmsrel "$1" && cd "$1/src" && cmsenv
    elif [[ $1 == "924" ]]; then
        cmsrel "CMSSW_9_2_4" && cd "CMSSW_9_2_4/src" && cmsenv
    elif [[ ${#1} == 3 ]]; then
        cmsrel "CMSSW_${1:0:1}_${1:1:1}_${1:2:1}" && cd "CMSSW_${1:0:1}_${1:1:1}_${1:2:1}/src" && cmsenv
    elif [[ ${#1} == 5 ]]; then
        cmsrel "CMSSW_${1:0:1}_${1:1:1}_${1:2:1}_patch${1:4:1}" && cd "CMSSW_${1:0:1}_${1:1:1}_${1:2:1}_patch${1:4:1}/src" && cmsenv
    else
        echo "Can't understand argument $1"
    fi
}

kajobs() {
    local pid=$(jobs -p)
    if [ -n "${pid}" ]; then
        kill -9 $pid
    fi
}

mkc() {
    if [ -f Makefile ]; then
        make clean
    else
        echo rm *.so *.pcm *.d
        rm *.so *.pcm *.d
    fi
}

web() {
    local fname=$(basename $1)
    local des=${2:-"slides"}
    local machine=${3:-"uaf"}
    if [[ $machine == "uaf" ]]; then
        cp -r $1 ~/public_html/$des
        local addr="http://uaf-8.t2.ucsd.edu/~${USER}/$des/$fname"
    elif [[ $machine == "lxplus" ]] || [[ $machine == "cern" ]]; then
        scp -r $1 lxplus:~/www/share/$des
        local addr="http://${USER}.cern.ch/${USER}/share/$des/$fname"
    fi
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
        echo "http://uaf-8.t2.ucsd.edu/~${USER}/jsroot/index.htm?file=files/$(basename $file)" | clip
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

    echo "http://uaf-10.t2.ucsd.edu/~${USER}/jsroot/index.htm?file=files/$lnname" | clip
}

function xcp {
    local dest="."
    if [ $# -gt 1 ]; then
        dest=$2
    fi
    xrdcp root://cmsxrootd.fnal.gov/$1 $dest
}

function clip {
    read foo
    echo -e "\033]1337;CopyToClipboard=;\a$foo\033]1337;EndCopy\a"
}

function condl {
    local num=20
    # if number is less than 10k, then it can't be a condor_id, so
    # use it as the number of entries to show, otherwise use it
    # as condor_id
    if [ $# -gt 0 ]; then
        num=$(echo $1 | sed 's/\.0//')
    fi
    if  [[ $# -gt 0 && "$num" -gt 10000 ]]; then
        local temp_file=$(mktemp)
        local jobid=$1
        # condor_history $USER -limit $num | grep $jobid
        # condor_history $USER -limit 100 | grep $jobid
        condor_history -l $jobid -limit 1 > $temp_file
        local iwd=$(cat $temp_file | grep "^Iwd" | cut -d\" -f2)
        local out=$(cat $temp_file | grep "^Out" | cut -d\" -f2)
        local err=$(cat $temp_file | grep "^Err" | cut -d\" -f2)
        [[ "$out" == "/"* ]] || out=${iwd}/${out}
        [[ "$err" == "/"* ]] || err=${iwd}/${err}
        echo $out
        echo $err
        vim -O $out $err
        rm $temp_file
    else
        # condor_history $USER -limit 100
        condor_history $USER -limit $num
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

# -- temporary --
alias cmt2='cd ~/working/MT2Analysis/MT2looper && sw805'
alias cspt='cd ~/working/MT2Analysis/scripts && sw805'
alias ccrd='cd ~/working/MT2Analysis/scripts/cards && evhcl'
alias cmvl='cd ~/working/METvalidation/looper'
alias csca='cd ~/working/CSCTiming/CMSSW_9_4_1/src/CSCOfflineTiming/CSCTimingAnalyzer && cmsenv'
alias cscb='cd ~/working/CSCTiming/CMSSW_9_4_1/src/CSCOfflineTiming/CSCTimingBabyMaker/test && cmsenv'
alias cstl='cd ~/working/StopAnalysis/StopLooper && ev941'
alias csas='cd ~/working/StopAnalysis/AnalyzeScripts && ev941'
alias csbm='cd ~/working/StopAnalysis/StopBabyMaker && ev941'
alias ccmb='cd ~/working/StopAnalysis/CombineAnalysis && sw747'
alias csrf='cd ~/working/LGADTesting/sr90phfit && ev100'
alias cled='cd ~/working/LGADTesting/ledgainfit && ev100'
alias cttl='cd ~/temp/StopAnalysis/StopBabyLooper && ev941'
alias cttc='cd ~/temp/StopAnalysis/StopCORE && ev941'
alias ttmk='cd ../StopCORE && mkc && mkj && cd - && mkc && mkj'

alias eswv='echo $CMSSW_VERSION'
alias erlb='printf $CMSSW_RELEASE_BASE/src | clip'
alias sw805="pushd ~/working/MT2Analysis/CMSSW_8_0_5/src/ > /dev/null && cmsenv && popd > /dev/null"
alias sw747="pushd ~/working/CMSSW_7_4_7/src/ > /dev/null && cmsenv && popd > /dev/null"
alias sw826="pushd ~/working/CMSSW_8_0_26_patch1/src/ > /dev/null && cmsenv && popd > /dev/null"
alias sw924="pushd ~/play/CMSSW_9_2_4/src/ > /dev/null && cmsenv && popd > /dev/null"
alias ev928="pushd /cvmfs/cms.cern.ch/slc6_amd64_gcc630/cms/cmssw/CMSSW_9_2_8 > /dev/null && cmsenv && popd > /dev/null"
alias ev92b="pushd /cvmfs/cms.cern.ch/slc6_amd64_gcc630/cms/cmssw/CMSSW_9_2_11 > /dev/null && cmsenv && popd > /dev/null"
alias ev940="pushd /cvmfs/cms.cern.ch/slc6_amd64_gcc630/cms/cmssw/CMSSW_9_4_0 > /dev/null && cmsenv && popd > /dev/null"
alias ev941="pushd /cvmfs/cms.cern.ch/slc6_amd64_gcc630/cms/cmssw/CMSSW_9_4_1 > /dev/null && cmsenv && popd > /dev/null"
alias ev943="pushd /cvmfs/cms.cern.ch/slc6_amd64_gcc630/cms/cmssw/CMSSW_9_4_3 > /dev/null && cmsenv && popd > /dev/null"
alias ev94p="pushd /cvmfs/cms.cern.ch/slc6_amd64_gcc700/cms/cmssw/CMSSW_9_4_0_pre3 > /dev/null && cmsenv && popd > /dev/null"
alias ev100="pushd /cvmfs/cms.cern.ch/slc6_amd64_gcc630/cms/cmssw/CMSSW_10_0_0 > /dev/null && cmsenv && popd > /dev/null"
alias eva01="pushd /cvmfs/cms.cern.ch/slc6_amd64_gcc630/cms/cmssw/CMSSW_10_0_1 > /dev/null && cmsenv && popd > /dev/null"
alias eva02="pushd /cvmfs/cms.cern.ch/slc6_amd64_gcc630/cms/cmssw/CMSSW_10_0_2 > /dev/null && cmsenv && popd > /dev/null"
alias ev700="pushd /cvmfs/cms.cern.ch/slc6_amd64_gcc700/cms/cmssw/CMSSW_10_0_0 > /dev/null && cmsenv && popd > /dev/null"
alias evhcl="pushd ~/working/CMSSW_7_4_7/src/HiggsAnalysis/CombinedLimit/ > /dev/null && cmsenv && . env_standalone.sh > /dev/null && popd > /dev/null"
