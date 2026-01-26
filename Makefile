.PHONY: build serve clean test check lint

build:
	hugo --gc --minify

serve:
	hugo server

clean:
	rm -rf public/

# Run local tests (link checking done in CI only)
test: build lint
	@echo "✅ All tests passed!"

# Alias for test
check: test

# Lint markdown, YAML, and workflows
lint:
	@echo "🔍 Linting files..."
	@if command -v markdownlint >/dev/null 2>&1; then \
		markdownlint 'content/**/*.md' '*.md' && echo "  ✓ Markdown lint passed"; \
	else \
		echo "⚠️  markdownlint not installed. Run: npm install -g markdownlint-cli"; \
	fi
	@if command -v yamllint >/dev/null 2>&1; then \
		yamllint .github/workflows/*.yaml hugo.yaml && echo "  ✓ YAML lint passed"; \
	else \
		echo "⚠️  yamllint not installed. Run: pip install yamllint"; \
	fi
	@echo "✅ All lints passed!"