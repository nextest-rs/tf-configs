# nextest-rs tf configs

OpenTofu configuration that codifies GitHub settings for the [`nextest-rs`](https://github.com/nextest-rs) organization.

## Running locally

```sh
export GITHUB_TOKEN="$(gh auth token)"
export AWS_ACCESS_KEY_ID='<r2-access-key-id>'
export AWS_SECRET_ACCESS_KEY='<r2-secret-access-key>'

tofu init
tofu plan
tofu apply
```
