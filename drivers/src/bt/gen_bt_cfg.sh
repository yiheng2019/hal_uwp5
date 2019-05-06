#!/usr/bin/env bash

if [ $# -lt 2 ]; then
	echo "Must have two parameters at least!"
	exit 1
fi

DST_FILE=$1
shift

echo -e "/*
 * Copyright (c) 2018, UNISOC Incorporated
 *
 * SPDX-License-Identifier: Apache-2.0
 */\n" > $DST_FILE

echo "#ifndef __BT_CONFIGURE_H__" >> $DST_FILE
echo "#define __BT_CONFIGURE_H__" >> $DST_FILE
echo -e "#include <zephyr/types.h>\n" >> $DST_FILE

for i in $@; do
	SRC_FILE=$i
	VAR_NAME=${SRC_FILE##*/}
	VAR_NAME=${VAR_NAME%%.*}
	VAR_TYPE=${VAR_NAME}_t

	echo "static $VAR_TYPE $VAR_NAME = {" >> $DST_FILE
	sed -i 's/\r\n//' $SRC_FILE
	sed -e '/^[A-Za-z]/!d'  -e 's/^/\t.&/' -re 's/= ([^,]*),([^\r\n]*)/= {\1,\2}/' -e 's/[^\r\n]$/&,/' -e 's/\r/,&/' $SRC_FILE >> $DST_FILE
	echo -e "};\n" >> $DST_FILE
done

echo "#endif /* __BT_CONFIGURE_H__ */" >> $DST_FILE
