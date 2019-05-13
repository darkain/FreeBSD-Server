# misc aliases
alias	clr			"clear"
alias	cls			"clear"
alias	h			"history 25"
alias	j			"jobs -l"
alias	free		"freecolor -o"
alias	myip		"fetch -qo - http://icanhazip.com"
alias	myip4		"fetch -4qo - http://icanhazip.com"
alias	myip6		"fetch -6qo - http://icanhazip.com"
alias	psx			"ps aux"
alias	zt			"zerotier-cli"
alias   ansible     "ansible-3.6"
alias	time		"/usr/bin/time -p"

# directory traversal aliases
alias	~			"cd ~"
alias	cd~			"cd ~"
alias	/			"cd /"
alias	cd/			"cd /"
alias	.			"cd ."
alias	cd.			"cd ."
alias	..			"cd .."
alias	cd..		"cd .."

#directory listing aliases
alias	l.			"ls -dlG .*"
alias	ls			"exa"
alias	la			"exa -aa"
alias	ll			"exa -aal"
alias	dir			"exa -aal"
alias	lsdir		"exa -aal --color=always | grep '\[1;34md' --color=never"

# grep aliases
alias	grep		"grep --color=auto"
alias	egrep		"egrep --color=auto"
alias	fgrep		"fgrep --color=auto"
alias	zgrep		"zgrep --color=auto"
alias	zegrep		"zegrep --color=auto"
alias	zfgrep		"zfgrep --color=auto"

# FreeBSD package manager aliases
alias	inst		"pkg install -y"
alias	upgr		"pkg upgrade -y"
alias	updt		"pkg update"
alias	srch		"pkg search \!:1 | grep \!:1"

# Linux package aliases
alias	apt			"pkg"
alias	apt-get		"pkg"
alias	apt-cache	"pkg"
alias	dpkg		"pkg"
alias	yum			"pkg"


# A righteous umask
umask 22

set path = (/sbin /bin /usr/sbin /usr/bin /usr/local/sbin /usr/local/bin $HOME/bin)

setenv	EDITOR		nano
setenv	PAGER		less
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
