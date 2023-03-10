#!/bin/bash
ping -c 1 google.com >/dev/null 2>&1
if [ "$?" != '0' ]; then
    printf "\033[1;2;4;5;32m[\033[31m!\033[32m] \033[34mCheck your internet connection!\033[0;0;0;0;00m\n"
    exit 1
fi
printf "\033[32mSetting-up cloudflare in your system\033[00m\n"
cd $PREFIX/share >/dev/null 2>&1
rm -rf $PREFIX/share/cloudflare-ui >/dev/null 2>&1
git clone https://github.com/sksohal7/cloudflare-ui
ver=$(cloudflared --version | awk '{print $2}')
if [[ $ver != 'version' ]]; then
    rm -rf $PREFIX/bin/cloudflared >/dev/null 2>&1
fi
if ! hash cloudflared >/dev/null 2>&1; then
    source <(curl -fsSL "https://raw.githubusercontent.com/sksohal7/cloudflare-installer/main/setup.sh")
fi
cat <<- VAR > $PREFIX/bin/cloudflare
#!/bin/bash
arg1="\$1"
arg2="\$2"
cd $PREFIX/share/cloudflare-ui
bash cloudflare \${arg1} \${arg2}
VAR
chmod +x $PREFIX/bin/cloudflare
printf "\n\nConfiguration completed just run 'cloudflare --help' for help\n\n"
