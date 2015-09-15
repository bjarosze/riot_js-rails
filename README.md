# RiotJs::Rails

Muut Riot integration with Rails

## Requirements

 1. Nodejs - for tags compiling.
 2. jQuery - for tags mounting (if you're going to use helpers provided by gem).
 3. Rails 3 and 4 supported


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'riot_js-rails'
```

Execute:

    $ bundle install
    
Add ```riot``` and ```riot_rails``` to your ```application.js```:
```
//= require riot
//= require riot_rails
```

## Usage

Put all your components somewhere into ```assets/javascript```. All components tags must have ```.tag``` extension (if you use older version of sprockets, try ```.js.tag```) and need to be required in your ```application.js```. This will compile component to Javascript.


## Helpers

Each component has to be mounted. It can be done by executing ```riot.mount``` in javascript, e.g.:
```javascript
$(function() {
  riot.mount('example-tag');
});
```


Alternative approach is to use view helper, e.g.:

```ruby
<%= riot_component(:example_tag, { :header => 'Some header' }) %>
```
This will generate following HTML:
```html
<example-tag data-opts="{&quot;header&quot;:&quot;Some header&quot;}" data-mount></example-tag>
```
and immediate mount it with given options.

You can also use HTML element as tag:
```ruby
<%= riot_component(:div, :example_tag, { :header => 'Some header' }) %>
```
which will generate following code:
```html
<div data-opts="{&quot;header&quot;:&quot;Some header&quot;}" data-mount riot-tag="example-tag"></div>
```

To generate tag with content use block:
```ruby
<%= riot_component(:example_tag, { :header => 'Some header' }) do %>
  <p>Content</p>
<% end %>
```

If you want to add your own classes to component or any other attributes, pass it as last argument:
```ruby
<%= riot_component(:div, :example_tag, { :header => 'Some header' }, { class: 'my-class' }) %>
```

If you don't want to use helper you can use plain HTML:
```html
<example-tag data-riot></example-tag>
```

# Built-in preprocessing

You can use one of the Riot built-in preprocessors for javascript.
Available options are: "coffee", "typescript", "es6" and "none"

Example:
```
<my-tag>
  <script type="coffee">
    # your coffeescript logic goes here
  </script>
</my-tag>
```

Note that this may require some extra NodeJS modules. Riot-rails uses by default global modules installed by npm (installed with option ```-g```).
If you want to use local modules add following line to your ```config/application.rb```:
```
config.riot.node_paths << '/path/to/your/node_modules'
```

# Rails preprocessing: HAML, SASS and CoffeeScript

You can define tag using HAML, SASS and CoffeeScript. Example:
```haml
%example-haml
  %h1{ onclick: "{change_header}" }
    = "{header}"

  :scss
    example-haml {
      h1 {
        background-color: #ffff00;
      }
    }

  :coffee
    self = this
    this.header = opts.header

    this.change_header = ()->
      self.header = 'New header'
```

Note: file has to have ```.tag.haml``` extension (or ```.js.tag.haml``` for older version of Sprockets)

## Contributing

1. Fork it ( https://github.com/[my-github-username]/riot_js-rails/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
