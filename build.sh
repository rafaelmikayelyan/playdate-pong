if [ ! -d build/ ]
then
mkdir build/ && echo "-> created build/"
fi

readline=$(head -n 1 source/pdxinfo)
name=${readline#*=}

pdc source build/${name}.pdx && open build/${name}.pdx