# website

Personal website — [Astro](https://astro.build) + Tailwind CSS, served as a static site from a Cloudflare Worker (Workers Static Assets).

## Commands

| Command              | Action                                             |
| -------------------- | -------------------------------------------------- |
| `npm install`        | Install dependencies                               |
| `npm run dev`        | Start the dev server at `localhost:4321`           |
| `npm run build`      | Build the static site into `./dist/`               |
| `npm run cf:preview` | Build + run locally on the Worker runtime          |
| `npm run deploy`     | Build + deploy to Cloudflare (`wrangler deploy`)   |

First time: `npx wrangler login`.
