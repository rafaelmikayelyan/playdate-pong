if [ ! -d build/ ]
then
mkdir build/ && echo "-> created build/"
fi

name=$(awk '/name/' scriptsource)
version=$(awk '/version/' scriptsource)
filename=${name#*=}-${version#*=}.pdx

pdc source build/$filename && open build/$filename
