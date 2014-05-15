require 'human_token/version'
require 'securerandom'
require 'base_x'

module HumanToken
  DEFAULTS = { bytes: 16, base: BaseX::Base30L }
  BASES = [
    [:hex,         BaseX::Base16L],
    [:base_30,     BaseX::Base30L],
    [:base_31,     BaseX::Base31L],
    [:base_32,     BaseX::CrockfordBase32],
    [:base_58,     BaseX::BitcoinBase58],
    [:new_base_60, BaseX::NewBase60],
    [:base_62,     BaseX::Base62DUL],
  ]

  def self.generate(*args)
    options = normalize_generate_options(args, DEFAULTS)
    base, bytes, exact_bytes = options[:base], options[:bytes], options[:exact_bytes]

    base = BaseX.new(options[:characters]) if options[:characters]

    if exact_bytes
      base.encode(SecureRandom.random_bytes(exact_bytes))
    else
      length = (Math.log(256)/Math.log(base.base)*bytes).ceil
      token  = base.encode(SecureRandom.random_bytes(bytes + 1))
      token[-length..-1]
    end
  end

  BASES.each do |name, base|
    define_singleton_method(name) do |*args|
      options = normalize_generate_options(args, base: base)
      generate(options)
    end
  end

  def self.samples(*args)
    STDERR.puts samples_string(*args)
  end

  class << self
    private

    def normalize_generate_options(args, defaults)
      defaults.dup.tap do |options|
        options[:bytes] = args.first if args.first.is_a?(Integer)
        args.grep(Hash).each {|hash| options.merge!(hash)}
      end
    end

    def samples_string(*args)
      longest_name_length = BASES.sort_by {|name, base| -name.size}.first[0].size
      BASES.map do |method_name, _|
        "%-#{longest_name_length}s %s" % [method_name, self.send(method_name, *args).inspect]
      end.join("\n")
    end
  end
end
