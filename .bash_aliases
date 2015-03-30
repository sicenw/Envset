alias lt='ls -ltr'
      
alias em='emacs -nw'

alias ipynb='ipython notebook'

alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias .......='cd ../../../../../..'
alias ........='cd ../../../../../../..'

#Functional alias
ei() {
    if [ -f "$1" ]
    then
	emacs -nw "$1" --eval '(setq buffer-read-only t)'
    else
	echo "File $1 not found."
    fi
}

mkcd() {
  mkdir "$1" && cd "$1"
}

mkpdf(){

    local FILENAME="$1" #| cut -d'.' --complement -f2-
    FILENAME=$(echo $FILENAME | cut -d'.' --complement -f2-)
    local LATEXFILENAME="$FILENAME.tex"
    local PDFFILENAME="$FILENAME.pdf"

    pdflatex $LATEXFILENAME && evince $PDFFILENAME 

}
