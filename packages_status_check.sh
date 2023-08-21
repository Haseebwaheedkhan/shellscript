#!/bin/bash


# Check if the argument is provided
if [ -z "$1" ]; then
    echo "Please provide a package list type as an argument: DB, CS, SS, API, or MON"
    exit 1
fi

# Remove whitespace characters from the argument
package_list_type=$(echo "$1" | tr -d '[:space:]')


# Check the package list type and set the corresponding packages array
case $package_list_type in
    "DB")
        packages=("htop"	"iotop"	"net-tools"	"nload"	"tcpdump"	"openssl"	"vim"	"byobu"	 "ifenslave"	"keepalived"	"galera-4"	"mysql-wsrep-8.0" "libglib2.0-0"	"openssh-server"	"ntp"	"parted"  "mysql-wsrep-server" "mysql-client" "mysql-wsrep-client" "mysql-common"
        )
        ;;
    "CS")
        packages=("htop"	"iotop"	"net-tools"	"nload"	"tcpdump"	"openssl"	"vim"	"byobu"	"ifenslave"	"build-essential"	"default-libmysqlclient-dev"	"libvorbis-dev"	"libpcap-dev"	"unixodbc-dev"	"libsnappy-dev"	"librrd-dev"	"libxml2-dev"	"libglib2.0-dev"	"liblzma-dev"	"liblzo2-dev"	"libjson-c-dev"	"libssh-dev"	"libcurl4-openssl-dev"	"libpng-dev"	"libgcrypt20-dev"	"libfftw3-dev"	"libgoogle-perftools-dev"	"keepalived"	"openssh-server"	"numactl"	"ntp"	"parted"	"vim"
        )
        ;;
    "SS")
        packages=( "htop"	"iotop"	"net-tools"	"nload"	"tcpdump"	"openssl"	"vim"	"byobu"	"ifenslave"	"build-essential"	"default-libmysqlclient-dev"	"libvorbis-dev"	"libpcap-dev"	"unixodbc-dev"	"libsnappy-dev"	"librrd-dev"	"libxml2-dev"	"libglib2.0-dev"	"liblzma-dev"	"liblzo2-dev"	"libjson-c-dev"	"libssh-dev"	"libcurl4-openssl-dev"	"libpng-dev"	"libgcrypt20-dev"	"libfftw3-dev"	"libgoogle-perftools-dev"	"keepalived"	"openssh-server"	"numactl"	"ntp"	"parted"
        )
        ;;
    "API")
        packages=("htop" "iotop" "net-tools" "nload" "tcpdump" "libpcap" "openssl" "vim" "byobu" "keepalived" "php" "tshark" "openssh-server" "ntp" "parted" "pigz" "nfs-kernel-server" "nfs-common" "ifenslave"    "node"    "Promtail"    "libapache2-mod-php7.4"     "php7.4-fpm"    "php7.4-mbstring"     "php7.4-gd"    "php7.4-mysql"     "php7.4-zip"    "php-cli"    "php"    "librsvg2-bin"    "gsfonts"    "rrdtool"    "libtiff-tools"    "mtr" "npx"  "xzutils")
        ;;
    "MON")
        packages=("htop"	"iotop"	"net-tools"	"nload"	"tcpdump"	"libpcap"	"openssl"	"vim"	"byobu"	"keepalived"	"php"	"tshark"	"openssh-server"	"ntp"	"parted"	"pigz"
        )
        ;;
    *)
        echo "Invalid package list type. Available options: DB, CS, SS, API, or MON"
        exit 1
        ;;
esac 

error_status=""
# Loop through the array and find the versions
for package in "${packages[@]}"; do

        if [ "$(dpkg -s $package 2>/dev/null |  grep 'Status: install ok installed')" == 'Status: install ok installed' ]; then
                echo -e "\n$package installation Status = Installed Successfully"

        else
                RED='\033[41m'
                NC="\033[0m"
                echo -e "\n${RED}$package installation Status = ${RED}Issue Found${NC}"
                error_status=$error_status"\n$package"
        fi
done

kernel_version=$(uname -r)
if [ "$kernel_version" == "5.10.0-19-amd64" ]; then
    echo Kernel Version = Correct
else
        RED='\033[41m'
        NC="\033[0m"
        echo -e "\n${RED}Kernel Version  = ${RED}Issue Found (Current Version: $kernel_version | Required: 5.10.0-19-amd64)${NC}"
        error_status=$error_status"\nKernel Version"
fi


if [ $(echo -n "$error_status" | wc -m) -eq 0 ]; then
        echo -e "\n\n\n
        *****************************************************
        ****** All Packages are installed Successfully ******
        *****************************************************"
else
        echo -e "\nError Found in following packages\n$error_status"
fi