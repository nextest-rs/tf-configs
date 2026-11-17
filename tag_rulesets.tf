# Every tag push triggers release workflows in these repos, so all tags are admin-only.
resource "github_repository_ruleset" "protect_release_tags" {
  for_each = toset(["nextest", "mukti"])

  name        = "protect-release-tags"
  repository  = each.key
  target      = "tag"
  enforcement = "active"

  conditions {
    ref_name {
      include = ["~ALL"]
      exclude = []
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
