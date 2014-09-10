# HumanToken

[![Gem Version](https://badge.fury.io/rb/human_token.svg)](http://badge.fury.io/rb/human_token)
[![Build Status](https://travis-ci.org/brianhempel/human_token.svg)](https://travis-ci.org/brianhempel/human_token)

HumanToken is a (relatively) human-friendly token generator. You can create tokens of a given cryptographic strength but without ambiguous characters.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'human_token'
```

And then execute:

```
$ bundle
```

Or install it yourself as:

```
$ gem install human_token
```

## Usage

HumanToken uses Ruby's SecureRandom to generate tokens.

```ruby
require 'human_token'

HumanToken.generate # => "2re9y4mdsh39jy4qqh3eq6tzptz"
```

Just like SecureRandom, the default is 16 bytes of randomness. However, the token is longer than 16 characters because, well, those 16 bytes aren't binary anymore.

You can specify an alternate number of bytes of randomness.

```ruby
# 64-bit token
HumanToken.generate(8) # => "nte4mh95kvxdde"
```

By default, tokens contain lowercase alphanumeric characters, with the exceptions of `0` `1` `i` `l` `o` `u`. Those characters are excluded to prevent ambiguity. The `i` and `o` are not ambiguous when lowercase, but are excluded anyway so the token can be treated case-insensitively: uppercase `I` and `O` are ambiguous.

The letter `u` is excluded because, if it were included, when generating 128 bit tokens about 1 in every 340 tokens would phonetically drop the f-bomb on the viewer—or even more often (a lot more often!) if we count a "u" proceed by an "f". [Douglas Crockford](http://www.crockford.com/wrmg/base32.html) is the inspiration for excluding "u", though he didn't enumerate the math.

The default tokens are lowercase because lowercase is much easier to read.

## Schemes

Several encoding schemes are provided.

```ruby
HumanToken.hex         # Lowercase hexadecimal (included for comparison purposes)
HumanToken.base_30     # Lowercase base 30, no 0 1 I L O U (this is the default scheme)
HumanToken.base_31     # Lowercase base 31, no 0 1 I L O
HumanToken.base_32     # Crockford's Base 32: Uppercase, no I L O U
HumanToken.base_58     # Bitcoin Base 58: Mixed case, no 0 I O l
HumanToken.new_base_60 # Tantek Çelik's "New Base 60": Mixed case and underscore, no I O l
HumanToken.base_62     # All 62 mixed case alphanumerics
```

You can provide a custom scheme.

```ruby
HumanToken.generate(6, characters: "aeiou")
# => "iauioieuoaeeeauiauuii"
```

Internally, HumanToken uses [BaseX](https://github.com/brianhempel/base_x) for encoding. A custom scheme can also be specified by providing a BaseX object.

```ruby
HumanToken.generate(32, base: BaseX.base(36))
# => "9KV0FL722DDYQ5IOFIJDB1DT0AIDUID6U0VUBCRC9IK7POQG9S"
```

For reference, in IRB you can get a list of all the provided schemes with a sample 128 bit token in each.

```
> HumanToken.samples
hex         "2c50e3ec571d5d662580e22de852147e"
base_30     "fwkt9zvwn4ara5n6qfhbmbsvfgr"
base_31     "7577vd28g58d8s5g84sgc5c6zq"
base_32     "BSGTEN21DRYMDSG75TDEMDDMKS"
base_58     "jW9NHFsBv4b2ynHaMa68zy"
new_base_60 "Fh7HDfRZ_pGwbUMtVF2ttv"
base_62     "x8SuXOLhXSjAx1jGzSCvzB"

# You can also ask for sample tokens of a given size
> HumanToken.samples(4)
hex         "0a91b59b"
base_30     "cx85466"
base_31     "un7hxe6"
base_32     "N9YXAZ3"
base_58     "pJKN11"
new_base_60 "wJ5cc_"
base_62     "DugJc6"
```

## Other Tidbits

If you ask for 128 bits (16 bytes) of randomness, you are actually getting _at least_ 128 bits. Why?

Consider the default generator. There are thirty "numerals" used in the default scheme (the 36 alphanumerics, minus 0, 1, I, O, L, and U). Each "numeral" in base 30 encodes about 4.9 bits of information. A token of length 26 can encdoe 127.6 bits of information. That's not enough for 128 bits of randomness. A token of length 27 can encode 132.5 bits of information.  Why waste the extra space by encoding only 128 bits in a string that can encode 132.5? Therefore, HumanToken encodes 132.5 bits of randomness.

However, if you don't want to explain to your colleagues why your tokens have "132 bit security" instead of a standard number like 128, then you can ask for exactly 128 bits. Your tokens will be the same length, but the first character will appear less random.

```ruby
HumanToken.generate(exact_bytes: 16)
# => "29spx4xsse3cqgr7da7nrasxfc2"

# First character will always be a 2 or 3 in this case
> 10.times { p HumanToken.generate(exact_bytes: 16) }
"2va3np2rhc8phqcwfmyy8mm62b6"
"2nhdf3jxz87qcfx4w2j8gna3f8k"
"25x5j7eh7k8vfnm372sbayd3brh"
"2wtxf5mrcw7aaw2hwk8ybpqex4r"
"2at5knh6aw38a8xaxcr262gnxs4"
"2bn7a7fx2gq6g8t5cg9yff6qeh8"
"23cy29jsbmj4w3xj35f6dygrvqp"
"2575jtkajbtyhx44gksdykjcfsq"
"29ny2f956jzytxwbt56y2vsea8t"
"2yrptgvaq6hyywanssgqm6ca6jb"
```

## License

Public Domain; no rights reserved.

No restrictions are placed on the use of HumanToken. That freedom also means, of course, that no warrenty of fitness is claimed; use HumanToken at your own risk.

This public domain dedication follows the the CC0 1.0 at https://creativecommons.org/publicdomain/zero/1.0/

## Contributing

1. Fork it ( http://github.com/brianhempel/human_token/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
