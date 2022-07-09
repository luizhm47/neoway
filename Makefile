.PHONY: image publish run run-docker test

# if you want to use your own registry, change "REGISTRY" value
#REGISTRY       = your.url.registry
#REGISTRY_USER   = your_registry_user
REGISTRY_USER   = gcr.io/calcium-storm-355421/github.com/luizhm47
NAME            = neoway
IMAGE           = $(REGISTRY_USER)/$(NAME):$(VERSION)

image: guard-VERSION ## Build image
	docker build -t $(IMAGE) .

login: guard-VERSION ## Publish image
	docker login

publish: guard-VERSION ## Publish image
	docker push $(IMAGE)

run: ## Run locally
	go run .

run-docker: guard-VERSION ## Run docker container
	#docker run --rm -d --name $(NAME) -d -p 5000:5000 $(REGISTRY_USER)/$(NAME):$(VERSION)
	gcloud run deploy $(NAME) --image $(REGISTRY_USER)/$(NAME):$(VERSION) --region us-south1 --memory 256Mi --max-instances 1 --port 5000 --allow-unauthenticated

test:
	go test -coverprofile=coverage.out ./...

guard-%:
	@ if [ "${${*}}" = ""  ]; then \
		echo "Variable '$*' not set"; \
		exit 1; \
	fi
