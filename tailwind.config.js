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
    require('@tailwindcss/forms'),
  ],

  theme: {
    extend: {
      boxShadow: {
        '3xl': '0 0 120px rgba(0, 0, 0, 0.3)',
      },
      maxHeight: {
        '1/2': '50vh',
      }
    },
    minHeight: {
      '1/2': '50%',
      '2/3': '66%',
    },
    maxWidth: {
      '1/2': '50%',
      '2/3': '66%',
      '4/5': '80%',
    },
    fontFamily: {
      // 'sans': 'ALS Schlangesans, Calibri, Muller, sans-serif',
      "sans": ['ui-monospace'],
      "sefif": ['ui-monospace'],
      "mono": ['ui-monospace'],

    },
    container: {
      center: true
    },
    colors: {
      primary: {
        100: "#d3dced",
        200: "#a7b9da",
        300: "#7a97c8",
        400: "#4e74b5",
        500: "#2251a3",
        600: "#1b4182",
        700: "#143162",
        800: "#0e2041",
        900: "#071021"
      },
      secondary: {
        100: "#fbd1da",
        200: "#f7a3b5",
        300: "#f37590",
        400: "#ef476b",
        500: "#eb1946",
        600: "#bc1438",
        700: "#8d0f2a",
        800: "#5e0a1c",
        900: "#2f050e"
      },
      itmo_misc_1: {
        100: "#fde5d3",
        200: "#fbcba8",
        300: "#f9b27c",
        400: "#f79851",
        500: "#f57e25",
        600: "#c4651e",
        700: "#934c16",
        800: "#62320f",
        900: "#311907"
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
