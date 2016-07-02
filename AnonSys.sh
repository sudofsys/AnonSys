#!/bin/bash

vert='\e[1;32m'
rouge='\e[1;31m'
bleu='\e[1;34m'
neutre='\e[0;m'
blanc='\e[0;37m'
jaune='\e[1;33m'

sysctl -p

# PATH OF OPENVPN CONF FILE
vpnconfpath="/root/Bureau/Docs/OpenVPN/CONF/"

# PATH OF vpn auth
vpnauthpath="/root/Bureau/Docs/OpenVPN/up"

# PATH OF CONNEXIONS LOGS for TAIL !
logs="/root/Bureau/Docs/Scripts/Fsys/AnonSys/AnonSys.log"

# PATH OF ANONSYS SCRIPT !
anonsyspath="/root/Bureau/AnonSys.sh"

IndicVPN=""
#TEST APRES MENU

IndicV6=""
#TEST APRES NETWORK



MainMenu(){

#https://funoverip.net/2010/11/socks-proxy-servers-scanning-with-nmap/ CREER SES PROPRES PROXY !!
clear
echo -e "${vert}Fsys AnonSys V1.0 ----------------------------------------------${blanc}"
echo -e "\n------ Anon Degree Choice"
echo -e "\n What will we do Bro ?"

echo -e " \n <1>    MAC Adress Spoof"
echo -e " <2>    VPN & Switch Kill Process !"
echo -e " <3>    TOR & Multiproxy Launch "
echo -e " <4>    TOR 1 NODE "
echo -e " <5>    -- NINJA MODE VPN"
echo -e " <6>    -- NINJA MODE TOR"
echo -e "\n <0>    Go to the Anon (P)anel :)"
echo

read -p "Enter your choice to hide your ass (or go away entering q) : " choix

case $choix in

0)	Panel;;
p)	Panel;;

1)	MAC 1;;

2)	VPN;;

3)	TORVPN;;

4)	TORVPNPROX;;

5)	FULL;;

6)	NINJA;;

q) exit;;
*) echo "Incorrect Choice -- Try Again ;)";;
esac
}

Install()
{
echo -e "${rouge}\nERROR : Please install all the packages before launching AnonSys.\n${blanc}"
echo "Do you want to install all the package needed to run AnonSys right now ?"
read -p "Yes / No (Y/N) : " rep 
case $rep in
Y | y)	echo "------ Installation des paquets"
	apt-get install tor network-manager-openvpn macchanger network-manager-vpnc-gnome network-manager-vpnc network-manager-strongswan network-manager-pptp-gnome network-manager-pptp network-manager-openvpn-gnome tor-geoipdb speedometer
	clear
	echo -e "All Package installed. Please launch AnonSys again !";;

N | n)	echo "Ok ! See U then !"
	exit;;
*)	echo "You Failed in Y/N question...."
	exit;;
q)	exit;;
esac
}

CheckSoft()
{
echo
echo -e "${blanc}------ Checking all the softs${blanc}"

soft="vrai"

[[ -z `dpkg --get-selections | grep -w ^tor[^-]` ]] && echo -e "${rouge}ERROR : Tor not installed." && soft="uninstall"

[[ -z `dpkg --get-selections | grep -w ^tor-geoipdb[^-]` ]] && echo -e "${rouge}ERROR : tor-geoipdb not installed." && soft="uninstall"


[[ -z `dpkg --get-selections | grep -w ^network-manager-openvpn[^-]` ]] && echo -e "${rouge}ERROR : OpenVPN not installed." && soft="uninstall"

[[ -z `dpkg --get-selections | grep -w ^macchanger[^-]` ]] && echo -e "${rouge}ERROR : MACCHANGER not installed." && soft="uninstall"

[[ -z `dpkg --get-selections | grep -w ^network-manager-openvpn-gnome[^-]` ]] && echo -e "${rouge}ERROR : network-manager-openvpn-gnome not installed." && soft="uninstall"

[[ -z `dpkg --get-selections | grep -w ^network-manager-pptp[^-]` ]] && echo -e "${rouge}ERROR : network-manager-pptp not installed." && soft="uninstall"

[[ -z `dpkg --get-selections | grep -w ^network-manager-pptp-gnome[^-]` ]] && echo -e "${rouge}ERROR : network-manager-pptp-gnome not installed." && soft="uninstall"

[[ -z `dpkg --get-selections | grep -w ^network-manager-strongswan[^-]` ]] && echo -e "${rouge}ERROR : network-manager-strongswan not installed." && soft="uninstall"

[[ -z `dpkg --get-selections | grep -w ^network-manager-vpnc[^-]` ]] && echo -e "${rouge}ERROR : network-manager-vpnc not installed." && soft="uninstall"

[[ -z `dpkg --get-selections | grep -w ^network-manager-vpnc-gnome[^-]` ]] && echo -e "${rouge}ERROR : network-manager-vpnc-gnome not installed." && soft="uninstall"

[[ -z `dpkg --get-selections | grep -w ^speedometer[^-]` ]] && echo -e "${rouge}ERROR : speedometer not installed." && soft="uninstall"


if [ $soft = "uninstall" ]; then
	Install
else
	echo -e "${blanc}Soft Ok -- We go on."
fi


}

