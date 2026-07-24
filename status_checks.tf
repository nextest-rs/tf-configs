locals {
  # Repos that need required status checks layered on top of the org-wide baseline.
  # Everything else is covered by the org ruleset.
  repo_status_checks = {
    "nextest"     = ["codecov/patch", "codecov/project"]
    "quick-junit" = ["codecov/patch"]
  }
}
