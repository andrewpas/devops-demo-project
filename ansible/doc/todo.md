# TODO:

### ./ubuntu20/docker.yml > `task - disable firewall (ufw)`:
* Замінити вимкнення firewall логікою, яка відкриває потрібні сервіси в залежності від значення змінної `rancher_node_role` (rancher-cluster)
### ./ubuntu20/upgrade.yml > `task - reboot node`:
* Добавити логіку пошуку події оновлення ядра, та поставити як умову для перезавантаження ноди, якщо встановлено нове ядро. (rancher-cluster)

Documentation generated using: [Ansible-autodoc](https://github.com/AndresBott/ansible-autodoc)