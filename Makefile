.PHONY: all

CLUSTER := ecs-deploy-rails
ECR_REPOSITORIE := ecs-deploy-rails

all: configure login build push down up

login:
	$(aws ecr get-login --no-include-email)

configure:
	ecs-cli configure --cluster $(CLUSTER) --region $(REGION)

build:
	docker build -f ./Dockerfile.production -t $(ECR_REPOSITORIE) .
	docker tag $(ECR_REPOSITORIE) $(ECR_ENDPOINT)/$(ECR_REPOSITORIE)

push: login
	docker push $(ECR_ENDPOINT)/$(ECR_REPOSITORIE)

down: login
	ecs-cli compose -f docker-compose.production.yml down

up: login
	ecs-cli compose -f docker-compose.production.yml up
