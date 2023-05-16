/* eslint-disable */

const path = require("path")
const rails = require("esbuild-rails")
const esbuild = require("esbuild");

esbuild.context({
  entryPoints: ["application.ts"],
  bundle: true,
  treeShaking: true,
  minify: process.argv.includes("--minify"),
  platform: 'browser',
  target: [
    'es2020',
  ],
  outdir: path.join(process.cwd(), "app/assets/builds"),
  absWorkingDir: path.join(process.cwd(), "app/javascript"),
  plugins: [rails()],
}).then(context => {
  if (process.argv.includes("--watch"))
    context.watch().then((context) => {
    })
  else
    context.rebuild().then(() => {
      context.dispose()
    })
})
