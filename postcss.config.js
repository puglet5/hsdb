/* eslint-disable */

module.exports = {
  plugins: [
    require("tailwindcss"),
    require("postcss-nested"),
    require("autoprefixer"),
    require("cssnano")({
      preset: ["default", {
        discardComments: {
          removeAll: true,
        },
      }]
    }),
  ]
}
