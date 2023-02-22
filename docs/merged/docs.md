## Requirements

No requirements.

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

No inputs.

## Outputs

No outputs.

### Середовище Production


## EKS

## Route53

# Опис CI/CD

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
| `IMAGE_NAME`             | Назва образу мікросервіса                                    |
| `KUBE_CONTEXT`           | `uri` зв'язку gitlab.com з кластером Kubernetes              |
| `PROJECT_NAMESPACE`      | Kubernetes namespace в якому будуть розгорнуті deployments мікросервисів |
| `DEFAULT_IMAGE`          | Образ по замовчуванню, на базі якого gitlab-runner буде складати образи мікросервісів |


## Структура директорій

- `./src` - містить вихідні коди мікросервісів проекту

- `./tools` - допоміжні застосунки для проектуЖ
    - Docker файли для утіліт, які могут використовуватись на компьютері розробника в docker compose
    - bash-скрипти для автоматичного парсінгу та створення
      документації - `ansible-autodoc`, `terraform-docs`, `merge-markdown`
    - рендерінг jinja2-templates

- `./ci` - містить yaml-файли, які використовуються в `.gitlab-ci.yml`. Кожен файл відповідає за окремий сервіс. Всі
  файли мають однакову структуру та генеруються з шаблону

- `./templates` - містить шаблони jinja2 для створення yaml-файлів для `.gitlab-ci.yml` та kubernetes deployment

- `./kubernetes` - містить сгенеровані з шаблонів yaml-файли для kubernetes deployment

- `./docs` - містить конфигурційні файли для застосунків `terraform-docs`, `merge-markdown` та для окремих файлів
  документації, які не генеруються автоматично

