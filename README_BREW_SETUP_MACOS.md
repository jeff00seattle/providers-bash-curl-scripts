# @act/act-archive-docusign-springcm
##### Bash Scripts: Brew Setup for MacOS

---

![](doc/images/mac-os-logo.png)

---

## Upgrade Bash on macOS

+ [Medium: Upgrading Bash on macOS](https://itnext.io/upgrading-bash-on-macos-7138bd1066ba)
+ [Stack Exchange: Install Bash 4 via Homebrew](https://apple.stackexchange.com/questions/193411/update-bash-to-version-4-0-on-osx/292760#292760)

### Default Bash Version on macOS
To see how outdated the Bash version included in macOS is, execute the following command:

```bash
$ bash --version
GNU bash, version 3.2.57(1)-release (x86_64-apple-darwin18)
Copyright (C) 2007 Free Software Foundation, Inc.
```

As you can see, this is GNU Bash version 3.2, which dates from 2007! 
This version of Bash is included in all versions of macOS, even the newest one.

### Install the latest version of Bash

Use [Homebrew](https://brew.sh/) to install the latest version of Bash:

```bash
$ brew install bash
```

You now have two versions of Bash on your system:

```bash
$ which -a bash
/usr/local/bin/bash
/bin/bash
```

The first one is the new version, and the second one is the old version:

```bash
$ /usr/local/bin/bash --version
GNU bash, version 5.0.7(1)-release (x86_64-apple-darwin18.5.0)
Copyright (C) 2019 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>

This is free software; you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

$ /bin/bash --version
  GNU bash, version 3.2.57(1)-release (x86_64-apple-darwin18)
  Copyright (C) 2007 Free Software Foundation, Inc.
```

### Validate new Bash version installed

Open new terminal and make sure new version is default:

```bash
$ bash --version 
GNU bash, version 5.0.7(1)-release (x86_64-apple-darwin18.5.0)
Copyright (C) 2019 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
```

Since the directory of the new version (/usr/local/bin) comes by default before the directory of the 
old version (/bin) in the PATH variable, the version used when you just type bash is the new one.

### Whitelist Bash shell

Newly installed Bash shell as the default shell, it must be able to act as a login shell.

Add the **`/usr/local/bin/bash`** shell to its content, so that the file looks something like this:

```bash
$ sudo vim /etc/shells

/bin/bash
/bin/csh
/bin/ksh
/bin/sh
/bin/tcsh
/bin/zsh
/usr/local/bin/bash
```

## Install Zsh Shell

+ [macOS suggestions: iTerm2, Zsh shell, and Oh-My-Zsh Github Theme](https://jira.corp.docusign.com/confu/display/AACT/macOS+suggestions%3A+iTerm2%2C+Zsh+shell%2C+and+Oh-My-Zsh+Github+Theme)

The intent of this document is to promote:

1. Install **iTerm2**, a replacement for Terminal and the successor to iTerm.
1. Install **Zsh**, a Unix shell that is built on top of bash (the default shell for macOS) with additional features.
1. Install **Oh-My-Zsh**, for providing theming for view current github branch being reviewed in terminal.


## Add macOS Command-Line Utilities

Use [Homebrew](https://brew.sh/) for installing required command-line utilities in macOS for running bash scripts:

+ [**curl**](https://formulae.brew.sh/formula/curl): Get a file from an HTTP, HTTPS or FTP server.
+ [**jq**](https://formulae.brew.sh/formula/jq): Lightweight and flexible command-line JSON processor.
+ [**gnu-getopt**](https://formulae.brew.sh/formula/gnu-getopt): Command-line option parsing utility.

```bash
$ brew install curl
$ brew install jq
$ brew link --force gnu-getopt
$ brew install gnu-getopt

$ echo 'export PATH="/usr/local/opt/gnu-getopt/bin:$PATH"' >> ~/.zshrc
$ source ~/.zshrc
```
