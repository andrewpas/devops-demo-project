# Опис Ansible ролі `rancher-cluster`

Для встановлення Kubernetes використовується RKE1 (Rancher Kubernetes Engine v.1) від [Rancher Labs](https://www.rancher.com/products/rke).

> RKE — це дистрибутив Kubernetes, сертифікований CNCF, якій повністю працює в контейнерах Docker

В ролі використовуються 5 віртуальних машин (нод):

- **1** Rancher Server — на неї встановлюється первинний набір ПЗ та нода для кластера `etcd`
- **2** Control Plane Node — `kube-apiserver`,`etcd`, `cloud controller manager`, `kube-controller manager`, `kube-sheduler`
- **2** Worker Node — `kubelet`, `kubeproxy`

В інфраструктурі використовується ProxmoxVE KVM з Ubuntu 20.04 (LTS)

Оскільки Rancher Kubernetes Engine ще "молодий" продукт — ще не все добре працює, тому рекомендовано використовувати саме ті версії системного ПЗ, які 100% працюють в цій ролі:

```yaml
- rancher_image: rancher:v2.6.6
- rancher_agent_image: rancher-agent:v2.6.6
- ansible_distribution: ubuntu
- ansible_distribution_release: focal
- rancher_k8s_version: 1.20.15
- docker: 5:20.10.12~3-0~ubuntu-focal
```
