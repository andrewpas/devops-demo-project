#  Ansible роль 'rancher-cluster'


Роль створена для автоматичного встановлення кластера kubernetes для навчання та експериментів. 

## Actions:

Actions performed by this role


#### ./tasks/rancher-cluster.yml:
* Імпортує `rancher_api_key` з "віртуального" хоста. Створює Kubernetes кластер зі значеннями змінних `rancher_k8s_version` та `rancher_cluster_name`. Генерує bearer token для реєстрації нод - `rancher_registration_token`, посилання для реєстрації нод - `rancher_registration_link`, команду для реєстрації нод - `rancher_node_register`, до якої буде додаватись змінна `rancher_role_flags`, в залежності від ролі ноди в кластері. Всі ці змінні експортуються через "віртуальні" хости для інших задач. (rancher-cluster)
#### ./tasks/rancher-control.yml:
* Очікує три хвилини щоб кластер повністю розгорнувся, імпортує значення змінної `export_node_start` з віртуального хоста, додає `Control Plane` ноду до кластера. Задача виконується тільки на нодах де в inventory `rancher_node_role: "control"` (rancher-cluster)
#### ./tasks/rancher-nodes.yml:
* Очікує 5 хвилин щоб кластер та `Control Plane` ноди повністю розгорнулися, імпортує значення змінної `export_node_start` з віртуального хоста, додає `Worker Node` до кластера. Задача виконується тільки на нодах де в inventory `rancher_node_role: "node"` (rancher-cluster)
#### ./tasks/rancher-server.yml:
* Запускає на ноді з `rancher_node_role: "server"` контейнер `ranсher-server`, який запускає процес інсталювання, та приймає з\'єднання на портах 80,443. На ці операції відведено 3 хвилини (в залежності від "заліза" можна вказати свої параметри). Потім за допомогою `curl` здійснюються 3 спроби логину на сервер - це "хак", бо Rancher незрозуміло поводить себе с токенами, дуже часто їх змінює. Експерименти показали, що з третьої спроби логін на сервер працює без помилок. Також все запрацювало тільки після заміни `ansible.builtin.command` на `ansible.builtin.shell` в завданнях. Результат сесії логіну - це json, з якого за допомогою `jq` знаходиться значення параметра `token`. Він зберігається для інших завдань за допомогою "віртуального" host в inventory: `ansible.builtin.add_host`. Таким чином, експортується змінна `export_login_token`. За допомогою `rancher_login_token.stdout` завантажується api key з сервера, який також експортується через "віртуальний" хост, як змінна `rancher_api_key`. За допомогою `rancher_api_key` призначуєтеся значення змінної `rancher_server_url_name`. (rancher-cluster)
#### ./tasks/ubuntu20/base-packages.yml:
* Визначає які пакети вже є в системі та встановлює лише ті, яких не вистачає. Необхідні пакети визначаються у змінній `base_packages`. Вираз `name: {{ base_packages | difference(ansible_facts.packages) }}` порівнює список пакетів зі змінною та з наявними в системі, тому встановлюється тільки різниця. (rancher-cluster)
#### ./tasks/ubuntu20/docker.yml:
* Підключає apt repository від Docker, перемикає на нього інсталятор, встановлює Docker, вмикає маршрутизацію `ipv4`, вимикає firewall (тимчасове рішення для тестів), завантажує образи Docker від Rancher, які визначаються через змінні `rancher_agent_image` та `rancher_image`. (rancher-cluster)
#### ./tasks/ubuntu20/hosts.yml:
* Призначає ноді необхідний `hostname` та генерує коректний файл `/etc/hosts`, в якому вказані всі ноди с їх IP-адресами та `hostname`. Для цього використовується шаблон з `/templates/hosts.j2` (rancher-cluster)
#### ./tasks/ubuntu20/pip.yml:
* Встановлення необхідних python pip-пакетів. Пакети можна додавати в перелік `loop`. Потребує пакет `python3-pip`, який потрібно встановити на ноду. (rancher-cluster)
#### ./tasks/ubuntu20/rancher-dirs.yml:
* Створює каталоги для даних Rancher, які потім будуть примонтовані в Docker контейнери через `volumes`. (rancher-cluster)
#### ./tasks/ubuntu20/timesync.yml:
* Створює конфігураційний файл для демона точного часу `tymesyncd`, завантажує на всі ноди, та перезапускає сервіс, щоб не було розбіжностей в часі. Використовується шаблон `/templates/timesyncd.conf.j2`, але без змінних для серверів часу та інших параметрів. (rancher-cluster)
#### ./tasks/ubuntu20/upgrade.yml:
* Вимикає автоматичне оновлення пакетів, оновлює наявні до останньої версії, та перезавантажує ноди на випадок якщо було встановлено нове ядро linux. (rancher-cluster)

