# Створення файлів конфігурацій та kubernetes deployment з шаблонів

Кожен мікросервіс має свої конфігураційні файли:

1. **./ci/ci-{service}.yml** — GitLab CI файл для створення образів мікросервісів та розгортання їх у кластер Kubernetes
2. **./kubernetes/{service}-{environment}-deployment.yaml** — Kubernetes Deployment для мікросервісу для конкретного оточення (`stage`, `prod`)
3. **./kubernetes/{service}-{environment}-service.yaml** — Kubernetes Service для мікросервісу для конкретного оточення (`stage`, `prod`)

Всі ці файли створюються з jinja2 templates за допомогою python скрипта [jinja2-render](https://github.com/pklaus/jinja2-render). 

```bash
pip install jinja2-render
```

Застосування:

```bash
jinja2-render -c {файл контексту}  -f {шаблон з якого створюються файли} -o {віхідний файл} {пункт контексту}
```

файл контексту  – json-файл в якому визначаються змінні та їх значення, які потім будуть застосовані в вихідних файлах.

шаблон з якого створюються файли – jinja2 шаблон, в якому застосовуються змінні

пункт контексту – першій рівень у списку в json

Приклад:

файлу контексту  – *debpoy-prod-env.py*:

```json
CONTEXTS = {
    "adservice": {
        "deployment_name": "prod-adservice",
        "deployment_app": "adservice",
        "app_replicas": "1",
        "image": "registry.gitlab.com/devops1121/microservices-demo-google/adservice:stage",
        "image_pull_secrets": "registry.gitlab",
        "app_name": "adservice",
        "app_version": "0.1.0",
        "project_name": "microservices-demo",
        "namespace_name": "prod-microservices-demo",
        "app_creator": "developer_company.com",
        "app_supporter": "devops_company.com",
        "environment_stage": "prod",
        "environment_uri": "prod-env.company.com",
        "app_component": "advertise-service",
        "business_domain": "sales",
        "business_owner": "marketing_company.com",
        "app_instance": "baremetal-rancher",
        "requests_memory": "512Mi",
        "requests_cpu": "500m",
        "limits_memory": "1Gi",
        "limits_cpu": "1000m",
        "ports_container_port": "9555",
        "ports_protocol": "TCP",
        "port_name": "grpc",
        "service_port_name": "grpc",
        "service_port": "9555",
        "service_protocol": "TCP",
        "service_target_port": "9556",
        "service_ip_type": "ClusterIP",
        "app_env": "- name: PORT\n            value: \"9555\"\n          - name: \"DISABLE_STATS\"\n            value: \"1\"\n          - name: \"DISABLE_TRACING\"\n            value: \"1\"\n"
    },
    "cartservice": {
        "deployment_name": "prod-cartservice",
        "deployment_app": "cartservice",
        "app_replicas": "1",
        "image": "registry.gitlab.com/devops1121/microservices-demo-google/cartservice:stage",
        "image_pull_secrets": "registry.gitlab",
        "app_name": "cartservice",
        "app_version": "0.1.0",
        "project_name": "microservices-demo",
        "namespace_name": "prod-microservices-demo",
        "app_creator": "developer_company.com",
        "app_supporter": "devops_company.com",
        "environment_stage": "prod",
        "environment_uri": "prod-env.company.com",
        "app_component": "advertise-service",
        "business_domain": "sales",
        "business_owner": "marketing_company.com",
        "app_instance": "baremetal-rancher",
        "requests_memory": "512Mi",
        "requests_cpu": "500m",
        "limits_memory": "1Gi",
        "limits_cpu": "1000m",
        "ports_container_port": "7070",
        "ports_protocol": "TCP",
        "port_name": "grpc",
        "service_port_name": "web",
        "service_port": "7070",
        "service_protocol": "TCP",
        "service_target_port": "7070",
        "service_ip_type": "ClusterIP",
        "app_env": "- name: REDIS_ADDR\n            value: \"redis-cart:6379\"\n"
    }
}
```

Файл шаблону – *deploy-template.yaml.j2*

```jinja2
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ deployment_name }}
  namespace: {{ namespace_name }}
  labels:
    deployment_name: {{ deployment_name }}
    app.kubernetes.io/name: {{ app_name }}
    app.kubernetes.io/version: "{{ app_version }}"
    project_name: {{ project_name }}
    namespace_name: {{ namespace_name }}
    app.kubernetes.io/created-by: {{ app_creator }}
    app.kubernetes.io/managed-by: {{ app_supporter }}
    environment_stage: {{ environment_stage }}
    environment_uri: {{ environment_uri }}
    app.kubernetes.io/component: {{ app_component }}
    business_domain: {{ business_domain }}
    business_owner: {{ business_owner}}
    app.kubernetes.io/instance: {{ app_instance }}

spec:
  replicas: {{ app_replicas }}
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 25%
      maxUnavailable: 25%
  template:
    metadata:
      name: {{ deployment_name }}
      namespace: {{ namespace_name }}
      labels:
        deployment_name: {{ deployment_name }}
        deployment_app: {{ deployment_app }}
        app.kubernetes.io/name: {{ app_name }}
        app.kubernetes.io/version: "{{ app_version }}"
        project_name: {{ project_name }}
        namespace_name: {{ namespace_name }}
    spec:
      containers:
        - name: {{ deployment_name }}
          image: {{ image }}
          imagePullPolicy: Always
          resources:
            requests:
              memory: {{ requests_memory }}
              cpu: {{ requests_cpu }}
            limits:
              memory: {{ limits_memory }}
              cpu: {{ limits_cpu }}
          ports:
            - containerPort: {{ ports_container_port }}
              protocol: {{ ports_protocol }}
              name: {{port_name}}
          env:
          {{app_env}}
      restartPolicy: Always
      imagePullSecrets:
        - name: {{ image_pull_secrets }}
  selector:
    matchLabels:
      deployment_app: {{ deployment_app }}
      namespace_name: {{ namespace_name }}
      environment_stage: {{ environment_stage }}
```

Створити Kubernetes deployment для adservice:

```bash
jinja2-render -c ./debpoy-prod-env.py  -f ./deploy-template.yaml.j2 -o ./adservice-prod-deploy.yaml adservice
```

Створити Kubernetes deployment для cartservice:

```bash
jinja2-render -c ./debpoy-prod-env.py  -f ./deploy-template.yaml.j2 -o ./cartservice-prod-deploy.yaml cartservice
```

## Створення файлів для Gitlab CI

- файл контексту для Gitlab CI — ./templates/ci-env.py
- шаблон з якого створюються файли Gitlab CI — ./templates/ci-template.yaml.j2
- вихідні файли — ./ci/ci_{service}.yml
- bash скрипт, який автоматично створює файли для всіх сервісів в ./src/  — ./tools/ci-template.sh

## Створення файлів для Kubernetes Deployment і Service

- файл контексту для Kubernetes Deployment — ./templates/debpoy-stage-env.py (оточення `stage`), ./templates/debpoy-prod-env.py (оточення `prod`)

- шаблон з якого створюються файли Kubernetes Deployment — ./templates/deploy-template.yaml.j2

- вихідні файли — ./kubernetes/{service}-{environment}-deployment.yaml

- bash скрипт, який автоматично створює файли для всіх сервісів в ./src/  — ./tools/kube-deploy-template.sh
  Застосування:

  ```bash
  ./kube-deploy-template.sh prod або ./kube-deploy-template.sh stage
  ```

> Скрипт використовує результат команди `ls ./src` як перелік значень для створення відповідних файлів. Тобто, якщо є каталог сервіса `adservice`, то повинен будт відповідний контекс у файлі контексту.

## Файли, які потрібно створювати та відстежувати самостійно

У адмініструванні Kubernetes можуть бути різні ситуації, коли потрібно створювати та зміновати різні об\`єкті Kubernetes. Ці віпалки важко продумати заздалегідь та створити відповідні jinja2 templates. Тому решту файлів для об\`єктів Kubernetes потрібно створювати самойстійно у форматі:

./kubernetes/{service}-{environment}-{kubernetes-resource}.yaml.

Зміни у диркторії ./kubernetes/ обпрацьовуються автоматично GitLabCI pipeline