- `./ansible` - містить ansible-роль для створення кластера Kubernetes за допомогою [Rancher](https://www.rancher.com/)

- `./terraform` - містить ресурси Terraform для створення AWS EKS  

# Документація по проекту

## Вихідний код

Основою цього тестового проекту є досить вдалий код від Google (він дійсно працює) — [Online Boutique](https://github.com/GoogleCloudPlatform/microservices-demo). Це хмарна демонстраційна програма для мікросервісів. Online Boutique складається з 11 мікросервісів, які написані на різних мовах програмування.  
Це веб-додаток для електронної комерції, де користувачі можуть переглядати товари, додавати їх у кошик та купувати.

| Мікросервіс                                          | Мова програмування | Опис                                                                                                                                       |
|------------------------------------------------------|--------------------|--------------------------------------------------------------------------------------------------------------------------------------------|
| [frontend](./src/frontend)                           | Go                 | HTTP-сервер для обслуговування веб-сайту. Не потребує реєстрації/входу та автоматично генерує ідентифікатори сеансу для всіх користувачів. |
| [cartservice](./src/cartservice)                     | C#                 | Зберігає товари в кошику користувача в Redis і отримує їх.                                                                                 |
| [productcatalogservice](./src/productcatalogservice) | Go                 | Надає список продуктів із файлу JSON і можливість пошуку продуктів і отримання окремих продуктів.                                          |
| [currencyservice](./src/currencyservice)             | Node.js            | Конвертує одну грошову суму в іншу валюту. Використовує реальні значення, отримані від Європейського центрального банку.                   |
| [paymentservice](./src/paymentservice)               | Node.js            | Стягує з указаної інформації кредитної картки (фіктивну) вказану суму та повертає ідентифікатор транзакції.                                |
| [shippingservice](./src/shippingservice)             | Go                 | Дає оцінку вартості доставки на основі кошика для покупок. Відправляє товари за вказаною адресою (імітація)                                |
| [emailservice](./src/emailservice)                   | Python             | Надсилає користувачам електронний лист із підтвердженням замовлення (макет).                                                               |
| [checkoutservice](./src/checkoutservice)             | Go                 | Отримує кошик користувача, готує замовлення та організовує оплату, доставку та сповіщення електронною поштою.                              |
| [recommendationservice](./src/recommendationservice) | Python             | Рекомендує інші продукти на основі того, що надано в кошику.                                                                               |
| [adservice](./src/adservice)                         | Java               | Надає текстові оголошення на основі заданих контекстних слів.                                                                              |
| [loadgenerator](./src/loadgenerator)                 | Python/Locust      | Постійно надсилає запити, що імітують реалістичні потоки покупок користувачів, до інтерфейсу.                                              |

![Architecture of
microservices](./docs/architecture-diagram.png)

## Мета проекту

Мені, як Devops спеціалісту, було потрібно вдосконалити наступні навички:

- робота с Docker, збирання образів
- робота з on-line сервісом GitLab:
    - GitLab CI/CD, gitlab-runner
    - GitLab private Docker registry
    - GitLab Terraform state files registry
    - інтегрування з кластерами Kubernetes
- робота з Ansible
- робота з Terraform
- робота з хмарними сервісами AWS:
    - EKS
    - Route53
    - VPC
    - IAM
    - ALB
    - EC2
- створення на базі bare-metal серверів та гіпервізору Proxmox інфраструктури для хостингу Kubernetes 
- вивчення підходів та інструментів для автоматичного створення документації по інфраструктурі

### Подальші плани

- AWS Cloud Watch, AWS Cloud Trail
- Google Cloud Platform
- ELK Stack або Loki
- Istio Service Mesh
- Prometheus
- Grafana
- системи **documentation as code** на кшталт Hugo або Docuzaurus
- інтегрування Hashicorp Vault з Gitlab, Rancher, AWS EKS

## Програмні засоби

| Назва                  | Для чого використовувався                                                                                                                              |
|------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------|
| Docker, Docker Compose | Складання образів Docker, запуск декількох образів в одному робочому процесі                                                                           |
| Сервіс GitLab.com     | Хостинг програмного коду, хостинг приватного реєстру docker, deploy контейнерів в Kubernetes, хостинг Terraform state, Ci/CD з допомогою gitlab-runner |
| Ansible                | Автоматичне розгортання Rancher на віртуальних машинах                                                                                                 |
| Terraform              | Створення кластера EKS на AWS, та супутніх сервісів – Route53, ELB, KMS, VPC                                                                         |
| Rancher                | Розгортання та адміністрування Kubernetes на віртуальних машинах                                                                                       |
| merge-markdown         | Автоматична компіляція html сайту, та Readme.md з документацією по всім розділам                                                                       |
| ansible-autodoc            | Автоматичне створення документації з коментарів коду Ansible role                                                                                     |
| terraform-doc          | Автоматичне створення документації з коментарів коду Terraform файлів                                                                                 |

## Модель процесу розробки

Структуру розробки можна поділити на три складові:

1. Програмний код, який супроводжується розробниками
2. Створення Docker-образів з програмного коду, хостинг образів в приватному реєстрі Docker
3. Запуск та оркестрування контейнерів на базі цих образів

Для ускладнення проекту програмний код всіх мікросервісів був об'єднаний в monorepo, яка знаходиться в `./src`

Використовується схема `gitflow`:

![GitLab Flow](/home/devps/projects/active/microservices-demo-google/docs/gitlab_flow.png)

1. dev – основна гілка розробки.
2. stage – гілка для тестування (UAT – User Acceptible Testing)
3. production – гілка, на основі якої працює продуктивне середовище

## Середовища розробки

### Середовище dev

Розгортується на комп'ютері розробника. Складання образу відбувається в Docker за допомогою `gitlab-runner`. Він може працювати на комп'ютері розробника, або на окремому сервері. Після складання образ публікується у приватному реєстрі на GitLab. Йому призначаються теги -- `latest`, та git `short sha1`.

Це дозволяє використовувати образи, які складені іншими розробниками. Їх можна знаходити по схемі:

**№ завдання в Jira** ===> **№ у назві git-branch** ===> **git short-sha** ===> **docker-image: short-sha1**

Запуск та розгортання відбувається в `docker-compose.yml`. Спочатку там використовуються образи з тегом latest.

Рекомендується добавити  `docker-compose.yml` в `.gitignore`, та потім використовувати робочі теги ( `latest` , `short sha1`).

### Середовище stage

В моєму випадку використовувались 5 віртуальних машин: 2 ядра CPU, 4-8 Gb оперативної пам'яті, Ubuntu 20. Зовнішній
доступ — фіксований зовнішній IP, віртуальна машина з PFSense + Haproxy.

На базі **Rancher** був розгорнутий кластер Kubernetes з окремим namespace для цього проекту. Також було підключено приватне сховище GitLab для образів Docker. Зовнішній трафік був спрямований на **PFSense** + **Haproxy** з використанням Letsencrypt для SSL-termination, далі він пересилався на `NodeIP` кластера Kubernetes
