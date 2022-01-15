const webpack = require('webpack')
environment.plugins.prepend('Provide',
  new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery',
    Popper: ['popper.js', 'default'],
    toastr: 'toastr/toastr',
    ApexCharts: ['apexcharts', 'default'],
    underscore: ['underscore', 'm'],
    Rails: ['@rails/ujs']
  })
)

Encore.configureDevServerOptions(options => {
  options.allowedHosts = 'all';
  options.https = {
    cert: '/etc/apache2/ssl/domain.dev/fullchain.pem',
    key: '/etc/apache2/ssl/domain.dev/privkey.pem',
  };
  
  delete options.client.host;
})

module.exports = environment