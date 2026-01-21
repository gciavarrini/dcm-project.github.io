.PHONY: build serve clean test check lint

build:
	hugo --gc --minify

serve:
	hugo server

clean:
	rm -rf public/

# Run all tests that CI runs (local development)
test: build lint check-links
	@echo "✅ All tests passed!"

# Alias for test
check: test

# Lint markdown, YAML, and workflows
lint:
	@echo "🔍 Linting files..."
	@if command -v markdownlint >/dev/null 2>&1; then \
		markdownlint content/**/*.md *.md; \
	else \
		echo "⚠️  markdownlint not installed. Run: npm install -g markdownlint-cli"; \
	fi
	@if command -v yamllint >/dev/null 2>&1; then \
		yamllint .github/workflows/*.yaml hugo.yaml; \
	else \
		echo "⚠️  yamllint not installed. Run: pip install yamllint"; \
	fi

# Check for broken links
check-links: build
	@echo "🔗 Checking links..."
	@if command -v lychee >/dev/null 2>&1; then \
		lychee --exclude-loopback --exclude-private --exclude="mailto:" --exclude="https://github.com/dcm-project/enhancements/blob/main/" ./public; \
	else \
		echo "⚠️  lychee not installed. Run: cargo install lychee"; \
	fi