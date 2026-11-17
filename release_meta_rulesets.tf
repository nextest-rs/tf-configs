# Only the repo's app pushes directly; admins must go through a PR. Layered on the org ruleset.
resource "github_repository_ruleset" "release_meta_default_branch" {
  for_each = local.release_meta_repos

  name        = "restrict-default-branch-updates"
  repository  = github_repository.release_meta[each.key].name
  target      = "branch"
  enforcement = "active"

  conditions {
    ref_name {
      include = ["~DEFAULT_BRANCH"]
      exclude = []
    }
  }

  rules {
    update = true
  }

  bypass_actors {
    actor_id    = each.value.app_id
    actor_type  = "Integration"
    bypass_mode = "always"
  }

  bypass_actors {
    actor_id    = 0
    actor_type  = "OrganizationAdmin"
    bypass_mode = "pull_request"
  }
}

# Keeps the app from creating branches.
resource "github_repository_ruleset" "release_meta_other_branches" {
  for_each = local.release_meta_repos

  name        = "restrict-other-branches"
  repository  = github_repository.release_meta[each.key].name
  target      = "branch"
  enforcement = "active"

  conditions {
    ref_name {
      include = ["~ALL"]
      exclude = ["~DEFAULT_BRANCH"]
    }
  }

  rules {
    creation = true
    update   = true
    deletion = true
  }

  bypass_actors {
    actor_id    = 0
    actor_type  = "OrganizationAdmin"
    bypass_mode = "always"
  }
}
