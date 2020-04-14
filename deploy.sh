#!/bin/bash
set -e
trap 'echo "BiliHelper 安装失败, 请检查网络链接, 如有需要请自备梯子"' ERR
# Environment Config
TERMUX_PATH=$HOME/.termux
TERMUX_PROPS=$TERMUX_PATH/termux.properties
BHP_CONF_PATH=$HOME/storage/shared/bhpConf
BHP_CONF=$BHP_CONF_PATH/user.conf
ANDROID_VER=$(getprop ro.build.version.release)

cd $HOME

getopts_get_optional_argument() {
    eval nextopt=\${$OPTIND}
    if [[ -n $nextopt && $nextopt != -* ]]; then
        OPTIND=$((OPTIND + 1))
        OPTARG=$nextopt
    else
        OPTARG=""
    fi
}

# Usage
usage() {
    echo "Usage:"
    echo "  deploy.sh [-b] [-m <t|c|o>] [-p] [-c <a|g|o>] [-n]"
    echo
    echo "Options:"
    echo "  -b  备份外部配置文件"
    echo "  -m  切换 Termux 镜像地址"
    echo "      可选参数: t: Tuna / 清华,"
    echo "               c: CloudFlare CDN"
    echo "               o: Official / 官方 (默认),"
    echo "  -p  安装 / 更新先决程序 (首次运行必需)"
    echo "  -c  安装 / 更新 Composer (首次运行必需)"
    echo "      可选参数: a: aliyun / 阿里云,"
    echo "               g: Github / 本项目,"
    echo "               o: Official / 官方 (默认)"
    echo "  -n  安装 BHP 时使用阿里云 Composer 镜像"
    exit 0
}

# Setup Extra Keys Rows
setupExtKey() {
    if [ ! -d $TERMUX_PATH ]; then
        mkdir $TERMUX_PATH
    fi
    if [ ! -f $TERMUX_PROPS ]; then
        echo "extra-keys = [['ESC','|','/','HOME','UP','END','PGUP','DEL'],['TAB','CTRL','ALT','LEFT','DOWN','RIGHT','PGDN','BKSP']]" >> $TERMUX_PROPS
        echo >> $TERMUX_PROPS
    else
        echo "文件 $TERMUX_PROPS 已存在, 跳过..."
    fi
}

# Backup Config File
backupConf() {
    echo
    echo "正在备份外部配置文件..."
    if [ -f $BHP_CONF ]; then
        mv $BHP_CONF $BHP_CONF.bak
        echo "原配置文件已备份为 user.conf.bak"
    else
        echo "未发现外部配置文件, 跳过..."
    fi
}

# Change Termux Mirror
changeMirr() {
    echo
    echo "正在切换 Termux 镜像源..."
    if [[ $ANDROID_VER == 5.* || $ANDROID_VER == 6.* ]]; then
        sed -i 's@^\(deb.*stable main\)$@#\1\ndeb https://termux.net stable main@' $PREFIX/etc/apt/sources.list
        sed -i 's@^\(deb.*games stable\)$@#\1\ndeb https://dl.bintray.com/grimler/game-packages-21 games stable@' $PREFIX/etc/apt/sources.list.d/game.list
        sed -i 's@^\(deb.*science stable\)$@#\1\ndeb https://dl.bintray.com/grimler/science-packages-21 science stable@' $PREFIX/etc/apt/sources.list.d/science.list
        echo "检测到 Android 5/6, Termux 镜像源切换不适用..."
    else
        if [[ $1 == "t" ]]; then
            sed -i 's@^\(deb.*stable main\)$@#\1\ndeb https://mirrors.tuna.tsinghua.edu.cn/termux/termux-packages-24 stable main@' $PREFIX/etc/apt/sources.list
            sed -i 's@^\(deb.*games stable\)$@#\1\ndeb https://mirrors.tuna.tsinghua.edu.cn/termux/game-packages-24 games stable@' $PREFIX/etc/apt/sources.list.d/game.list
            sed -i 's@^\(deb.*science stable\)$@#\1\ndeb https://mirrors.tuna.tsinghua.edu.cn/termux/science-packages-24 science stable@' $PREFIX/etc/apt/sources.list.d/science.list
            echo "已切换为 TUNA 清华镜像源..."
        elif [[ $1 == "c" ]]; then
            sed -i 's@^\(deb.*stable main\)$@#\1\ndeb https://main.termux-mirror.ml stable main@' $PREFIX/etc/apt/sources.list
            sed -i 's@^\(deb.*games stable\)$@#\1\ndeb https://games.termux-mirror.ml games stable@' $PREFIX/etc/apt/sources.list.d/game.list
            sed -i 's@^\(deb.*science stable\)$@#\1\ndeb https://science.termux-mirror.ml science stable@' $PREFIX/etc/apt/sources.list.d/science.list
            echo "已切换为 CloudFlare CDN 镜像源..."
        else
            sed -i 's@^\(deb.*stable main\)$@#\1\ndeb https://termux.org/packages/ stable main@' $PREFIX/etc/apt/sources.list
            sed -i 's@^\(deb.*games stable\)$@#\1\ndeb https://dl.bintray.com/grimler/game-packages-24 games stable@' $PREFIX/etc/apt/sources.list.d/game.list
            sed -i 's@^\(deb.*science stable\)$@#\1\ndeb https://dl.bintray.com/grimler/science-packages-24 science stable@' $PREFIX/etc/apt/sources.list.d/science.list
            echo "已切换为 Termux 默认镜像源..."
        fi
    fi
}

