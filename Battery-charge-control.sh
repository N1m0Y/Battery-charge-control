#!/system/bin/sh

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

#Internal variables
busybox=/dev/busybox

#Detect variables
UNSUPPORTED=false
[ ! -f $QC ] && [ ! -f $VC ] && UNSUPPORTED=true

# Colors
G='\e[01;32m'
R='\e[01;31m'
N='\e[00;37;40m'
Y='\e[01;33m'
B='\e[01;34m'
V='\e[01;35m'
Bl='\e[01;30m'
C='\e[01;36m'
W='\e[01;37m'

#Functions
convert(){
	#Convert to decimal value
	if [ $1 -lt 10000 ]; then
		x=$($busybox/awk "BEGIN {printf \"%.2f\n\", $1/1000}")
	elif [ $1 -gt 10000 ]; then
		x=$($busybox/awk "BEGIN {printf \"%.2f\n\", $1/1000000}")
	fi
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
echo -e "${G}Battery Charge Control${N}"
echo ""
if $UNSUPPORTED; then
	echo "Your device is unsupported!"
	echo "You can try changing your kernel/ROM\nthat has the necessary files to be supported."
	sleep 2
	exit 1
fi
if [ -f $QC ]; then
	echo -e "${W}Q) QuickCharge enable/disable${N}"
fi
if [ -f $VC ]; then
	echo -e "${W}V) Voltage charge${N}"
fi

echo -n "\n[CHOICE]: "
read -r c
case $c in
	q|Q)
		echo ""
		if [ $(cat $QC) -eq 1 ]; then
			echo -e "${W}QuickCharge actual value:${N} ${G}Enabled${N}"
			echo ""
			echo -e "${W}0) Disable${N}"
			echo "b) Back"
		elif [ $(cat $QC) -eq 0 ]; then
			echo -e "${W}QuickCharge actual value:${N} ${R}Disabled${N}"
			echo ""
			echo -e "${W}1) Enable${N}"
			echo "b) Back"
		fi
		echo -n "\n[CHOICE]: "
		read -r c
		case $c in
			0)
				echo 0 > $QC
				wait_for 2
				if [ $(cat $QC) -eq 0 ]; then
					echo -e "${W}QuickCharge:${N} ${R}Disabled${N}"
				else
					echo "Not applied"
				fi
			;;
			1)
				echo 1 > $QC
				wait_for 2
				if [ $(cat QC) -eq 1 ]; then
					echo -e "${W}QuickCharge:${N} ${G}Enabled${N}"
				else
					echo "Not applied"
				fi
			;;
			b|B)
				exit 1
			;;
			*)
				clear;
				echo "Invalid option, please try again"
				sleep 1
				exit 1
			;;
		esac
	;;
	v|V)
		clear
		vc=$(cat $VC); convert $vc
		echo -e "${W}Actual voltage charge:${N} ${G}V$val${N}"
		echo ""
		echo -e "${W}1) V3,92 53% (Long life battery)${N}"
		echo -e "${W}2) V4,16 80% (middle life battery)${N}"
		if [ -f $DESIGN ]; then
			des=$(cat $DESIGN); convert $des
			echo -e "${W}3) V$val 100% (standard life battery)${N}"
		fi
		echo "b) Back"
		echo -n "\n[CHOICE]: "
		read -r c
		case $c in
			1)
				echo 3920 > $VC
				wait_for 2
				clear
				echo "done"
				sleep 0.5
				clear
				vc=$(cat $VC); convert $vc
				echo -e "${W}Actual voltage charge:${N} ${G}V$val${N}"
			;;
			2)
				echo 4160 > $VC
				wait_for 2
				clear
				echo "done"
				sleep 0.5
				clear
				vc=$(cat $VC); convert $vc
				echo -e "${W}Actual voltage charge:${N} ${G}V$val${N}"
			;;
			3)
				des=$(cat $DESIGN)
				echo $(($des/1000)) > $VC
				wait_for 2
				clear
				echo "done"
				sleep 0.5
				clear
				vc=$(cat $VC); convert $vc
				echo -e "${W}Actual voltage charge:${N} ${G}V$val${N}"
			;;
			b|B)
				exit 1
			;;
			*)
				clear;
				echo "Invalid option, please try again"
				sleep 1
				exit 1
		esac
	;;
	*)
		clear;
		echo "Invalid option, please try again"
		sleep 1
		exit 1
	;;
esac