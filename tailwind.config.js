// const colors = require('tailwindcss/colors')

module.exports = {
  darkMode: 'class',
  mode: "jit",
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js',
    './node_modules/tw-elements/dist/js/**/*.js'
  ],
  plugins: [
    require('flowbite/plugin'),
  ],

  theme: {
    minHeight: {
      '1/2': '50%',
      '2/3': '66%',
    },
    fontFamily: {
      'sans': 'ALS Schlangesans, Calibri, Muller, sans-serif',
    },
    container: {
      center: true
    },
    colors: {
      itmo_primary: {
        500: "#2251a3",
        400: "#2251a3",
        300: "#8fa7d0",
        200: "#c6d2e7"
      },
      itmo_secondary: {
        500: "#eb1946",
        400: "#f05274",
        300: "#f48ba1",
        200: "#f9c4d0"
      },
      itmo_misc_1: {
        500: "#f57e25",
      },
      itmo_misc_2: {
        500: "#3fb1e5",
      },
      itmo_misc_3: {
        500: "#96c93d",
      },
      itmo_misc_4: {
        500: "#22ac9b",
      },
      itmo_misc_5: {
        500: "#4bd932",
      },
      itmo_misc_6: {
        500: "#ffd600",
      },
      itmo_misc_7: {
        500: "#eee809",
      },
      itmo_misc_8: {
        500: "#ef3ed2",
      },
      itmo_misc_9: {
        500: "#00914d",
      },
    }
  }
}
