# Підключення Kubernetes кластеру до GitLab

`gitla-agent ` інтегрує Gitlab с кластером Kubernetes. Працює навіть за NAT.  
Потрібно створити порожній файл в `.gitlab/agents/{agent-name}/config.yaml`  
Потім зареєструвати агента в GitLab:

1. **Infrastructure** ==> **Kubernetes clusters** ==> **Create agent**
2. Ввести `{agent-name}` та отримати токен - `{cluster-token}`
3. В кластері:
    ```bash
    helm repo add gitlab https://charts.gitlab.io
    helm repo update
    helm upgrade --install `{agent-name}` gitlab/gitlab-agent \
    --namespace gitlab-agent-`{agent-name}` \
    --create-namespace \
    --set image.tag=v15.9.0-rc1 \
    --set config.token=`{cluster-token}` \
    --set config.kasAddress=wss://kas.gitlab.com
    ```

Це нам каже офіційна документація.

Але в мене в Rancher запрацювало якщо додати HELM репозіторій та додади агента за допомогою yaml:

```yaml
affinity: { }
config:
  kasAddress: wss://kas.gitlab.com
  token: `{ cluster-token }`
extraEnv: [ ]
fullnameOverride: ''
image:
  pullPolicy: IfNotPresent
  repository: registry.gitlab.com/gitlab-org/cluster-integration/gitlab-agent/agentk
  tag: 'v15.2.0'
imagePullSecrets: [ ]
nameOverride: ''
nodeSelector: { }
podAnnotations:
  prometheus.io/path: /metrics
  prometheus.io/port: '8080'
  prometheus.io/scrape: 'true'
rbac:
  create: true
resources: { }
serviceAccount:
  annotations: { }
  create: true
tolerations: [ ]

```

Агент може працювати в двох режимах:

- [GitOps workflow](https://docs.gitlab.com/ee/user/clusters/agent/gitops.html) - GitLab agent в кластері періодично відстежує зміни у віхідному коді Kubernetes Deployment, та робить **pull** з репозіторію проекту
- [GitLab CI/CD workflow](https://docs.gitlab.com/ee/user/clusters/agent/ci_cd_workflow.html) - за допомогою `kubectl `pipeline **push** зміни у віхідному коді Kubernetes Deployment у кластер

Якщо використовувати **GitLab CI/CD workflow**, то файл `.gitlab/agents/{agent-name}/config.yaml` повинен мати такий
вигляд:

```yaml
ci_access:
  projects:
    - id: path/to/project
```
