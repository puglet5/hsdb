import { application } from "./application.ts"
// Support for globs in esbuild is added by esbuild-rails plugin
// @ts-expect-error
import controllers from "./**/*_controller.*"

controllers.forEach((controller) => {
  application.register(controller.name, controller.module.default)
})
