#!/bin/bash

global_base=""

readonly DEBIAN="debian"
readonly FEDORA="fedora"
readonly REDHAT="redhat"
readonly ARCH="arch"
readonly SUSE="suse"
readonly OTHER="other"
readonly UNKNOWN="unknown"

function linux_base {
  #!/bin/bash

  if [ -f /etc/os-release ]; then
    source /etc/os-release
    case "$ID" in
    "ubuntu" | "linuxmint" | "zorin" | "kubuntu" | "pop" | "elementary" | "ubuntu-mate" | "lxqt" | "xubuntu")
      global_base="$DEBIAN"
      ;;
    "debian" | "devuan")
      global_base="$DEBIAN"
      ;;
    "fedora")
      global_base="$FEDORA"
      ;;
    "centos" | "rhel")
      global_base="$REDHAT"
      ;;
    "arch" | "manjaro" | "endeavouros" | "arcolinux")
      global_base="$ARCH"
      ;;
    "kali")
      global_base="$DEBIAN"
      ;;
    "redhat" | "oracle" | "amzn")
      global_base="$REDHAT"
      ;;
    "opensuse" | "sle")
      global_base="$SUSE"
      ;;
    "tails")
      global_base="$DEBIAN"
      ;;
    "mx" | "antix" | "mageia" | "vanilla" | "pclinuxos" | "deepin")
      global_base="$OTHER"
      ;;
    *)
      global_base="$UNKNOWN"
      ;;
    esac
  else
    global_base="$UNKNOWN"
  fi
}

function echo_purple {
  echo -e "\e[35m$1\e[0m"
}

function echo_green_bold {
  echo -e "\e[1;32m$1\e[0m"
}

function echo_blue {
  echo -e "\e[34m$1\e[0m"
}

function echo_blue_bold {
  echo -e "\e[1;34m$1\e[0m"
}

function echo_yellow {
  echo -e "\e[33m$1\e[0m"
}

function echo_yellow_bold {
  echo -e "\e[1;33;33m$1\e[0m"
}

function echo_pink {
  echo -e "\e[95m$1\e[0m"
}

function echo_red {
  echo -e "\e[91m$1\e[0m"
}

function echo_red_bold {
  echo -e "\e[1;91m$1\e[0m"
}

function echo_green {
  echo -e "\e[32m$1\e[0m"
}

function check_resolvconf {
  if command -v resolvconf &>/dev/null; then
    echo_green "resolvconf is installed."
  else
    sudo apt install -y resolvconf
  fi
}

function display_menu {
  echo "Please select an option:"
  echo_purple "0. Exit From Script"
  echo_blue "1. Install Essential Items"
  echo_yellow "2. Set Dns(For Servers Iran)"
  echo_pink "3. Change Repository 'ir' From sources list"
  echo_green "4. enable ssh for root"
  echo_blue "5. change password root"
  echo_purple "6. change ssh port"
}

function install_essential_items {
  # set dns for update & upgrade and install apps
  dns_servers=("10.202.10.202" "10.202.10.102")
  echo -e "nameserver ${dns_servers[0]}\nnameserver ${dns_servers[1]}" | sudo tee /etc/resolv.conf >/dev/null
  sudo apt update
  sudo apt upgrade -y
  sudo apt install -y nano htop neofetch resolvconf git build-essential g++ vim ranger
}

function menu_set_dns {
  check_resolvconf

  while true; do
    echo "Please select DNS configuration:"
    echo_green "0. back to home menu"
    echo_blue "1. 403 online"
    echo_purple "2. shecan"
    echo_yellow "3. host iran"

    read -p "Enter your choice (0-3): " choice

    case $choice in
    0)
      echo
      echo_green_bold "Returning to the main menu."
      echo
      return
      ;;
    1) set_dns_403 ;;
    2) set_dns_shecan ;;
    3) set_dns_host_iran ;;

    esac
  done
}

function set_dns_403 {
  # set dns to resolv
  dns_servers=("10.202.10.202" "10.202.10.102")
  echo -e "nameserver ${dns_servers[0]}\nnameserver ${dns_servers[1]}" | sudo tee /etc/resolv.conf >/dev/null
  # set dns to resolv.conf.d/head
  echo "nameserver 10.202.10.202" | sudo tee -a /etc/resolvconf/resolv.conf.d/head
  echo "nameserver 10.202.10.102" | sudo tee -a /etc/resolvconf/resolv.conf.d/head
  sudo resolvconf -u
  sudo systemctl restart resolvconf.service
  sudo systemctl restart systemd-resolved.service
  echo_green "DNS settings updated and services restarted."
}

