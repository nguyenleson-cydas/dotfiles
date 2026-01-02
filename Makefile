.PHONY: install uninstall restow install-nvim install-starship install-tmux install-zsh install-fish install-lazygit install-ghostty install-scripts install-eza install-markdownlint-cli2 uninstall-eza uninstall-markdownlint-cli2 uninstall-fish help

# Colors for output
GREEN := \033[0;32m
YELLOW := \033[0;33m
NC := \033[0m # No Color

# All packages
PACKAGES := nvim starship tmux zsh fish lazygit ghostty scripts eza markdownlint-cli2

help: ## Show this help message
	@echo "Usage: make [target]"
	@echo ""
	@echo "Available targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  ${GREEN}%-15s${NC} %s\n", $$1, $$2}'

install: ## Install all dotfiles
	@echo "${GREEN}Installing all dotfiles...${NC}"
	@stow $(PACKAGES)
	@echo "${GREEN}✓ All dotfiles installed${NC}"

uninstall: ## Uninstall all dotfiles
	@echo "${YELLOW}Uninstalling all dotfiles...${NC}"
	@stow -D $(PACKAGES)
	@echo "${YELLOW}✓ All dotfiles uninstalled${NC}"

restow: ## Restow all dotfiles (useful after updates)
	@echo "${GREEN}Restowing all dotfiles...${NC}"
	@stow -R $(PACKAGES)
	@echo "${GREEN}✓ All dotfiles restowed${NC}"

install-nvim: ## Install only neovim config
	@echo "${GREEN}Installing nvim...${NC}"
	@stow nvim
	@echo "${GREEN}✓ nvim installed${NC}"

install-starship: ## Install only starship config
	@echo "${GREEN}Installing starship...${NC}"
	@stow starship
	@echo "${GREEN}✓ starship installed${NC}"

install-tmux: ## Install only tmux config
	@echo "${GREEN}Installing tmux...${NC}"
	@stow tmux
	@echo "${GREEN}✓ tmux installed${NC}"

install-zsh: ## Install only zsh config
	@echo "${GREEN}Installing zsh...${NC}"
	@stow zsh
	@echo "${GREEN}✓ zsh installed${NC}"

install-fish: ## Install only fish config
	@echo "${GREEN}Installing fish...${NC}"
	@stow fish
	@echo "${GREEN}✓ fish installed${NC}"

install-lazygit: ## Install only lazygit config
	@echo "${GREEN}Installing lazygit...${NC}"
	@stow lazygit
	@echo "${GREEN}✓ lazygit installed${NC}"

install-ghostty: ## Install only ghostty config
	@echo "${GREEN}Installing ghostty...${NC}"
	@stow ghostty
	@echo "${GREEN}✓ ghostty installed${NC}"

install-scripts: ## Install only scripts
	@echo "${GREEN}Installing scripts...${NC}"
	@stow scripts
	@echo "${GREEN}✓ scripts installed${NC}"

install-eza: ## Install only eza config
	@echo "${GREEN}Installing eza...${NC}"
	@stow eza
	@echo "${GREEN}✓ eza installed${NC}"

install-markdownlint-cli2: ## Install only markdownlint-cli2 config
	@echo "${GREEN}Installing markdownlint-cli2...${NC}"
	@stow markdownlint-cli2
	@echo "${GREEN}✓ markdownlint-cli2 installed${NC}"

uninstall-nvim: ## Uninstall neovim config
	@echo "${YELLOW}Uninstalling nvim...${NC}"
	@stow -D nvim
	@echo "${YELLOW}✓ nvim uninstalled${NC}"

uninstall-starship: ## Uninstall starship config
	@echo "${YELLOW}Uninstalling starship...${NC}"
	@stow -D starship
	@echo "${YELLOW}✓ starship uninstalled${NC}"

uninstall-tmux: ## Uninstall tmux config
	@echo "${YELLOW}Uninstalling tmux...${NC}"
	@stow -D tmux
	@echo "${YELLOW}✓ tmux uninstalled${NC}"

uninstall-zsh: ## Uninstall zsh config
	@echo "${YELLOW}Uninstalling zsh...${NC}"
	@stow -D zsh
	@echo "${YELLOW}✓ zsh uninstalled${NC}"

uninstall-fish: ## Uninstall fish config
	@echo "${YELLOW}Uninstalling fish...${NC}"
	@stow -D fish
	@echo "${YELLOW}✓ fish uninstalled${NC}"

uninstall-lazygit: ## Uninstall lazygit config
	@echo "${YELLOW}Uninstalling lazygit...${NC}"
	@stow -D lazygit
	@echo "${YELLOW}✓ lazygit uninstalled${NC}"

uninstall-ghostty: ## Uninstall ghostty config
	@echo "${YELLOW}Uninstalling ghostty...${NC}"
	@stow -D ghostty
	@echo "${YELLOW}✓ ghostty uninstalled${NC}"

uninstall-scripts: ## Uninstall scripts
	@echo "${YELLOW}Uninstalling scripts...${NC}"
	@stow -D scripts
	@echo "${YELLOW}✓ scripts uninstalled${NC}"

uninstall-eza: ## Uninstall eza config
	@echo "${YELLOW}Uninstalling eza...${NC}"
	@stow -D eza
	@echo "${YELLOW}✓ eza uninstalled${NC}"

uninstall-markdownlint-cli2: ## Uninstall markdownlint-cli2 config
	@echo "${YELLOW}Uninstalling markdownlint-cli2...${NC}"
	@stow -D markdownlint-cli2
	@echo "${YELLOW}✓ markdownlint-cli2 uninstalled${NC}"

check: ## Check for conflicts before installing
	@echo "${GREEN}Checking for conflicts...${NC}"
	@stow -n $(PACKAGES)
	@echo "${GREEN}✓ No conflicts found${NC}"