Panel()
{

if=`ifconfig $net`

ip6=`echo "$if" | grep "inet6"`

if [ "$ip6" = "" ]
then 
IndicV6="${vert}DISABLED${blanc}"
else
IndicV6="${rouge}ENABLED${blanc}"
fi
	
clear

#echo -e "\nPlease wait for Panel Loading........."

MAC=`macchanger $net`

VMAC=""

FAKEMAC=`ip link show $net | awk '/ether/ {print $2}'`

if [ "$FAKEMAC" = "$MACINIT" ]

then

VMAC=${rouge}
VMAC2=" ${jaune}--- Same MAC Adress !"

else

VMAC=${vert}
VMAC2=""

fi



FAKEIP=`wget -qO- ipinfo.io/ip`

TOR=""

VIP=""

#clear

if [ "$FAKEIP" = "$IPVRAI" ]

then

VIP=${rouge}

else VIP=${vert}

fi

echo -e "${vert}Fsys AnonSys V1.0 ----------------------------------------------${blanc}"
echo -e "\n------ Anonimity Panel Checker"
echo -e "\nNetwork Device Tweak : ${vert}$net${blanc}"
echo -e "IPV6 Service : $IndicV6"
echo -e "\nIP Initiale    : ${vert}$IPVRAI${blanc}"
echo -e "FAKE FINALE IP : $VIP$FAKEIP${blanc}"
echo
echo -e "------ Mac Spoofing $VMAC2"
echo -e "$VMAC$MAC${blanc}"
echo
echo "------ Web Anon Routing & Crypto"
echo
echo -e "VPN : $IndicVPN		MULTIPROXY  :"
echo -e "TOR :			FINAL PROXY :"
echo
echo

read -p "Press [Enter] to refresh this Panel, [m] for Menu, [q] for Quit.." Pchoice

case $Pchoice in

" ")	Panel;;

"")	Panel;; 

m)	MainMenu;;

M)	MainMenu;;

q)	exit;;

Q)	exit;;

*)	echo
	echo "Incorrect Choice ! Try Again ! ;)"
	sleep 1 
	Panel;;
esac


}

