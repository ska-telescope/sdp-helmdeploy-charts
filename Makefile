.PHONY: chart-repo

chart-repo: ## Update the packaged charts
	helm package charts/* -d chart-repo
	helm repo index chart-repo
