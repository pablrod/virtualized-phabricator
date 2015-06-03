#!/bin/bash

function notinstalled {
  if yum list installed "$@" >/dev/null 2>&1; then
    return 1
  else
    return 0
  fi
}

sudo yum install epel-release -y
sudo yum install http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el7.rf.x86_64.rpm -y

if notinstalled rex; then
       rpm --import https://rex.linux-files.org/RPM-GPG-KEY-REXIFY-REPO.CENTOS6
       cat >/etc/yum.repos.d/rex.repo <<EOF
[rex]
name=CentOS \$releasever - \$basearch - Rex Repository
baseurl=http://rex.linux-files.org/CentOS/\$releasever/rex/\$basearch/
enabled=1
EOF

    yum --assumeyes install rex perl-Path-Tiny
else
    echo "Rex already installed"
fi