NETWORKGET()
{
echo -e "\n------ Network Interface Scan"
echo
echo `nmcli --terse --fields DEVICE,STATE dev status`
echo

network=`nmcli --terse --fields DEVICE,STATE dev status`

net1=${network%%":conn"*}
net=${net1##*" "}


echo -e "Active network Device found : ${vert}$net${blanc}"
sleep 1
echo -e "\nConnectivity verification on $net"

echo `ethtool $net | grep Link`
statut=`cat /sys/class/net/$net/operstate`
echo -e "$net network statut : $statut"

if [ $statut = "up" ]
then 
echo -e "\n------ Anon Sys ready to work on ${vert}$net${blanc}"
echo

else 
echo -e "\nVerification Statut on $net didn't work.."
read -p "Please give us the device you want to try to work on by tapping is name (CARREFULLY) :" net
	if [ "$net" = "" ]
	then echo "Error in your Networking Device. Exiting."
	sleep 1
	exit
	else 
	echo -e "\n------ Anon Sys ready to work on ${vert}$net${blanc}"
	
	fi
fi

#if=`ifconfig $net`

#ip6=`echo "$if" | grep "inet6"`
ip6=`grep "net.ipv6.conf.all.disable_ipv6 = 1" /etc/sysctl.conf`

if [ "$ip6" = "" ]
	then 
	echo -e "\n${rouge}BE CAREFULL ! ${blanc}Your IPV6 is activated so your IP can be leak" 
	echo "when you will do things i don't want to know..."
	echo
	read -p "Do you want to disabled IPV6 right now ? (Y/N) :" V6C
	
	case $V6C in

	[yY])	echo -e "\nnet.ipv6.conf.all.disable_ipv6 = 1 \\
		\nnet.ipv6.conf.default.disable_ipv6 = 1 \\
		\nnet.ipv6.conf.lo.disable_ipv6 = 1" >> /etc/sysctl.conf

		sysctl -p

		echo -e "\n${vert}IPV6 Disabled...! ${blanc}You start the anon way already ;)..."
		echo
		sleep 2;;

	[nN])	echo -e "\nIPV6 Enabled ! ${rouge}BE CAREFULL ! YOU WILL NEVER BE ANON !${blanc} "
			IndicV6="${rouge}ENABLED${blanc}";;

	*)	echo
		echo "Incorrect Choice ! Try Again ! ;)"
		NETWORKGET
	esac

	else 
	IndicV6="${vert}DISABLED${blanc}"
	echo -e "------ Anon ++ with ${vert}IPV6 DISABLED on $net${blanc}"
	echo
	sleep 2

	fi

# Test VPN Actif ou non

#running=$(ps -e | grep openvpn)
#VPtest=`echo "$running" | wc -l`
VPtest=$(ifconfig | grep tun)

if [ "$VPtest" = "" ]; then
    IndicVPN="${jaune}NO ACTIVE SESSION${blanc}"

else echo "WARNING ! Active VPN Session discovered...!"
echo "To go on, we will kill this Session ..."
read -p "Are you ok ? (Y/N)" KC

case $KC in

[yY])	echo -e "\n${rouge}Killing the last VPN Session ! Stop all your evil Stuff !${blanc}"
			service network-manager restart
			ifconfig tun0 down
			ifconfig tun1 down
			ifconfig tun2 down
			ifconfig tun3 down
			echo " Please Wait until killing process and reconnecting end. Around 15s ..."
			sleep 15
		NETWORKGET
		;;

[nN])	echo -e "\n ${rouge}So, we can not go on. Bye.${blanc} "
			exit;;

	*)	echo
		echo "Incorrect Choice ! Try Again ! ;)"
		NETWORKGET;;
	esac
	
fi
IPVRAI=`wget -qO- ipinfo.io/ip`
}

MAC()
{
clear
echo -e "${vert}Fsys AnonSys V1.0 ----------------------------------------------${blanc}"
echo -e "\n------ Anon Sys Mac Spoofing"

#Macstate=`macchanger -s $net`

#Affichage des adresses initiales

echo -e "\n${vert}$Macstate${blanc}"

echo -e "\n-- Mac Spoofing Menu --"


echo -e "\n<1>    Same Vendor Fake Mac Adress"
echo -e "<2>    Same Interface Fake Mac Adress"
echo -e "<3>    Other Interface Fake Mac Adress"
echo -e "<4>    Random Fake Mac Adress"
echo -e "<5>    Input Fake Mac Adress"
echo -e "<6>    Vendor Listing for Fake Mac Adress"
echo
echo -e "${bleu}Please note that MAC Spoofing depends on your hardware and it may not work.."
echo -e "Please check if MAC Spoofing work before doing Bad Things...${blanc}"
echo
read -p "Please make your choice for this Crazy Evil Spoofing ;) (q for exit) : " chmac

case $chmac in

1)	echo -e "\n------ Anon Mac Same Vendor :"
	echo -e "Putting $net down"
	echo -e `ifconfig $net down`
	echo -e "Setting new MAC Address"
	FAKEMAC=`macchanger --endding $net`
	echo -e "Putting $net up"
	echo -e `ifconfig $net up`

	echo -e "\n${vert}$FAKEMAC${blanc}"

	sleep 2

	echo -e "\nPlease wait $net new connection. This will be done in few seconds...."
	echo
	
	count=1
	while [ "$test" = "" ]

	do

	test=`wget -qO- ipinfo.io/ip`
	echo "Connection Test on $net"
	sleep 1

	done
	test=""
	
	if [ "$1" = "1" ]
	then 
	Panel
	fi;;


