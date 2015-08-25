require 'minitest_helper'
require 'riot_js/rails/helper'

class TestRiotJsRailsHelper < ActionView::TestCase
  include ::RiotJs::Rails::Helper

  def test_selecting_custom_tag_helper
    self.expects(:custom_tag_riot_component).times(3)

    riot_component(:test_component, {})
    riot_component(:test_component, {}, {})
    riot_component(:test_component, {}, {}) { 'CONTENT' }
  end

  def test_selecting_html_tag_helper
    self.expects(:html_tag_riot_component).times(3)

    riot_component(:div, :test_component, {})
    riot_component(:div, :test_component, {}, {})
    riot_component(:div, :test_component, {}, {}) { 'CONTENT' }
  end

  def test_custom_tag_component_helper
    component = custom_tag_riot_component(:test_component, {test_model: 'TEST MODEL'},
                                          {class: 'test-class', data: {test: 'test data'}})

    assert_match /<test-component class="test-class riot-rails-component" data-test="test data" data-opts="{&quot;test_model&quot;:&quot;TEST MODEL&quot;}" id="riot-test-component-[0-9]+"><\/test-component>/, component
  end

  def test_custom_tag_component_helper_with_block
    component = custom_tag_riot_component(:test_component, {test_model: 'TEST MODEL'},
                                          {class: 'test-class', data: {test: 'test data'}}) { 'CONTENT' }

    assert_match /<test-component class="test-class riot-rails-component" data-test="test data" data-opts="{&quot;test_model&quot;:&quot;TEST MODEL&quot;}" id="riot-test-component-[0-9]+">CONTENT<\/test-component>/, component
  end

  def test_html_tag_component_helper
    component = html_tag_riot_component(:div, :test_component, {test_model: 'TEST MODEL'},
                                          {class: 'test-class', data: {test: 'test data'}})

    assert_match /<div class="test-class riot-rails-component" data-test="test data" data-opts="{&quot;test_model&quot;:&quot;TEST MODEL&quot;}" id="riot-test-component-[0-9]+" riot-tag="test-component"><\/div>/, component
  end

  def test_html_tag_component_helper_with_block
    component = html_tag_riot_component(:div, :test_component, {test_model: 'TEST MODEL'},
                                        {class: 'test-class', data: {test: 'test data'}}) { 'CONTENT' }

    assert_match /<div class="test-class riot-rails-component" data-test="test data" data-opts="{&quot;test_model&quot;:&quot;TEST MODEL&quot;}" id="riot-test-component-[0-9]+" riot-tag="test-component">CONTENT<\/div>/, component
  end

end
