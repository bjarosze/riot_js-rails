# RiotJs::Rails

Muut Riot integration with Rails

## Requirements

 1. Nodejs - for tags compiling.
 2. jQuery - for tags mounting (if you're going to use helpers provided by gem).


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

Put all your components somewhere into ```assets/javascript```. All components tags must have ```.tag``` extension and need to be required in your ```application.js```. This will compile component to Javascript.


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
<example-tag id="riot-example-tag-2822884" class="riot-rails-component"></example-tag>
```
and immediate mount it with given options.

You can also use HTML element as tag:
```ruby
<%= riot_component(:div, :example_tag, { :header => 'Some header' }) %>
```
which will generate following code:
```html
<div id="riot-example-tag-5012227" class="riot-rails-component" riot-tag="example-tag"></div>
```

To generate tag with content use block:
```ruby
<%= riot_component(:example_tag, { :header => 'Some header' }) do %>
  <p>Content</p>
<% end %>
```

# HAML, SASS and CoffeeScript

You can define tag using HAML, SASS and CoffeeScript. Example:
```haml
%example-haml
  %h1{ onclick: "{change_header}" }
    = "{header}"

  :scss
    timer-haml {
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

## Contributing

1. Fork it ( https://github.com/[my-github-username]/riot_js-rails/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
