# AGENTS.md

Guidance for AI coding agents working in this repository.

## Overview

Personal website built with Astro 7 + Tailwind CSS 4 + MDX, deployed as a **fully static site** on a Cloudflare Worker using Workers Static Assets. There is no server-side code and no Cloudflare adapter: `astro build` writes HTML to `dist/`, and the Worker (configured in `wrangler.jsonc`) only serves those files. Keep `output: 'static'` unless the user explicitly asks for SSR (that would require adding `@astrojs/cloudflare`).

All code, file names, identifiers and site content are in **English**.

Planned features and ideas are tracked in `IDEAS.md`; tick items off there when they're implemented.

## Commands

- `npm run dev` — Astro dev server at `localhost:4321`. When starting it as an agent, use background mode: `astro dev --background`, managed with `astro dev stop`, `astro dev status` and `astro dev logs`
- `npm run build` — build static site into `dist/`; this is the main correctness check (there are no tests or linter configured)
- `npm run cf:preview` — build, then serve `dist/` through the real Worker runtime via `wrangler dev` (port 8787); use this to verify Worker-specific behavior like 404 handling and trailing slashes
- `npm run cv` — compile the CV from LaTeX (`scripts/build-cv.sh`): runs `pdflatex` on `cv/daniel-rama-cv.tex` into `cv/build/` (gitignored) and copies the PDF to `public/cv/daniel-rama-cv.pdf`. Run it after editing the `.tex`; it warns if lines overflow the margin
- `npm run deploy` — build + `wrangler deploy` (requires `npx wrangler login`; publishes to production, so only run when asked)

## Architecture

- **Routing:** file-based in `src/pages/`. `404.astro` builds to `404.html`, which the Worker serves for unknown URLs (`not_found_handling: "404-page"` in `wrangler.jsonc`).
- **Layout:** every page wraps its content in `src/layouts/Layout.astro`, which owns `<head>` (title/description props, favicons, sitemap link) and imports `src/styles/global.css`. That import is how Tailwind gets loaded, so new pages must use the layout.
- **Styling:** Tailwind v4 is configured in CSS, not a JS config: `global.css` has `@import "tailwindcss"` and `@plugin "@tailwindcss/typography"`. Dark mode uses `dark:` variants (system preference).
- **MDX content:** `.mdx` files in `src/content/` are imported directly as components (e.g. `index.astro` renders `src/content/intro.mdx`). They must be wrapped in a `prose` container, because Tailwind's preflight strips default heading and list styles. MDX can import components from `src/components/`; those components should use `not-prose` so typography styles don't leak into them.
- **Shared data:** social links (with inline SVG icon paths), affiliation logo links (Formula Student FEUP, NIFEUP; logos in `public/logos/`) and the CV URL live in `src/data/links.ts`; the navbar (in `Layout.astro`) has page links on the left — About and Contact are anchors to `#about`/`#contact` sections on the home page — and the `NAVBAR_LINKS` socials on the right. The `wide` prop on `Layout` widens the column (used by the CV page).
- **Breadcrumbs (required on every page except home):** `Layout` builds the `Home / ...` trail automatically from the URL and renders it via `src/components/Breadcrumbs.astro`, so any new page that uses `Layout` gets one for free — don't remove it or add separate "Back to home" links. Segment labels are title-cased; add exceptions to `CRUMB_LABELS` in `Layout.astro` (e.g. `cv` → `CV`), or pass a `breadcrumbs` prop to override the trail for one page.
- **Images:** images in `src/assets/` (e.g. `profile.webp`) go through `astro:assets` `<Image>` and are resized/optimized at build time; files in `public/` are served as-is.
- **CV:** the source of truth is `cv/daniel-rama-cv.tex` (kept outside `public/` so it isn't published). `npm run cv` generates `public/cv/daniel-rama-cv.pdf`, which is committed and served as a static file; never edit the PDF directly. `src/pages/cv.astro` embeds it with `<object>` and offers a download link.
- **Sitemap:** `@astrojs/sitemap` needs `site` in `astro.config.mjs`. It is still the placeholder `https://example.com` until the real domain is set.

## Documentation

Full documentation: https://docs.astro.build

Consult these guides before working on related tasks:

- [Adding pages, dynamic routes, or middleware](https://docs.astro.build/en/guides/routing/)
- [Working with Astro components](https://docs.astro.build/en/basics/astro-components/)
- [Using React, Vue, Svelte, or other framework components](https://docs.astro.build/en/guides/framework-components/)
- [Adding or managing content](https://docs.astro.build/en/guides/content-collections/)
- [Adding styles or using Tailwind](https://docs.astro.build/en/guides/styling/)
- [Supporting multiple languages](https://docs.astro.build/en/guides/internationalization/)