2)	echo -e "\n------ Anon Mac Same Interface Othe Vendor :"

	echo -e "Putting $net down"
	echo -e `ifconfig $net down`
	echo -e "Setting new MAC Address"
	FAKEMAC=`macchanger --another $net`
	echo -e "Putting $net up"
	echo -e `ifconfig $net up`

	echo -e "\n${vert}$FAKEMAC${blanc}"
	
	sleep 2
	
	echo -e "\nPlease wait $net new connection. This will be done in few seconds...."
	echo
	
	while [ "$test" = "" ]
	
	do
	
	test=`wget -qO- ipinfo.io/ip`
	echo "Connection Test on $net"
	sleep 1
	
	done
	test=""

	if [ "$1" = "1" ]
	then 
	Panel
	fi;;

3)	echo -e "\n------ Anon Mac Other Interface:"

	echo -e "Putting $net down"
	echo -e `ifconfig $net down`
	echo -e "Setting new MAC Address on Other Interface"
	FAKEMAC=`macchanger -A $net`
	echo -e "Putting $net up"
	echo -e `ifconfig $net up`
	
	echo -e "\n${vert}$FAKEMAC${blanc}"
	
	sleep 2
	
	echo -e "\nPlease wait $net new connection. This will be done in few seconds...."
	echo
	
	while [ "$test" = "" ]
	
	do
	
	test=`wget -qO- ipinfo.io/ip`
	echo "Connection Test on $net"
	sleep 1
	
	done
	test=""

	if [ "$1" = "1" ]
	then 
	Panel
	fi;;

4)	echo -e "\n------ Anon RANDOM Mac :"

	echo -e "Putting $net down"
	echo -e `ifconfig $net down`
	echo -e "Randomize and Setting new MAC Address"
	FAKEMAC=`macchanger -r -b $net`
	echo -e "Putting $net up"
	echo -e `ifconfig $net up`
	
	echo -e "\n${vert}$FAKEMAC${blanc}"
	
	sleep 2
	
	echo -e "\nPlease wait $net new connection. This will be done in few seconds...."
	echo
	
	while [ "$test" = "" ]
	
	do
	
	test=`wget -qO- ipinfo.io/ip`
	echo "Connection Test on $net"
	sleep 1
	
	done
	test=""

	if [ "$1" = "1" ]
	then 
	Panel
	fi;;

5)	echo -e "\n------ Anon INPUT MAC:"
	echo -e"\nPlease Input the new mac adress you want on $net."
	read -p "Remember , MAC ADRESS must be as XX:XX:XX:XX:XX:XX     :" Fmac
	
	echo -e "Putting $net down"
	echo -e `ifconfig $net down`
	echo -e "Setting new MAC Address on Other Interface"
	FAKEMAC=`macchanger --mac=$Fmac $net`
	echo -e "Putting $net up"
	echo -e `ifconfig $net up`
	
	echo -e "\n${vert}$FAKEMAC${blanc}"
	
	sleep 2
	
	echo -e "\nPlease wait $net new connection. This will be done in few seconds...."
	echo
	
	while [ "$test" = "" ]
	
	do
	
	test=`wget -qO- ipinfo.io/ip`
	echo "Connection Test on $net"
	sleep 1
	
	done
	test=""

	if [ "$1" = "1" ]
	then 
	Panel
	fi;;

6)	echo " TO DO LIST !!";;

q)	exit;;

Q)	exit;;

*)	echo "Incorrect Choice ! Try Again ! ;)"
	sleep 1 
	MAC $1;;
esac

}

