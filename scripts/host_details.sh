#!/bin/bash

usage() {
   echo "Usage ./setup.sh { -a | -p | -w | -h }
      -a : get generic architecture
      -p : get specific processor name
      -w : get vector width
      -h : Print Usage Help Message"
}

ARCH=0
PROC=0
VWIDTH=0
while getopts "apwh" opt; do
   case $opt in
       a) ARCH=1     ;;
       a) PROC=1     ;;
       w) VWIDTH=1     ;;
       h) usage; exit 1  ;;
   esac
done
if (( (ARCH + PROC + VWIDTH) != 1 )); then
    usage
    exit 1
fi


UNAME=`uname -m`

if ((ARCH)); then
    echo $UNAME

elif ((PROC)); then
    if [ "$UNAME" == "x86_64" ]; then
        cat /sys/devices/cpu/caps/pmu_name
    elif [ "$UNAME" == "aarch64" ]; then
        lscpu | grep -i 'model name' | awk '{print $NF}'
    else
        echo $UNAME
    fi

elif ((VWIDTH)); then
    if [ "$UNAME" == "aarch64" ]; then
        echo "variable"         # no need to inform compiler
    elif [ "$UNAME" == "x86_64" ]; then
        AVX=`lscpu | grep Flags | cut -d: -f2- | xargs -n1 echo | grep avx`
        if [[ -n `echo $AVX | grep 512` ]]; then
            echo 512
        elif [[ -n `echo $AVX | grep avx2` ]]; then
             echo 256
        elif [[ -n `echo $AVX | grep avx` ]]; then
            echo 128
        else
            echo 64
        fi
    else
        echo "unknown"
    fi

else
    usage
    exit 1
fi