function set_dns_shecan {
  # set dns to resolv
  dns_servers=("178.22.122.100" "185.51.200.2")
  echo -e "nameserver ${dns_servers[0]}\nnameserver ${dns_servers[1]}" | sudo tee /etc/resolv.conf >/dev/null
  # set dns to resolv.conf.d/head
  echo "nameserver 178.22.122.100" | sudo tee -a /etc/resolvconf/resolv.conf.d/head
  echo "nameserver 185.51.200.2" | sudo tee -a /etc/resolvconf/resolv.conf.d/head
  sudo resolvconf -u
  sudo systemctl restart resolvconf.service
  sudo systemctl restart systemd-resolved.service
  echo_green "DNS settings updated and services restarted."
}

function set_dns_host_iran {
  # set dns to resolv
  dns_servers=("172.29.0.100" "172.29.2.100")
  echo -e "nameserver ${dns_servers[0]}\nnameserver ${dns_servers[1]}" | sudo tee /etc/resolv.conf >/dev/null
  # set dns to resolv.conf.d/head
  echo "nameserver 172.29.0.100" | sudo tee -a /etc/resolvconf/resolv.conf.d/head
  echo "nameserver 172.29.2.100" | sudo tee -a /etc/resolvconf/resolv.conf.d/head
  sudo resolvconf -u
  sudo systemctl restart resolvconf.service
  sudo systemctl restart systemd-resolved.service
  echo_green "DNS settings updated and services restarted."
}

function change_ir_repository {
  if grep -q 'ir\.' /etc/apt/sources.list; then
    # remove ir from urls
    sudo sed -i 's/ir\.//g' /etc/apt/sources.list
    echo
    echo_green_bold "IR removed from repository URLs."
    echo
  else
    # add ir to urls
    sudo sed -i 's/http:\/\//http:\/\/ir\./g' /etc/apt/sources.list
    echo
    echo_green_bold "IR added to repository URLs."
    echo
  fi
}

function enable_ssh_for_root {
  if grep -q '#PermitRootLogin' /etc/ssh/sshd_config; then
    # enable
    sudo sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
    # restart service ssh and sshd
    sudo systemctl restart ssh
    sudo systemctl restart sshd
    echo
    echo_green_bold "SSH access for root enabled."
    echo
  else
    echo
    echo_yellow_bold "SSH access for root is already enabled."
    echo
  fi
}

function change_password_root {
  read -s -p "Please enter a new password: " new_password
  echo_blue -e "\nChanging root password..."
  echo -e "$new_password\n$new_password" | passwd root
  echo
  echo_green_bold "password root changed"
  echo
}

function change_ssh_port {
  read -p "Please enter a new SSH port: " new_ssh_port
  if ! [[ "$new_ssh_port" =~ ^[0-9]+$ ]]; then
    echo_red "Error: Invalid port number. Please enter a numeric value."
  else
    # change ssh port
    sed -i "s/Port [0-9]\+/Port $new_ssh_port/" /etc/ssh/sshd_config
    sed -i "s/^#Port [0-9]\+/Port $new_ssh_port/" /etc/ssh/sshd_config
    echo -e "SSH port changed to $new_ssh_port."

    # restart services
    systemctl restart ssh
    systemctl restart sshd
    echo_green_bold "port sshd changed and services restarted."
  fi

}

##### Run Script:

linux_base

if [ "$EUID" -ne 0 ]; then
  echo
  echo_red_bold "please run script as root permission!"
  echo
  exit
fi

if [ "$global_base" != "$DEBIAN" ]; then
  echo
  echo_red_bold "!!! Linux Bash Not Debian !!!"
  echo_green_bold "Exiting script. Goodbye!"
  echo
  exit
fi

while true; do
  display_menu

  read -p "Enter your choice (0-6): " choice

  case $choice in
  0)
    echo
    echo_green_bold "Exiting script. Goodbye!"
    echo
    exit
    ;;

  1) install_essential_items ;;
  2) menu_set_dns ;;
  3) change_ir_repository ;;
  4) enable_ssh_for_root ;;
  5) change_password_root ;;
  6) change_ssh_port ;;
  *) echo "Invalid choice. Please enter a number between 0 and 6." ;;

  esac
done
