# stampla.org

The Stampla website — [Hugo](https://gohugo.io/), no theme dependency,
no external assets, zero JavaScript.

## Hugo is pinned

`.hugo-version` names the one Hugo this site is built with; CI reads it,
and the Cloudflare Pages `HUGO_VERSION` variables (managed in the
private infrastructure repository) must match it. A local package
manager upgrades Hugo on its own schedule, so a local build can quietly
differ from the one CI approved and visitors receive:

```console
$ scripts/install-hugo.sh        # fetch the pinned build into .bin/
$ scripts/check-hugo-version.sh  # assert the Hugo in use is the pinned one
```

## Develop

```console
$ hugo server --renderToMemory
```

`--renderToMemory` keeps the preview out of `public/`, so a preview
never shares an output directory with a production build.

## Build

```console
$ hugo --gc --minify
```

The site lands in `public/`. That exact command is what the deploy
runs; CI builds with `--printPathWarnings` on top and then link-checks
the output with lychee.

## Deploy contract

Cloudflare Pages builds exactly two branches. `release` is the
published site, fast-forwarded from green `main` deliberately
(`git push origin main:release`); `staging` builds the same preview
without publishing, at `staging.stampla-website.pages.dev`. `main` and
every other branch build nothing. Previews are marked `noindex` and
disallowed in robots.txt via `CF_PAGES_BRANCH`; a build with no such
variable (local, CI) is treated as production output, never as a
preview. Response headers, including the CSP, live in
`static/_headers`.
