# Як створювати та оновлювати документацію по проекту

Документация створюється шляхом об\`єднання :

- файлів *.md з каталогу `./docs/`, які створюються самостійно
- файлів *.md з каталогу `./ansible/roles/rancher-cluster/docs/doc`, які створюються і самостійно, і автоматично за допомогою `ansible-autodoc`
- файлу Readme.md з каталогу `./terraform/doc/`, якій створюється автоматично за допомогою `terraform-docs`

за допомогою утіліти `merge-markdown`

Для автоматичного створення використовується bash скріпт `./tools/makedocs.sh`

**Конфигураційні файли утіліт та документация:**

1. ansible-autodoc — `./ansible/autodoc.conf.yaml`. [Документація по роботі](https://github.com/AndresBott/ansible-autodoc)

2. terraform-docs — `./terraform/.terraform-docs.yml`. [Документація по роботі](https://terraform-docs.io/user-guide/introduction/)

3. merge-markdown — `./docs/makedocs.yml` [Документація по роботі](https://github.com/knennigtri/merge-markdown)

   

**Всі зображення та схеми потрібно зберігати в каталозі `./img`**