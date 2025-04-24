#!/bin/sh


# REPO CONFIG NEEDS A HOME IF IT DOESN'T EXIST
mkdir -p /usr/local/etc/pkg/repos/




# CREATE NEW PKG CONF FOR PKGBASE
cat <<'EOF' >/usr/local/etc/pkg/repos/FreeBSD-base.conf
FreeBSD-base: {
  url: "pkg+https://pkg.FreeBSD.org/${ABI}/base_release_2",
  mirror_type: "srv",
  signature_type: "fingerprints",
  fingerprints: "/usr/share/keys/pkg",
  enabled: yes
}
EOF




# UPDATE PKG WITH NEW REPO
pkg update




# INSTALL PKGBASE
# AND FILTER OUT SOME PACKAGES
pkg search -r FreeBSD-base BSD | \
awk '!/-(dbg|man|dev|lib32|src|kernel)-/' | \
sed 's/-[0-9][0-9]\.[0-9].*//' | \
xargs pkg install -y -r FreeBSD-base FreeBSD-kernel-generic FreeBSD-clibs-dev




# RESTORE IMPORTANT FILES
cp /etc/pkg/FreeBSD.conf.pkgsave /etc/pkg/FreeBSD.conf
cp /etc/group.pkgsave /etc/group
cp /etc/master.passwd.pkgsave /etc/master.passwd
cp /etc/shells.pkgsave /etc/shells
cp /etc/sysctl.conf.pkgsave /etc/sysctl.conf




# JUST SAVE/EXIT, NO NEED TO CHANGE ANYTHING
# THIS IS NEEDED TO UNBREAK THE USER/PASSWORD DATABASE
vipw




# CLEAN UP OLD FILES
find / -name "*.pkgsave" | xargs rm -f




# FIX ROOT SHELL
! rm /root/.cshrc 2>/dev/null
ln -s /vince/root/.cshrc /root/
chsh -s /bin/csh root




# RE-ENABLE / FIX SSH
! rm /etc/ssh/sshd_config 2>/dev/null
ln -s /vince/etc/ssh/sshd_config /etc/ssh/
