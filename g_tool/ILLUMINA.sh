#!/bin/ksh

/mnt/raid/Workspace/WorXX/g_tool/g_go.sh \
-p ILLUMINA \
-s /mnt/raid/Workspace/WorXX/Prijem \
-t /mnt/raid/Workspace/WorXX \
-r XX \
-f /mnt/raid/Workspace/WorXX/Linky \
-z CONF \
-b 10 \
-e 120 \
$@ 

/mnt/raid/Workspace/WorXX/g_tool/g_go.sh \
-p ILLUMINA \
-s /mnt/raid/Workspace/WorXX/Prijem \
-t /mnt/raid/Workspace/WorXX \
-r XX \
-f /mnt/raid/Workspace/WorXX/Linky \
-z CONF \
-b 130 \
-e 135 \
$@ 

/mnt/raid/Workspace/WorXX/g_tool/g_go.sh \
-p ILLUMINA \
-s /mnt/raid/Workspace/WorXX/Prijem \
-t /mnt/raid/Workspace/WorXX \
-r XX \
-f /mnt/raid/Workspace/WorXX/Linky \
-z CONF \
-b 140 \
-e 260 \
$@ 