PROXVPN () {


echo -e "\n------ Anon VPN Mode"
echo
echo -e "\nSearch for VPN Configurations"

List=`ls $vpnconfpath`
Listfi=`echo $List | sed s/'.ovpn'/''/g`

#echo $List

echo
#echo $Listfi

wd=$(echo $Listfi | wc -w)

echo -e "\n${vert}$wd${blanc} VPN possibilities found."
echo

if [ "$wd" -eq 0 ];
then MainMenu
fi

VpnChoice=( $Listfi )



let "num = $RANDOM % $wd +1" 
let "num = num - 1"

VPNID=${VpnChoice[$num]}

echo -e "Connecting to ${vert}$VPNID${blanc}"

echo -e "\n------ Proxy Socks Gate List Updating right now"


prox1=`wget -qO- https://www.socks-proxy.net/`

proxA=${prox1##*"<th>Last Checked</th>
</tr>
</thead>
<tbody>"}


proxB=${proxA%%"</tbody>
<tfoot>
<tr>"*}


un=${proxB//'</td><td>'/' '}
deux=${un//'</td></tr>'/'\n'}

prox=${deux//'<tr><td>'/''}

echo -e "FRESH Proxy ANON List -- Extracted and cleaned"
nbligne=`echo "$prox" | wc -l`

let "numprox = $RANDOM % $nbligne +1" 
let "numprox = numprox - 1"

if [ "$numprox" -eq 0 ]; then
numprox = 1
fi

Pline=`echo "$prox" | sed -n ${numprox}p`

IProx=${prox1##*"<th>Last Checked</th>
</tr>
</thead>
<tbody>"}

tab=( $Pline )

PIP=${tab[0]}
Pport=${tab[1]}

echo
echo -e "Proxy Adress Choose :"
echo -e ${vert}$Pline${blanc}
echo
sleep 3

echo -e "\n------ VPN and Sock Proxy initializing !"


#########################################################
#xterm -q openvpn --config $vpnconfpath$VPNID.ovpn --auth-user-pass $vpnauthpath --socks-proxy $PIP $Pport &

#screen -dmS ANONSYSVPN sh
#screen -S ANONSYSVPN -X stuff "openvpn --config $vpnconfpath$VPNID.ovpn --auth-user-pass $vpnauthpath --socks-proxy $PIP $Pport
#"

openvpn --config $vpnconfpath$VPNID.ovpn --auth-user-pass $vpnauthpath --socks-proxy $PIP $Pport > $logs 2>&1 &

echo -e "openvpn --config $vpnconfpath$VPNID.ovpn --auth-user-pass $vpnauthpath --socks-proxy $PIP $Pport"
sleep 15
}

VPN()
{
#IPTABLES !!!

clear
echo -e "${vert}Fsys AnonSys V1.0 ----------------------------------------------${blanc}"
echo -e "\n------ Anon Sys VPN"
echo
echo
echo -e "-- VPN Option Menu --"
echo
echo "<1>    VPN & Public Proxy !! "
echo "--------- < VPN FILES MUST BE READY ! >"
echo "<2>    VPN & PRIVATE PROXY !! "
echo "--------- < VPN FILES & PROXY LIST MUST BE READY ! >"
echo "<3>    Auto VPN with Kill Switch"
echo "--------- < VPN must be configure in Network manager !>"
echo
echo "<4>    Choosen VPN with Kill Switch"
echo
echo "<*>    Tape your favorite VPN SPOT"
echo
echo "<h>    Help for Noobs"
echo
read -p "VPN Option to do : " Vpnchoice

case $Vpnchoice in

1)	
##########################################" <1>    VPN & Public Proxy !! 
#nmcli con up id "Nom de la connection" << Lance la co
#nmcli con << Liste les co
#Objectif : Lister les co dans variable ou fichier texte puis trier les co vpn et ensuite choisir une co vps selon un nombre random !
#
#Ensuite changer une variable de vérif VPN pour panel :)

PROXVPN

echo
echo " Checking the Connexion quality"
sleep 1
echo
echo "Checking the new IP adress"
echo
NEWIP=`wget -qO- ipinfo.io/ip`
echo -e "\nThe new IP Adress is ${vert}$NEWIP${blanc}"
echo
echo "Comparing New IP to Old One...."

sleep 1

if [ "$NEWIP" = "$IPVRAI" ]

	then

	echo -e "${rouge}ERROR ! VPN seems not active..."
	echo
	echo -e "New IP : $NEWIP // Old IP : $IPVRAI ${blanc}"

	read -p "Tap [Enter] to retry" t
	
	NEWIP=`wget -qO- ipinfo.io/ip`

	echo "Comparing New IP to Old One...."

	sleep 1

		if [ "$NEWIP" = "$IPVRAI" ]

		then

		echo -e "${rouge}ERROR ! VPN seems not active..."
		echo
		echo -e "New IP : $NEWIP // Old IP : $IPVRAI ${blanc}"

		read -p "This don't work today ? Try again [ENTER] // Quit to Main Menu (q)" t

########## TMUX

		#$tsess=`tmux ls | grep : | cut -d. -f1 | awk '{print substr($1, 0, length($1))}' | xargs`

		#tmux kill-session -t $tsess

		#exit
			if [ "$t" = "q" ]; 

				then MainMenu
				else
				PROXVPN
			fi
		fi

	else 

	echo -e "${vert}YEaH ! VPN is ACTIVE !"
	echo
	echo -e "New IP : $NEWIP // Old IP : $IPVRAI ${blanc}"

sleep 3

IndicVPN="${vert}RUNNING${blanc}"

Panel
fi
;;

2)	

########################################## <2>    VPN & PRIVATE PROXY !!  
tartVPN 2;; 

3) 

##########################################           Auto VPN with Kill Switch 
;;

[hH]) 

echo -e "\n${bleu}Please note that to use this VPN Options, your OpenVPN must be " 
echo -e "configured with your own username, passwd and gateway..."
echo
echo -e "Please check the script beginning to change the path of your files.${blanc}"
;;

q)	exit;;

Q)	exit;;

*)	echo "Incorrect Choice ! Try Again ! ;)"
	sleep 1 
	VPN;;
