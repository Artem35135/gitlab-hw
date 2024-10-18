# Домашнее задание к занятию "GitLab" - "Засим Артем"



---

### Задание 1

https://github.com/Artem35135/gitlab-hw/blob/main/img/gitlab_1.png
https://github.com/Artem35135/gitlab-hw/blob/main/img/gitlab_2.png


---

### Задание 2

Поле для вставки кода...

cat .gitlab-ci.yml 
stages:
  - test
  - build

test:
  stage: test
  image: golang:1.17
  script:
   - go test .

build:
  stage: build
  image: docker:latest
  script:
   - docker build .


https://github.com/Artem35135/gitlab-hw/blob/main/img/gitlab_3.png
https://github.com/Artem35135/gitlab-hw/blob/main/img/gitlab_4.png

