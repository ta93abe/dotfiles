# Claude Code configuration
# =============================================================================
# This module is split into multiple files for maintainability:
# - claude/settings.nix    : Global settings (settings.json)
# - claude/commands.nix    : Custom commands
# - claude/skills.nix      : Custom skills
# - claude/agents/         : Custom agents by category
#   - design.nix
#   - engineering.nix
#   - marketing.nix
#   - product.nix
#   - project-management.nix
#   - studio-operations.nix
#   - testing.nix
# =============================================================================
{ config, pkgs, lib, ... }:

{
  imports = [
    # Global settings
    ./claude/settings.nix

    # Custom commands
    ./claude/commands.nix

    # Custom skills
    ./claude/skills.nix

    # Custom agents by category
    ./claude/agents/design.nix
    ./claude/agents/engineering.nix
    ./claude/agents/marketing.nix
    ./claude/agents/product.nix
    ./claude/agents/project-management.nix
    ./claude/agents/studio-operations.nix
    ./claude/agents/testing.nix
  ];

  # Claude Code configuration managed by Nix
  # Runtime data (cache, history, debug, etc.) is not managed - only declarative configs
}
