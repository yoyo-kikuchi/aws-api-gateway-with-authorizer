.PHONY: run

run:
	bundle exec ruby local_entrypoint.rb ${ARG}

gen_token:
	bundle exec ruby gen_jwt.rb

deploy:
	bash scripts/lambda_deploy.sh sample-rest-api-gateway-authorizer