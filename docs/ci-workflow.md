## Як працює процес Ci/CD

![](/home/devps/projects/active/microservices-demo-google/img/ci-workflow.png)

### Гілка Dev

> {service} — змінна, в яку підставляється назва мікросервісу (`./scr/{service}`)

Згідно схеми gitlab-flow — це основна робоча гілка. Після коміту автоматично буде створено образ Docker з відповідними тегами:

- {service}-image:**latest** — основний робочий артефакт гілки **dev**. Використовується в `docker-compose.yml` на комп'ютері розробника. Для тестування власної розробки та останніх комітів мікросервісів колег
- {service}-image:**sha1** — використовується для зв'язку:  № Jira Task ===> № Jira Task у назві git-branch ===> git short-sha ===> {service}-image:**sha1**. Потрібен для debug, або для перевірки робочих гіпротез на локальному `docker-compose.yml`. 
- {service}-image:**dev** — сінонім {service}-image:**latest**

Всі ці теги будуть завантажені у Docker Registry (Docker Hub або приватний)

### Гілка Stage

Гілка для тестів.

Створює образ з тегами:

- {service}-image:**sha1** — debug або Jira Task
- {service}-image:**stage** — артифакт, який буде автоматично викладено на середовище **stage** (Proxmox + Rancher) за допомогою ./kubernetes/{service}-**stage**-deploiment.yml

Всі ці теги будуть завантажені у Docker Registry (Docker Hub або приватний)

### Гілка Master

Гілка для робочого середовища.

Створює образ з тегами:

- {service}-image:**sha1** — debug або Jira Task
- {service}-image:**master** — артифакт, який буде автоматично викладено на середовище **production** (AWS EKS) за допомогою ./kubernetes/{service}-**master**-deploiment.yml

Всі ці теги будуть завантажені у Docker Registry (Docker Hub або приватний)

## Структура .gitlab-ci.yml

Головний файл стандарний — `./gitlab-ci.yml` у "корені" проекту. Він включає решту файлів, яка підключаються за допомогою директиви `include`.

> У сервісі gitlab.com у мене не вийшло підключати файли за допомогою (local), повідомлення linter — "file not found"
>
> ```yam
> include:
>   - local: '/templates/.gitlab-ci-template.yml'
> ```
>
> Тому довелося використовувати "hack":
>
> ```yaml
> include:
>   - project: "project_name"
>   	ref: "ci-template"
>   	file:
>       - ci/ci_docker_build.yml
>       - ci/ci_variables.yml
>       - ci/kubectl_handler.yml
> ```
>
> Де у якості `project_name` був цей проект.



> Звісно, що є принята практика створювати окремий проект для всій логіки CI/CD, та писати узагальнені скрипти. Але це занадто ускладнює учбовий проект.
>
> Але для коректного використання оператору `include` потрібно вказувати параметр `ref:`.
>
> Тому всі зміні в скриптах GitLabCI, Kubernetes Deployment та інше потрібно виконувати в гілці `ci-template`.
>
> Звісно це не зовсім зручно, ало поки буде так.

Кожен сервіс має свій *"іменний"* CI/CD-файл `./ci/ci-{service}.yml` та свій Kubernetes Deploiment `./kubernetes/{service}-stage-deploiment.yml`.

### stages


- build-debug-image — створюється образ docker, надається тег short-sha, образ завантажується в docker registry
- pull-debug — вивантаження з реєстру, надання інших тегів
- push-image — завантаження нових тегів в реєстр
- deploy — деплой в kubernetes cluster


### include

До проекту додані файли, які можна використовуваті в інших проектах.  

`./ci/ci_docker_build.yml` — містить [hidden jobs](https://docs.gitlab.com/ee/ci/jobs/index.html#hide-jobs) по створенню, тегуванню та завантаженню образів. Ці дії можна підключати за допомогою [anchors](https://docs.gitlab.com/ee/ci/yaml/yaml_optimization.html#anchors)

`./ci/ci_variables.yml` — містить основні змінні, які підключаються до всіх ci-файлів.

Ці два файли підключаються в кожен `./ci/ci-{service}.yml`



### Основні складові ./ci/ci-{service}.yml

Система назви jobs:

- {{service}}_auto_rules — правила, по яким спрацьювує автоматичний build docker image
- {{service}}_manual_rules — правила, по яким спрацьовує ручний build docker image
- auto\_{{service}}\_debug — автоматичне створення и push docker image:sha1
- manual\_{{service}}\_debug — ручне створення и push docker image:sha1
- pull_auto\_{{service}}\_sha — pull образів docker з артефакту auto\_{{service}}\_debug
- pull_manual\_{{service}}\_sha — pull образів docker з manual\_{{service}}\_debug
- push_currencyservice_image — push образів docker з тегами latest, branch_name



Відстежування змін файлів у директоріях:

```yaml
.emailservice_auto_rules:
  rules:
    - changes:
        - src/{{service}}/**/**/*
      when: always
```

Відстежування тексу git commit:

```yaml
.emailservice_manual_rules:
  rules:
    - if: "$CI_COMMIT_MESSAGE =~ /emailservice-manual/"
      when: always
```

Завантаження образів docker в реєстр:

```yaml
push_{{ service }}_image:
  stage: push-image
  # Змінні
  variables:
    <<: *global_var
    IMAGE_NAME: {{ service }}
  # Перевикористання jobs з умовами для завантаження образів
  extends:
    - .deploy_latest_tag_to_registry
    - .deploy_branch_tag_to_registry
  # Умиви, за яких відбувається завантаження образів
  rules:
    - !reference [ ".{{ service }}_auto_rules", "rules" ]
    - !reference [ ".{{ service }}_manual_rules", "rules" ]
  # Залежність від виконання попередніх jobs
  needs:
    - job: pull_manual_{{ service }}_sha
      optional: true
    - job: pull_auto_{{ service }}_sha
      optional: true
```

Завантаження образу за тегом `latest`, якщо назва git brabch дорівнює`dev`,  для використання на комп\`ютері розробника за допомогою docker compose:

```yaml
# Extnetd from ./ci/ci_docker_build.yml
.deploy_latest_tag_to_registry:
  stage: push-image
  script:
    - docker tag $DEBUG_TAG $DEV_TAG
    - docker push $DEV_TAG
  rules:
    - if: "$CI_COMMIT_BRANCH =~ /dev/"
      when: auto
  when: on_success
```

Завантаження образу з тегом branch_name, якщо назва git brach дорівнює `stage ` або `main`:

```yaml
# Extnetd from ./ci/ci_docker_build.yml
.deploy_branch_tag_to_registry:
  stage: push-image
  script:
    - docker tag  $DEBUG_TAG $BRANCH_TAG
    - docker push $BRANCH_TAG
  rules:
    - if: "$CI_COMMIT_BRANCH =~ /stage/ || $CI_COMMIT_BRANCH =~ /main/"
  when: on_success
```

