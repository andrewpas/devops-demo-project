
## Змінні у проекті
Змінні, які не є частиною IaC-продуктів (Ansible, Terraform) використовуються у наступних файлах:

- **Gitlab CI** — на рівні проекту в панелі керування сервером, на рівні змінних у `.gitlab-cy.yml`. Ці змінні опрацьовуються **gitlab-runner**
- **./templates/ci-template.yaml.j2** — змінні, які використовуються `jinja2-render` при створенні шаблонів, з яких генеруються файли створення docker образів мікросервісів в `./ci/ci-{{service}}.yml`
- **./templates/deploy-template.yaml.j2** — змінні, які використовуються `jinja2-render` при створенні шаблонів, з яких генеруються файли kubernetes deployment для мікросервісів `./kubernetes/{service}-{git_branch_or_stage}-deploiment.yml`

## Опис змінних у Gitlab CI/CD

| Змінна                   | Опис                                                         |
| ------------------------ | ------------------------------------------------------------ |
| `CI_REGISTRY_USER`       | Користувач приватного реєстру Docker Gitlab. Встановлюється як глобальна змінна групи або проекту в Gitlab |
| `CI_REGISTRY_PASSWORD`   | Пароль користувача приватного реєстру Docker Gitlab. Встановлюється як глобальна змінна групи або проекту в Gitlab |
| `DEBUG_TAG`              | `$CI_REGISTRY`/`$CI_PROJECT_ROOT_NAMESPACE`/`$CI_PROJECT_NAME`/`$IMAGE_NAME`:`$CI_COMMIT_SHORT_SHA` - складений тег для образів з git-short-sha |
| ` BRANCH_TAG`            | `$CI_REGISTRY`/`$CI_PROJECT_ROOT_NAMESPACE`/`$CI_PROJECT_NAME`/`$IMAGE_NAME`:`$CI_COMMIT_BRANCH` - складений тег для образів з git-branch |
| `DEV_TAG`                | `$CI_REGISTRY`/`$CI_PROJECT_ROOT_NAMESPACE`/`$CI_PROJECT_NAME`/`$IMAGE_NAME:latest`  - складений тег для образів з `latest` |
| `DEBUG_IMAGE`            | `$IMAGE_NAME`:`$CI_COMMIT_SHORT_SHA`                         |
| `DOCKER_REGISTRY_URL`    | url Docker Hub або аналогів, використовувати, якщо не плануєте користуватись  приватним реєстром Docker Gitlab |
| `DOCKER_REGISTRY_USER`   | login користувача у Docker Hub або аналог                    |
| `DOCKER_REGISTRY_PASSWD` | пароль користувача Docker Hub або аналогів                   |
| `BUILD_CONTEXT`          | `Docker WORKDIR` - відносно цієї директорії буде відбуватися складання образу Docker |
| `IMAGE_NAME`             | Назва образу мікросервісу                                    |
| `KUBE_CONTEXT`           | `uri` зв'язку gitlab.com з кластером Kubernetes              |
| `PROJECT_NAMESPACE`      | Kubernetes namespace в якому будуть розгорнуті deployments мікросервисів |
| `DEFAULT_IMAGE`          | Образ по замовчуванню, на базі якого gitlab-runner буде складати образи мікросервісів |

## Опис змінних у ./templates/ci-template.yaml.j2

| Змінна             | Опис                                                         |
| ------------------ | ------------------------------------------------------------ |
| `project_path`     | GitLab uri поточного проекту на сервері. Приклад: *gitlab.example.com/group-name/project-name* |
| `branch`           | Гілка git, в якої розробляються скрипти для деплою           |
| `service`          | Назва мікросервісу                                           |
| `build_context`    | `Docker WORKDIR` - відносно цієї директорії буде відбуватися складання образу Docker, дублюється за відповідною змінною в `BUILD_CONTEXT` GitLab Ci |
| `environment_name` | Назва оточення, на яке буде розгортатись deploy. Дублює змінну GitLab CI –`CI_ENVIRONMENT_NAME` |
| `environment_url`  | URL оточення, на яке буде розгортатись deploy. Дублює змінну GitLab CI –`CI_ENVIRONMENT_URL` |
| `autorules`        | Перелік директорій в проекті, в яких будуть відстежуватись зміни файлів для автоматичного збирання образів та deploy |

**Приклади використання змінних:**  

Проект gitlab та git branch, з якого будуть включені файли `ci_docker_build.yml` та `ci_variables.yml`:

```yaml
include:
  - project: "{{ project_path }}"
    ref: "{{ branch }}"
    file:
      - ci/ci_docker_build.yml
      - ci/ci_variables.yml
```

