# set default tab width
tabs -4

# misc aliases
alias		clr			"clear"
alias		cls			"clear"
alias		h			"history 25"
alias		j			"jobs -l"
alias		ipconfig	"ifconfig"
alias		psx			"ps aux"
alias		zt			"zerotier-cli"
alias		ansible		"ansible-3.11"
alias		timestamp	"date +%s"
alias		unixtime	"date +%s"
alias		ssh			"ssh -A"
alias		quit		"exit"
alias		fullexit	"clear && exit"
alias		fullquit	"clear && exit"
alias		innotop		"innotop -m Q"


# FreeBSD only aliases
if (`uname` == 'FreeBSD') then
	alias	time		"/usr/bin/time -p"
	alias	free		"freecolor -o"
	alias	myip		"fetch -qo - http://icanhazip.com"
	alias	myip4		"fetch -4qo - http://icanhazip.com"
	alias	myip6		"fetch -6qo - http://icanhazip.com"

# Linux only aliases
else
	alias	myip		"wget -qO - http://icanhazip.com"
	alias	myip4		"wget -4qO - http://icanhazip.com"
	alias	myip6		"wget -6qO - http://icanhazip.com"
endif


# directory traversal aliases (because i make typos)
alias		cd~			"cd ~"
alias		cd/			"cd /"
alias		cd.			"cd ."
alias		cd..		"cd .."


# directory listing aliases (without eza)
if (`whereis -b eza` == 'eza:') then
	alias	l.			"ls -dlG .*"
	alias	la			ls -aF
	alias	lf			ls -FA
	alias	ll			ls -lAF
	alias	dir			ls -lAF
	alias	lsdir		"ls -lAF | grep '\[1;34md' --color=never"

# directory listing aliases (with eza)
else
	alias	l.			"ls -dlG .*"
	alias	ls			"eza"
	alias	la			"eza -aa"
	alias	ll			"eza -aalg"
	alias	dir			"eza -aalg"
	alias	lsdir		"eza -aalg --color=always | grep '\[1;34md' --color=never"
endif


# grep aliases
alias		grep		"grep --color=auto"
alias		egrep		"egrep --color=auto"
alias		fgrep		"fgrep --color=auto"
alias		zgrep		"zgrep --color=auto"
alias		zegrep		"zegrep --color=auto"
alias		zfgrep		"zfgrep --color=auto"


# FreeBSD package manager aliases
if (`uname` == 'FreeBSD') then
	alias	inst		"pkg install -y"
	alias	upgr		"pkg upgrade -y"
	alias	updt		"pkg update"
	alias	srch		"pkg search \!:1 | grep \!:1"
endif


# Linux and Unix package aliases
if (`uname` == 'FreeBSD') then
	alias	apt			"pkg"
	alias	apt-get		"pkg"
	alias	apt-cache	"pkg"
	alias	dpkg		"pkg"
	alias	yum			"pkg"
	alias	dnf			"pkg"
	alias	pkgin		"pkg"
endif


# generic colorizer aliases
if (`whereis -b grcat` != 'grcat:') then
	set cmds=( \
		cc \
		configure \
		cvs \
		df \
		diff \
		dig \
		du \
		env \
		gcc \
		gmake \
		ifconfig \
		last \
		ldap \
		lsof \
		lspci \
		mount \
		mtr \
		netstat \
		ping \
		ping6 \
		ps \
		stat \
		sysctl \
		traceroute \
		traceroute6 \
		uptime \
		wdiff \
		whois \
		iwconfig \
	)

	foreach cmd ($cmds)
		alias $cmd "grc --colour=auto $cmd"
	end

	unset cmd cmds
endif



# A righteous umask
umask 22

# AUTOMATICALLY CD INTO FOLDERS
set implicitcd

set path = ($HOME/bin /usr/local/sbin /usr/local/bin /sbin /bin /usr/sbin /usr/bin)

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
			set TITLE = "%{\033]0;%M:%~\007%}"
	endsw

	set prompt = "${TITLE}%{\e[34m%}%n%{\e[0m%}@%{\e[32m%}%M%{\e[0m%} %{\e[1;33m%}%~%{\e[0m%}# "
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
