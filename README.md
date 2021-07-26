# README

# General information:

Ruby version: 3.0.0p0

Rails 

# Dependencies:

This app derectly depends on graphicsmagick for image processing:

`sudo apt-get install -y graphicsmagick`



---

You can optionaly install foreman for faster compilation:

```ruby
gem install foreman
```

Use the following command to start the server:

```ruby
foreman start -f Procfile.dev
```

Procfile.dev is included in the repository's root.

*Note:* Do not [include foreman](https://github.com/ddollar/foreman/wiki/Don't-Bundle-Foremanhttps://) in Gemfile.
