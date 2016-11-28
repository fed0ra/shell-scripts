#!/bin/bash
#Date:          2014-07-29
#Author:        Created by Boomer
#Mail:          990370200@qq.com
#Function:      This script is...
#Version:       1.0

#source function library
. /etc/init.d/functions

char_color(){

BLACK_COLOR='\E[1;30m'
RED_COLOR='\E[1;31m'
GREEN_COLOR='\E[1;32m'
YELOW_COLOR='\E[1;33m'
BLUE_COLOR='\E[1;34m'
PINK_COLOR='\E[1;35m'
SKY_COLOR='\E[1;36m'
WHITE_COLOR='\E[1;37m'
RES='\E[0m'

if [ $# -ne 2 ];then
 echo "Usage $0 chars color"
 exit 1
fi

a="$1"
b="$2"
case "$2" in
 red|RED)
  echo -e "${RED_COLOR}---$1---${RES}"
;;
 yellow|YELLOW)
  echo -e "${YELOW_COLOR}---$1---${RES}"
;;
 blue|BLUE)
  echo -e "${BLUE_COLOR}---$1---${RES}"
;;
 green|GREEN)
  echo -e "${GREEN_COLOR}---$1---${RES}"
;;
 *)
  echo -e "${PINK_COLOR}---$1---${RES}"
;;
esac
}


sys_fun(){
SETCOLOR_NORMAL="echo -en \\033[1;32m"
SETCOLOR_SUCCESS="echo -en \\033[1;31m"
SETCOLOR_FAILURE="echo -en \\033[1;33m"
SETCOLOR_WARNING="echo -en \\033[1;39m"
echo "---白-正常---" && $SETCOLOR_NORMAL
echo "---绿-成功---" && $SETCOLOR_SUCCESS
echo "---红-失败---" && $SETCOLOR_FAILURE
echo "---黄-警告---" && $SETCOLOR_WARNING
}

color_chars(){
	BLACK_COLOR='\E[1;30m'
	RED_COLOR='\E[1;31m'
	GREEN_COLOR='\E[1;32m'
	YELOW_COLOR='\E[1;33m'
	BLUE_COLOR='\E[1;34m'
	PINK_COLOR='\E[1;35m'
	SKY_COLOR='\E[1;36m'
	WHITE_COLOR='\E[1;37m'
	RES='\E[0m'

	if [ $# -ne 2 ];then
		echo "Usage $0 chars color"
		exit 1
	fi

	a="$1"
	b="$2"
	case "$2" in
		black|BLACK)
			echo -e "${BLACK_COLOR}$1${RES}"
		;;
		red|RED)
			echo -e "${RED_COLOR}$1${RES}"
		;;
                green|GREEN)
                        echo -e "${GREEN_COLOR}$1${RES}"
                ;;
		yellow|YELLOW)
			echo -e "${YELOW_COLOR}$1${RES}"
		;;
		blue|BLUE)
			echo -e "${BLUE_COLOR}$1${RES}"
		;;
		pink|PINK)
			echo -e "${PINK_COLOR}$1${RES}"
		;;
        	sky|SKY)
                	echo -e "${SKY_COLOR}$1${RES}"
	        ;;
 		*)
			echo -e "${WHITE_COLOR}$1${RES}"
		;;
	esac
}
color_chars ming red
color_chars ming fe

sys_fun
