#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail
RRH_VERSION=""

cd "$(dirname $0)/"

help() {
    echo "Usage: ./build.bash [-v VERSION] [TARGET]"
    exit 8
}

clean() {
    rm -rf build
}

build_to_hfs() {
    mkdir build

    mkdir -p build/fs/usr/bin
    cp src/bin/* build/fs/usr/bin/
    sed -i "s/RRH_USR_BIN=\"\.\"/RRH_USR_BIN=\"\/usr\/bin\"/g" build/fs/usr/bin/*
    sed -i "s/RRH_VAR=\"\$HOME\/\.cache\/rrh-test\"/RRH_VAR=\"\/var\/lib\/rrh\"/g" build/fs/usr/bin/*
    sed -i "s/RRH_VERSION=\"source\"/RRH_VERSION=\"$RRH_VERSION\"/g" build/fs/usr/bin/*
    chmod 755 build/fs/usr/bin/*
    ln -s /usr/bin/rrh-full-update build/fs/usr/bin/rfu

    mkdir -p build/fs/usr/lib/systemd/system/
    cp src/systemd/* build/fs/usr/lib/systemd/system/
    chmod 644 build/fs/usr/lib/systemd/system/*
}

build_basic() {
    tar -C build --zstd --owner=0 --group=0 --transform "s/fs/rrh-$RRH_VERSION-basic/" -cf "build/rrh-$RRH_VERSION-basic.tar.zst" fs/
}

while getopts 'v:h' OPT; do
    case $OPT in
        v) RRH_VERSION="$OPTARG";;
        h) help;;
    esac
done
shift $(($OPTIND - 1))
if [ -z "$RRH_VERSION" ]; then
    if command -v "git" >/dev/null 2>&1 && [ -d ".git" ]; then
        RRH_VERSION="commit.$(git rev-parse --verify HEAD)"
    else
        RRH_VERSION="unknown"
    fi
fi

build() {
    case "$1" in
        "fs") ;;
        "basic") build_basic;;
        "clean") exit 8;;
    esac
}

clean
if [ $# -eq 0 ]; then
    build_to_hfs
    build basic
else
    if [ "$1" == "clean" ]; then
        exit 0
    else
        build_to_hfs
        for t in "$@"; do
            build "$t"
        done
    fi
fi