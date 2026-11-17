locals {
  # Repos that need required status checks layered on top of the org-wide baseline.
  # Everything else is covered by the org ruleset.
  #
  # codecov checks being required for nextest and quick-junit were turned off around
  # 2026-11 due to them being noticeably flaky.
  repo_status_checks = {}
}
