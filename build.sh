if [ ! -d build/ ]
then
mkdir build/ && echo "build/ created"
fi
pdc source build/pong.pdx && open build/pong.pdx
