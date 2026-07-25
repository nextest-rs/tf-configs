resource "github_organization_ruleset" "protect_default_branch" {
  name        = "protect-default-branch"
  target      = "branch"
  enforcement = "active"

  conditions {
    ref_name {
      include = ["~DEFAULT_BRANCH"]
      exclude = []
    }

    repository_name {
      include = ["~ALL"]
      # Forks aren't worth protecting.
      exclude = ["winget-pkgs", "schemastore"]
    }
  }

  rules {
    required_linear_history = true
    non_fast_forward        = true
    deletion                = true
  }

  # Org owners can bypass requirements.
  bypass_actors {
    actor_id    = 0
    actor_type  = "OrganizationAdmin"
    bypass_mode = "always"
  }
}

# Per-repo status checks are layered on top.
resource "github_repository_ruleset" "required_status_checks" {
  for_each = local.repo_status_checks

  name        = "required-status-checks"
  repository  = each.key
  target      = "branch"
  enforcement = "active"

  conditions {
    ref_name {
      include = ["~DEFAULT_BRANCH"]
      exclude = []
    }
  }

  rules {
    required_status_checks {
      dynamic "required_check" {
        for_each = each.value
        content {
          context = required_check.value
        }
      }
      strict_required_status_checks_policy = false
    }
  }
}
