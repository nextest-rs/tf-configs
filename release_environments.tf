locals {
  # These environments hold release-meta app keys -- only release tags may deploy to them.
  release_environments = {
    "nextest/release-binaries" = {
      repository  = "nextest"
      environment = "release-binaries"
      # internal-test-* is used by release-test.yml's binary builds.
      tag_patterns = ["cargo-nextest-*", "internal-test-*"]
    }
    "mukti/release-meta" = {
      repository   = "mukti"
      environment  = "release-meta"
      tag_patterns = ["mukti-bin-*"]
    }
  }

  release_environment_tag_patterns = merge([
    for key, env in local.release_environments : {
      for pattern in env.tag_patterns : "${key}/${pattern}" => {
        environment_key = key
        tag_pattern     = pattern
      }
    }
  ]...)
}

import {
  to = github_repository_environment.release["nextest/release-binaries"]
  id = "nextest:release-binaries"
}

import {
  to = github_repository_environment.release["mukti/release-meta"]
  id = "mukti:release-meta"
}

resource "github_repository_environment" "release" {
  for_each = local.release_environments

  repository  = each.value.repository
  environment = each.value.environment

  # Disable admins bypassing release-meta.
  can_admins_bypass = false

  deployment_branch_policy {
    protected_branches     = false
    custom_branch_policies = true
  }
}

resource "github_repository_environment_deployment_policy" "release_tag" {
  for_each = local.release_environment_tag_patterns

  repository  = github_repository_environment.release[each.value.environment_key].repository
  environment = github_repository_environment.release[each.value.environment_key].environment
  tag_pattern = each.value.tag_pattern
}
