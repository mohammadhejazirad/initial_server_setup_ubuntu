## script for initial setup ubuntu server

### menu items:

* 0- exit from script
* 1- install essential items server
* 2- set dns for iran
  servers ([403](https://403.online/)) || ([shecan](https://shecan.ir/)) || ([hostIran](https://hostiran.net/landing/proxy))
* 3- add | remove ir repository ubuntu
* 4- enable ssh for root
* 5- change password root
* 6- change ssh port

for ease of doing various tasks on Ubuntu server

```bash
sudo bash -c "$(curl -fsSL https://raw.githubusercontent.com/mohammadhejazirad/initial_server_setup_ubuntu/main/setup.bash)"
```

or

```bash
sudo bash -c "$(wget https://raw.githubusercontent.com/mohammadhejazirad/initial_server_setup_ubuntu/main/setup.bash -O -)"
```

```bash
chmod +x ./setup.bash
```

```bash
sudo ./setup.bash
```