Визначення GitLab `environment`:

```yaml
  environment:
    name: {{ environment_name }}
    url: {{ environment_url }}
```

Визначення правил для автоматичного збирання образів докер для сервісу:

```yaml
.{{ service }}_auto_rules:
  rules:
    - changes:
        {{ autorules }}
      when: always
```

## Опис змінних у ./templates/deploy-template.yaml.j2

| Змінна                 | Опис                                                         |
| ---------------------- | ------------------------------------------------------------ |
| `deployment_name`      | Назва kubernetes deploymet, яка буде вказана в Cluster Control.  Бажано вказувати назву мікросервісу, або вказувати  зв\`язок з оточенням. Приклад: "deployment_name ": "stage-emailservice". Використовується в labels |
| `image_pull_secrets`   | Kubernetes Secret, який містить ідентіфікатори доступу до приватного реєстру docker образів |
| `app_name`             | Назва мікросервісу. Приклад: "app_name": "emailservice".  Використовується в labels |
| `app_version`          | Версія або реліз мікросервісу. Бажано використовувати правила для [Semantic Versioning](https://semver.org/). Використовується в labels |
| `project_name`         | Якщо використовується Rancher, назва проекту у Rancher. В Rancher до POD у межах проекту заборонений трафік POD за межами проекту. Це дає додаткову можливість захисту. !!! Проект не namespace. В межах проекту може буди декілько namespace. Використовується в labels |
| `namespace_name`       | namespace в який буде проводитись Kubernetes Deployment. Використовується в labels |
| `app_creator`          | email або інший контакт розробника. Використовується в labels |
| `app_supporter`        | Відповідальний за support. mail або інший контакт. Використовується в labels |
| `environment_stage`    | Назва оточення, на яке буде розгортатись deploy. Дублює змінну GitLab CI –`CI_ENVIRONMENT_NAME`, та `environment_name` в ./templates/ci-template.yaml.j2. Використовується в labels |
| `environment_uri`      | URL оточення, на яке буде розгортатись deploy. Дублює змінну GitLab CI –`CI_ENVIRONMENT_URL`, та `environment_url` в ./templates/ci-template.yaml.j2. Використовується в labels |
| `app_component`        | Яку функцію виконує мікросервіс в загальному продукті. Використовується в labels. Приклад: "app_component": "email-campain" |
| `business_domain`      | Показує зв\`язок між мікросервісом, та бізнес-функцією на яку він має вплив. Використовується в labels. Приклад: "business_domain": "marketing" |
| `business_owner`       | Контакт відділу або відповідального за  бізнес-функцію. Використовується в labels. Приклад: "business_owner": "marketing@company.com" |
| `app_instance`         | На якій базі розгорнуто оточення для deploy. baremetal, rancher, eks. Використовується в labels. Приклад: "app_instance": "aws-eks"; "app_instance": "baremetal-rancher"; "app_instance": "ec2-kubespray" |
| `app_replicas`         | Кількість екземплярів мікросервісу, які мають працювати      |
| `image`                | Повний URL образу Docker.  Приклад для Gitlab: registry.gitlab.com/{gitlab_group}/project/{service_name}:{tag} |
| `requests_memory`      | Скільки відводити оперативної пам\`яті (мінімум) для одного екземпляру контейнера |
| `requests_cpu`         | Скільки відводити cpu_millicores (мінімум) для одного екземпляру контейнера |
| `limits_memory`        | Скільки відводити оперативної пам\`яті (максимум) для одного екземпляру контейнера |
| `limits_cpu`           | Скільки відводити cpu_millicores (максимум) для одного екземпляру контейнера |
| `ports_container_port` | Порт, на якому POD приймає вхідний трафік                    |
| `port_name`            | Назва порту                                                  |
| `ports_protocol`       | Протокол, по якому працює POD в Kubernetes Deployment. TCP, UDP, SCTP |
| `service_port`         | Порт, на який контейнер приймає вхідний трафік. Відноситься до Kubernetes Service |
| `service_protocol`     | Протокол, по якому працює Kubernetes Service. TCP, UDP, SCTP. Приклад: spec.ports.protocol: TCP. Відноситься до Kubernetes Service |
| `service_target_port`  | Порт на який буде спрямовано трафік з `service_port`. Відноситься до Kubernetes Service |
| `service_ip_type`      | Яким чином  Kubernetes Service публікує порти — `ExternalName`, `ClusterIP`, `NodePort`, `LoadBalancer`.  Відноситься до Kubernetes Service |
| `app_env`              | Змінні для специфікації контейнеру                           |

​	
