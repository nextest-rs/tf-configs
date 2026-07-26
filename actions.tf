resource "github_actions_organization_permissions" "this" {
  enabled_repositories = "all"
  allowed_actions      = "selected"

  allowed_actions_config {
    github_owned_allowed = true
    verified_allowed     = true

    # Enumerated from actions actually used across org workflows.
    # Add new third-party actions here.
    patterns_allowed = [
      "Swatinem/rust-cache@*",
      "actions-rs/*",
      "cloudflare/*",
      "codecov/*",
      "dtolnay/rust-toolchain@*",
      "eifinger/setup-uv@*",
      "michidk/run-komac@*",
      "model-checking/kani-github-action@*",
      "opentofu/setup-opentofu@*",
      "renovatebot/github-action@*",
      "rust-lang/crates-io-auth-action@*",
      "signpath/github-action-submit-signing-request@*",
      "taiki-e/*",
      "trunk-io/analytics-uploader@*",
      "zizmorcore/zizmor-action@*",
    ]
  }
}
