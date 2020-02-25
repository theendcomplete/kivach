# kivach_recipes API



## Стэк
+ PostgreSQL (https://www.postgresql.org/)
+ Ruby on Rails (http://rubyonrails.org/)

## Интеграция
Осуществляется при помощи Capistrano (http://capistranorb.com/).

## Песочница
Для отладки и тестирования доступна песочница по адресу https://api.kivach-recipes.alpha.trinitydigital.ru, обновление сервера осуществляется двумя путями:

+ Загрузка обновлений в ветку `alpha`: `git checkout alpha && git merge changeset && git push origin alpha`
+ Непосредственный вызов задачи `deploy`: `git checkout alpha && bundle install && bundle exec cap alpha deploy`
## Импорт рецептов
Импорт рецептов осуществляется через capistrano task.

Для импорта требуется:

+ Положить файл с рецептами `receipts.xlsx` в директорию `shared/import/` на сервере
+ Положить файлы изображений рецептов в папку `shared/import/images/` на сервере
+ Запустить таск командой `bundle exec cap alpha deploy:seed`, где вместо `alpha` указать требуемое окружение. Для окружения `development` команда будет выглядеть так: `bin/rails db:seed` 

## Код
Общие рекомендации по стилю кодирования: https://github.com/bbatsov/ruby-style-guide

## Пагинация
Используется gem kaminari (https://github.com/kaminari/kaminari)

## Дата и время
Все временные метки форматируются в https://en.wikipedia.org/wiki/ISO_8601

## Редактирование секретного хранилища
`EDITOR="nano" bin/rails credentials:edit --environment development`

## Запуск локально
Создаем БД PostgreSQL:
```
sudo su postgres
psql
CREATE USER kivach_recipes;
ALTER ROLE kivach_recipes SUPERUSER;
ALTER USER kivach_recipes WITH PASSWORD 'kivach_recipes';
CREATE DATABASE kivach_recipes OWNER kivach_recipes;
```

Устанавливаем зависимости:
`bundle install`

Запускаем миграции:
`rails db:migrate`

Запускаем миграции данных:
`RAILS_ENV=development rails db:seed`

Запуск:
`rails s`