## Tags:
## Variables:

### Rancher-cluster:
* `ansible_port`: `22` - SSH host port
* `ansible_host`: `` - Host IP
* `ansible_distribution`: `ubuntu` - Підтримуються: Alpine, Altlinux, Amazon, Archlinux, ClearLinux, Coreos, Centos, Debian, Gentoo, Mandriva, NA, OpenWrt, OracleLinux, RedHat, Slackware, SMGL, SUSE, VMwareESX. Нижній регістр.
* `ansible_distribution_release`: `focal` - Версія дистрибутиву. В цієї ролі використовується focal, тобто Ubuntu 20.04 (LTS)
* `rancher_image`: `rancher:v2.6.6` - Тег Docker образу сервера Rancher. Буде встановлено на ноду з `rancher_node_role: "server"`
* `rancher_agent_image`: `rancher-agent:v2.6.6` - Тег Docker образу агента rancher, котрий встановлюється на кожну ноду для зв\'язку з сервером Rancher. Буде встановлено на ноду з `rancher_node_role: "node"`
* `rancher_node_role`: `node` - "Маркер" який вказує на роль ноди в кластері. `server` - головний сервер, на базі якого буде будуватися кластер, та встановлюватися необхідне програмне забезпечення на ноди. Потрібна хоча б одна нода с цією роллю. `control` - буде встановлено Kubernetes `Control Plane`. `node` - робоча нода (`Worker Node`), на яку буде встановлено ПЗ Rancher. Ця змінна по змісту схожа на `rancher_role_flags`, але в неї інша функція.
* `rancher_k8s_version`: `1.20.15` - Версія Kubernetes, яку буде встановлено на всі ноди.
* `rancher_setup_password`: `` - Пароль для з\'єднання с web-інтерфейсом та API для адміністрування. Адреса для з\'єднання визначається в змінної `rancher_server_url_name`. Потрібно вказати тільки на нодах з `rancher_node_role: "server"`
* `rancher_role_flags`: `--worker` - Роль, яку буде виконувати нода. `--etcd` - одна з нод в кластері etcd, які зберігають поточний стан кластера Kubernetes. Потрібно як найменш 3 ноди с цією роллю. `--controlplane` - нода на якої виконуються Kubernetes shedulers та ін., може бути в одному екземплярі, але бажано щоб їх було декілька. `--worker` - будуть встановлені `kubelet`, `kube-proxy`. Для `--etcd` та `--controlplane` потрібно достатньо ресурсів, тому бажано відводити для них не менш ніж 8Gb оперативної пам'яті. Всі ці ролі також можуть буди встановлені на одну ноду.
* `rancher_server_url_name`: `"https://192.168.101.141"` - Адреса для з\'єднання с web-інтерфейсом та API сервера. Бажано використовувати IP-адресу. Або коректно налаштувати локальну DNS-зону на DNS-сервері.
* `rancher_init_ip`: `` - IP адреса до якої будуть з\'єднуватися ноди за допомогою `curl`. Потрібно вказувати IP-адресу ноди з `rancher_node_role: "server"`
* `rancher_cluster_name`: `` - Ім\'я кластера Kubernetes, який буде створено після встановлення всього необхідного ПЗ. Всі сценарії в ролі будуть використовувати з\'єднання нод з цим кластером.
* `base_packages`: `["bash-completion", "bind9utils", "curl", "git", "git-extras", "htop", "iptraf", "lsof"]` - Базові програмні пакети, яки необхідні для системного адміністрування ноди.
## TODO:

#### ./ubuntu20/docker.yml > `task - disable firewall (ufw)`:
* Замінити вимкнення firewall логікою, яка відкриває потрібні сервіси в залежності від значення змінної `rancher_node_role` (rancher-cluster)
#### ./ubuntu20/upgrade.yml > `task - reboot node`:
* Додати логіку пошуку події оновлення ядра, та поставити як умову для перезавантаження ноди, якщо встановлено нове ядро. (rancher-cluster)

## Author Information
This playbook  was created by: Andriy pustovit

Documentation generated using: [Ansible-autodoc](https://github.com/AndresBott/ansible-autodoc)

