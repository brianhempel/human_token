require 'bundler/setup'
Bundler.require(:test)

require 'human_token'
require 'minitest/autorun'
require 'minitest/reporters'
MiniTest::Reporters.use! Minitest::Reporters::DefaultReporter.new

class TestHumanToken < Minitest::Test
  def test_generate
    token = HumanToken.generate
    assert_equal 27, token.length
  end

  def test_generate_with_bytes_given
    token = HumanToken.generate(8)
    assert_equal 14, token.length
  end

  def test_generate_with_exact_bytes_given
    token = HumanToken.generate(exact_bytes: 8)
    assert_equal 14, token.length
  end

  def test_generate_with_different_base
    token = HumanToken.generate(base: BaseX::Base58)
    assert_equal 22, token.length
  end

  def test_floating_point_math_works
    token = HumanToken.generate(5, base: BaseX.base(32))
    assert_equal 8, token.length
  end

  def test_custom_characters
    token = HumanToken.generate(6, characters: "asdfjkl;")
    assert_equal 16, token.length
  end

  def test_base_30
    token = HumanToken.base_30
    assert_equal 27, token.length
    token = HumanToken.base_30(exact_bytes: 32)
    assert_equal 53, token.length
  end

  def test_base_31
    token = HumanToken.base_31
    assert_equal 26, token.length
  end

  def test_base_32
    token = HumanToken.base_32
    assert_equal 26, token.length
  end

  def test_base_58
    token = HumanToken.base_58
    assert_equal 22, token.length
  end

  def test_new_base_60
    token = HumanToken.new_base_60
    assert_equal 22, token.length
  end

  def test_base_62
    token = HumanToken.base_62
    assert_equal 22, token.length
  end

  def test_hex
    token = HumanToken.hex
    assert_equal 32, token.length
  end

  def test_samples
    HumanToken.send(:samples_string) # doesn't error
  end
end
