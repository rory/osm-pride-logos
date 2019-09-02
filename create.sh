#!/bin/bash

cd $(dirname $0)

SIZES="500 100"

for FLAG in ./flags/*.svg ; do
    NAME=${FLAG}
    NAME=${NAME##.*/}
    NAME=${NAME%%.svg}
    OUTPUT=OSM_white_bg_with_small_border.${NAME}
    sed "s|FLAGFLAGFLAG|${FLAG}|" ./templates/logo_base.template.svg | gzip > OSM_white_bg_with_small_border.${NAME}.svgz
    sed "s|FLAGFLAGFLAG|${FLAG}|" ./templates/logo_base_nb.template.svg | gzip > OSM_white_bg_with_small_border.nb.${NAME}.svgz
    inkscape --without-gui --file=OSM_white_bg_with_small_border.${NAME}.svgz --export-dpi 300 --export-pdf ${OUTPUT}.pdf --export-background white --export-margin 3
    inkscape --without-gui --file=OSM_white_bg_with_small_border.nb.${NAME}.svgz --export-dpi 300 --export-pdf ${OUTPUT}.nb.pdf --export-background white --export-margin 3
    for SIZE in $SIZES ; do
        inkscape --without-gui --file=OSM_white_bg_with_small_border.${NAME}.svgz -w $SIZE -h $SIZE --export-png ${OUTPUT}.${SIZE}.png --export-background white
        inkscape --without-gui --file=OSM_white_bg_with_small_border.nb.${NAME}.svgz -w $SIZE -h $SIZE --export-png ${OUTPUT}.${SIZE}.nb.png --export-background white
        pngquant -f --ext .png 128 ${OUTPUT}.${SIZE}.png
        pngquant -f --ext .png 128 ${OUTPUT}.${SIZE}.nb.png
    done
    echo $NAME
done

exiftool -overwrite_original -XMP-dc:Rights="This work is licensed to the public under the Creative Commons Attribution-ShareAlike license http://creativecommons.org/licenses/by-sa/4.0/" -xmp:usageterms="This work is licensed to the public under the Creative Commons Attribution-ShareAlike license http://creativecommons.org/licenses/by-sa/4.0/" -XMP-cc:license="http://creativecommons.org/licenses/by-sa/4.0/" -XMP-cc:AttributionName="R McCann" -XMP-cc:AttributionURL="www.technomancy.org" *.png
