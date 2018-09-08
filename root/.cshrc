# $FreeBSD: releng/11.2/etc/root/dot.cshrc 278616 2015-02-12 05:35:00Z cperciva $
#
# .cshrc - csh resource script, read at beginning of execution by each shell
#
# see also csh(1), environ(7).
# more examples available at /usr/share/examples/csh/
#

# misc aliases
alias	..			"cd .."
alias	cd..		"cd .."
alias	clr			"clear"
alias	cls			"clear"
alias	h			"history 25"
alias	j			"jobs -l"
alias	free		"freecolor -o"
alias	myip		"curl icanhazip.com"
alias	psx			"ps aux"
	
# grep aliases
alias	grep		"grep --color=auto"
alias	egrep		"egrep --color=auto"
alias	fgrep		"fgrep --color=auto"
alias	zgrep		"zgrep --color=auto"
alias	zegrep		"zegrep --color=auto"
alias	zfgrep		"zfgrep --color=auto"

# ls aliases
alias	l.			"ls -dlG .*"
alias	ls			"ls -G"
alias	la			"ls -aG"
alias	lf			"ls -AG"
alias	ll			"ls -alG"
alias	dir			"ls -alG"
alias	lsdir		"ls -al | grep ^d"

# pkg aliases
alias	inst		"pkg install -y"
alias	upgr		"pkg upgrade -y"
alias	updt		"pkg update"
alias	srch		"pkg search \!:1 | grep \!:1"


# A righteous umask
umask 22

set path = (/sbin /bin /usr/sbin /usr/bin /usr/local/sbin /usr/local/bin $HOME/bin)

setenv	EDITOR		nano
setenv	PAGER		more
setenv	BLOCKSIZE	K

if ($?prompt) then
	# An interactive shell -- set some stuff up

	set TITLE = ""

	switch($TERM)
		case "rxvt":
		case "screen*":
		case "xterm*":
			set TITLE = "%{\033]0;%m:%~\007%}"
	endsw

	set prompt = "${TITLE}%{\e[34m%}%n%{\e[0m%}@%{\e[32m%}%m%{\e[0m%} %{\e[1;33m%}%~%{\e[0m%}# "
	set promptchars = "%#"

	unset TITLE

	set filec
	set history = 1000
	set savehist = (1000 merge)
	set autolist = ambiguous
	# Use history to aid expansion
	set autoexpand
	set autorehash
	set mail = (/var/mail/$USER)
	if ( $?tcsh ) then
		bindkey "^W" backward-delete-word
		bindkey -k up history-search-backward
		bindkey -k down history-search-forward
		bindkey "\e[1~" beginning-of-line
		bindkey "\e[2~" overwrite-mode
		bindkey "\e[3~" delete-char
		bindkey "\e[4~" end-of-line
	endif

endif
