for file in *.vhd; do
    echo  "${file%.*}.vhd"
    vhd2vl "${file%.*}.vhd" >  "${file%.*}.v";
done
apio build
apio upload