esac
}

TORVPN()
{
# TOR + PROXYCHAIN
# Pour eviter les nodes exit unsafe on va lister les nodes privés et les rentrer dans le fichier de conf de proxychain
# TorBulkExitList
echo "TORVPN SAMERE"
}


MAIN () {
#MAIN PROG
clear
echo -e "${vert}                                _____             "
echo -e '     /\                        / ____|            '
echo -e "${vert}    /  \   _ __   ___  _ __   | (___  _   _ ___   "
echo -e "${vert}   / /\ \ | '_ \ / _ \| '_ \   \___ \| | | / __|  "
echo -e "${vert}  / ____ \| | | | (_) | | | |  ____) | |_| \__ \_ "
echo -e "${vert} /_/    \_\_| |_|\___/|_| |_| |_____/ \__, |___(_)"
echo -e "${vert}                                       __/ |      "
echo -e "${vert}                                      |___/       "
echo -e "${vert}-------------FSys Anon System v1.0---------------"



CheckSoft



echo -e "${blanc}------ Internet connection checking${blanc}"
echo -e "GET http://google.com HTTP/1.0\n\n" | nc google.com 80 > /dev/null 2>&1

if [ $? -eq 0 ]; then
	echo -e "Internet Status : ${vert}ONLINE${blanc}"
	IPVRAI=`wget -qO- ipinfo.io/ip`
	echo -e "Public Adress Before AnonSys : ${vert}$IPVRAI${blanc}"

else
	echo -e "${rouge}\nError : No connection find. Please connect to internet.\n ${blanc}"
	exit
fi

NETWORKGET

#MACINIT=`macchanger $net -p`
MACINIT=`ip link show $net | awk '/ether/ {print $2}'`
tmux select-pane -t 1  
tmux send-keys "speedometer -r $net" C-m  
tmux select-pane -t 0  
MainMenu
}




# MAIN SCRIPT !
printf '\e[8;31;107t'

if [ "$1" = "-t" ] 

then 

MAIN

else

killall tmux

tmux start-server 


tmux new-session -d -s AnonSys

#tmux select-windows -t AnonSys:0

tmux split-window -h -p 35 -tAnonSys
tmux select-pane -t 0  
tmux split-window -v -p 25 -tAnonSys
tmux select-pane -t 0  
tmux send-keys "$anonsyspath -t" C-m  
tmux select-pane -t 2
tmux send-keys "less +F $logs" C-m  

tmux attach-session -d

fi




