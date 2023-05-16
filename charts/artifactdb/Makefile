PROJECT_NAME = $(shell basename `pwd ` | tr '[:upper:]' '[:lower:]')

chart:
	helm package .

push:
	@test $${env?Please pass env=[ENV]}
	helm cm-push artifactdb-*.tgz adb-$(env)

push-dev:
	make push env=dev

push-prd:
	make push env=prd
