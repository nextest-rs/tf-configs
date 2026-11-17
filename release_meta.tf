locals {
  # Repos served as install/redirect origins -- each is written only by its dedicated
  # GitHub App.
  release_meta_repos = {
    "release-meta" = {
      description = "Release metadata for nextest"
      app_slug    = "nextest-release-meta"
      app_id      = 5792723
    }
    "mukti-release-meta" = {
      description = "Test repo for release flow for mukti"
      app_slug    = "mukti-release-meta"
      app_id      = 5792751
    }
  }
}

import {
  to = github_repository.release_meta["release-meta"]
  id = "release-meta"
}

import {
  to = github_repository.release_meta["mukti-release-meta"]
  id = "mukti-release-meta"
}

resource "github_repository" "release_meta" {
  for_each = local.release_meta_repos

  name        = each.key
  description = each.value.description
  visibility  = "public"

  has_issues      = false
  has_wiki        = false
  has_projects    = false
  has_discussions = false

  # The org ruleset requires linear history, so merge commits are not allowed.
  allow_merge_commit     = false
  allow_squash_merge     = true
  allow_rebase_merge     = true
  allow_auto_merge       = false
  delete_branch_on_merge = true

  security_and_analysis {
    secret_scanning {
      status = "enabled"
    }
    secret_scanning_push_protection {
      status = "enabled"
    }
  }

  archive_on_destroy = true

  lifecycle {
    prevent_destroy = true
  }
}

# Disable Actions for these repos to avoid a write path.
resource "github_actions_repository_permissions" "release_meta" {
  for_each = local.release_meta_repos

  repository = github_repository.release_meta[each.key].name
  enabled    = false
}
