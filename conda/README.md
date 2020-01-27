# Conda Recipes

Contained within this directory are two conda recipes for building "dev" &
"release" packages & uploading to Anaconda Cloud.

Examples below assume working directory is repo root.

At some point, these recipes should probably be run by CI automatically.

## Dev build

Pulls latest commit, version is most recent tag & build number is
concatentation of (number of commits since tag) & (current commit hash).

Should be uploaded with `dev` label.

```bash
$ conda build --label dev conda/dev/
```

## Release build

Pulls tag specified by `RELEASE_TAG` env var, version is this tag &
build number is 0.

Sould be uploaded with `main` label.

```bash
$ RELEASE_TAG=0.1.3 conda build conda/release/
```