# Install / Update Prerequisite
preIns() {
    echo
    echo "正在升级 Termux 内部程序..."
    yes | pkg update
    echo
    echo "正在安装 BiliHelper 必需程序..."
    yes | pkg install curl git php
}

# Install Composer
compIns() {
    echo
    echo "正在安装 Composer..."
    if [[ $1 == "a" ]]; then
        curl -o $PREFIX/bin/composer https://mirrors.aliyun.com/composer/composer.phar
    elif [[ $1 == "g" ]]; then
        curl -o $PREFIX/bin/composer https://raw.githubusercontent.com/0x012FA733/BHP-Termux/composer/composer/latest/composer
    else
        EXPECTED_CHECKSUM="$(curl https://composer.github.io/installer.sig)"
        php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
        ACTUAL_CHECKSUM="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"

        if [ "$EXPECTED_CHECKSUM" != "$ACTUAL_CHECKSUM" ]
        then
            >&2 echo '错误: Composer 安装包哈希值不匹配'
            rm composer-setup.php
            exit 1
        fi

        php composer-setup.php --quiet
        RESULT=$?
        rm composer-setup.php
        if [ $RESULT == 0 ]; then
            mv composer.phar $PREFIX/bin/composer
            echo "Composer 安装完毕"
        else
            echo "Composer 安装失败"
            exit $RESULT
        fi
    fi
    if [[ $1 == "a" || $1 == "g" ]]; then
        chmod +x $PREFIX/bin/composer
        echo "Composer 安装完毕"
    fi
}

# Install BHP
bhpIns() {
    echo
    echo "正在安装 BiliHelper..."
    if [ -d bhp ]; then
        rm -rf bhp
    fi
    git clone https://github.com/lkeme/BiliHelper-personal.git bhp
    cd bhp
    rm composer.lock
    if [[ $1 == "a" || $1 == "g" ]]; then
        composer config repo.packagist composer https://mirrors.aliyun.com/composer/
    fi
    composer clearcache
    composer install
    if [ ! -d $BHP_CONF_PATH ]; then
        mkdir -p $BHP_CONF_PATH
    fi
    cp conf/user.conf.example $BHP_CONF

    cd $HOME
    echo
    echo "BiliHelper 已安装完毕, 请按照教程编辑手机内部储存根目录中 bhpConf/user.conf 文件配置 BiliHelper"
}

while getopts ':bmpcn' OPT; do
    case ${OPT} in
    b )
        by=1
        ;;
    m )
        getopts_get_optional_argument $@
        m=${OPTARG}
        case ${m} in
        t | c | o | '' )
            my=1
            ;;
        * )
            echo "Invalid Argument: '-m' got an invalid argument '$m'"
            usage
            ;;
        esac
        ;;
    p )
        py=1
        ;;
    c )
        getopts_get_optional_argument $@
        c=${OPTARG}
        case ${c} in
        a | g | o | '' )
            cy=1
            ;;
        * )
            echo "Invalid Argument: '-c' got an invalid argument '$c'"
            usage
            ;;
        esac
        ;;
    n )
        ny=1
        ;;
    * )
        usage
        ;;
    esac
done
shift $((OPTIND-1))

setupExtKey
if [[ ${by} == 1 ]]; then backupConf; fi
if [[ ${my} == 1 ]]; then changeMirr ${m}; fi
if [[ ${py} == 1 ]]; then preIns; fi
if [[ ${cy} == 1 ]]; then compIns ${c}; fi
if [[ ${ny} == 1 ]]; then c="a"; fi
bhpIns ${c}
