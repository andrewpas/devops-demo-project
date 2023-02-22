# Приклад Inventory для ролі `rancher-cluster`

```yaml
kubernetes:
  gather_facts: false
  hosts:
    node1.example.net:
      ansible_port: 22
      ansible_host: 192.168.101.141
      ansible_distribution: ubuntu
      ansible_distribution_release: focal
      ansible_fqdn: "node1.example.net"
      ansible_domain: "example.net"
      ansible_hostname: "node1.example.net"
      inventory_hostname: "node1.example.net"
      ansible_nodename: "node1"
      rancher_image: "rancher:v2.6.6"
      rancher_agent_image: "rancher-agent:v2.6.6"
      rancher_node_role: server
      rancher_k8s_version: "1.20.15"
      rancher_setup_password: "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
      rancher_role_flags: "--etcd --controlplane --worker"
      rancher_server_url_name: "https://192.168.101.141"
      rancher_init_ip: 192.168.101.141
      rancher_cluster_name: dev-cluster
      ansible_ens18:
        device: ens18
        ipv4:
          address: 192.168.101.141
```

`node1.example.net` — дуже важливий параметр для встановлення FQDN ноди, на його основі будуть створені коректні
файли `/etc/hosts`.

Це дасть можливість нодам вільно комунікувати, що є обов\'язковими умовами для коректної роботи ролі.

`rancher_setup_password` - задає пароль для доступу до web-інтерфейсу сервера

```yaml
ansible_ens18:
  device: ens18
  ipv4:
    address: 192.168.101.141
```

Дуже важливий параметр — опис мережевих інтерфейсів, залежить від ОС, яка використовується на нодах. В Ubuntu
це `ens18`. На цій основі створюється коректний файл  `/etc/hosts`.  
Використовується в шаблоні `ansible/roles/rancher-cluster/templates/hosts.j2`

```yaml
{ % for host in groups [ 'kubernetes' ] % }
  { % if 'ansible_ens18' in hostvars[ host ] % }
  { { hostvars[ host ][ "ansible_ens18" ][ "ipv4" ][ "address" ] } }  { { hostvars[ host ][ "inventory_hostname" ] } }
  { % endif % }
  { % endfor % }
```
