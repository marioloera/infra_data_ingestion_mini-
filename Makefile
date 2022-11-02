install:
	pip install -r requirements.txt


lint:
	terraform fmt -recursive
	pre-commit run --all


lint-ci:
	pre-commit run --all
