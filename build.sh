if [ ! -d build/ ]
then
mkdir build/ && echo "-> created build/"
fi

readline=$(head -n 1 source/pdxinfo)
name=${readline#*=}
readlineversion=$(head -n 5 source/pdxinfo | tail -n 1)
version=${readlineversion#*=}
filename=${name}-${version}.pdx

pdc source build/$filename && open build/$filename
