/* eslint-disable */

module.exports = {
  plugins: [
    require('tailwindcss/nesting')(require('postcss-nesting')),
    require("tailwindcss"),
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
