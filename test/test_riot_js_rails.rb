require 'minitest_helper'
require 'riot_js/rails/processors/compiler'

class TestRiotJsRails < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::RiotJs::Rails::VERSION
  end

  def test_compiling_riot_tag
    tag_source = "<test-tag><h1>{test}</h1><style>test-tag h1 { background-color: #666666; }</style><script>this.test = opts.test</script></test-tag>"

    tag_compiled = ::RiotJs::Rails::Compiler.compile(tag_source)

    assert_equal "riot.tag('test-tag', '<h1>{test}</h1><style>test-tag h1 { background-color: #666666; }</style><script>this.test = opts.test</script>', function(opts) {\n});", tag_compiled
  end
end
