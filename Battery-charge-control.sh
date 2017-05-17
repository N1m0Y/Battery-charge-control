#!/bin/bash

#################################################################################
# nome	 : Battery Charge Control												#
# autore : N1m0Y and @veez21													#
# anno   : 2017-2018															#
# licenza: questo script è software libero: puoi ridistribuirlo e/o modificarlo	#
#          rispettando i termini della licenza GNU General Public licenses		#
#          stabiliti dalla Free Software Foundation, versione 3.				#
#          Questo script è distribuito nella speranza che possa essere utile,	#
#          ma SENZA ALCUNA GARANZIA.											#
#          Consulta la licenza GNU General Public License per avere ulteriori	#
#          dettagli <http://www.gnu.org/licenses/>. 							#
# Credits: @@@@@																#
#################################################################################

#Global variables
QC=/sys/class/power_supply/battery/le_quick_charge_mode
VC=/sys/class/power_supply/battery/voltage_max
DESIGN=/sys/class/power_supply/battery/voltage_max_design

#Functions
convert(){
	#Convert to decimal value
	x=$(awk "BEGIN {printf \"%.2f\n\", $1/1000}")
	val=$x
}

wait_for(){
	i=1
	while [ $i -lt $(($1+1)) ]; do
		clear;
		echo "|"
		sleep 0.20
		clear;
		echo "/"
		sleep 0.20
		clear;
		echo "-"
		sleep 0.20
		clear;
		echo '\'
		sleep 0.20
		clear;
		echo "$i"
		sleep 0.20
		i=$(($i+1))
	done
}

#Begin
clear;
echo "Battery charge control"
echo ""
if [ -e $QC ]; then
	echo "Q) QuickCharge enable/disable"
fi
echo "V) Voltage charge"

read -r c
case $c in
	q|Q)
		echo ""
		if [ $(cat $QC) -eq 1 ]; then
			echo "QuickCharge actual value: Enable"
			echo ""
			echo "0) Disable"
			echo "b) Back"
		elif [ $(cat $QC) -eq 0 ]; then
			echo "QuickCharge actual value: Disable"
			echo ""
			echo "1) Enable"
			echo "b) Back"
		fi
		read -r c
		case $c in
			0)
				echo 0 > $QC
				wait_for 2
				if [ $QC -eq 0 ]; then
					echo "QuickCharge: Disable"
				else
					echo "Not applied"
				fi
			;;
			1)
				echo 1 > $QC
				wait_for 2
				if [ $QC -eq 1 ]; then
					echo "QuickCharge: Enable"
				else
					echo "Not applied"
				fi
			;;
			b|B)
				exit
			;;
			*)
				clear;
				echo "Invalid option, please try again"
				sleep 1
				exit
			;;
		esac
	;;
	v|V)
		vc=$(cat $VC); convert $vc
		echo "Actual voltage charge: V$val"
		echo ""
		echo "1) V3,92 53% (Long life battery)"
		echo "2) V4,18 80% (middle life battery)"
		des=$(cat $DESIGN); convert $des
		echo "3) V$val (standard life battery)"
		echo "b) Back"
		read -r c
		case $c in
			1)
				echo 3920 > $VC
				wait_for 2
				clear
				echo "done"
				sleep 0.5
				clear
				val=$(cat $VC); convert $val
				echo "Actual voltage charge: V$val"
			;;
			2)
				echo 4180 > $VC
				wait_for 2
				clear
				echo "done"
				sleep 0.5
				clear
				val=$(cat $VC); convert $val
				echo "Actual voltage charge: V$val"
			;;
			3)
				echo $DESIGN > $VC
				wait_for 2
				clear
				echo "done"
				sleep 0.5
				clear
				val=$(cat $VC); convert $val
				echo "Actual voltage charge: V$val"
			;;
			b|B)
				exit
			;;
		esac
	;;
	*)
		clear;
		echo "Invalid option, please try again"
		sleep 1
		exit
	;;
esac