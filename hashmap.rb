# frozen_string_literal: true

# An implementation of a hash map structure, with hashes as nodes
class HashMap
  def initialize
    @buckets = Array.new(16)
    @load_factor = 0.75
  end

  def hash(key)
    hash_code = 0
    prime_number = 31

    key.each_char { |char| hash_code = prime_number * hash_code + char.ord }

    hash_code
  end

  def set(key, value)
    k = hash(key) % @buckets.length
    raise IndexError if k.negative? || k >= @buckets.length

    if @buckets[k].nil?
      @buckets[k] = Hash[key.to_sym, value]
    else
      @buckets[k][key.to_sym] = value
    end

    grow
  end

  def grow
    @buckets.push(*Array.new(@buckets.length)) if @buckets.count(nil) <= @buckets.length * (1 - @load_factor)
  end

  def get(key)
    k = hash(key) % @buckets.length
    raise IndexError if k.negative? || k >= @buckets.length

    @buckets[k][key.to_sym]
  end

  def has(key)
    k = hash(key) % @buckets.length
    raise IndexError if k.negative? || k >= @buckets.length

    !!@buckets[k][key.to_sym]
  end

  def remove(key)
    k = hash(key) % @buckets.length
    raise IndexError if k.negative? || k >= @buckets.length

    @buckets[k].delete(key.to_sym) if @buckets[k][key.to_sym]
  end

  def length
    length = 0
    @buckets.each { |hash| length += hash.length if hash.instance_of?(::Hash) }
    length
  end

  def clear
    @buckets = Array.new(16)
  end

  def keys
    @buckets.map { |hash| hash.keys if hash.instance_of?(::Hash) }.compact.flatten
  end

  def values
    @buckets.map { |hash| hash.values if hash.instance_of?(::Hash) }.compact.flatten
  end

  def entries
    arr = []
    @buckets.each { |hash| hash.each_pair { |key, value| arr << [key, value] } if hash.instance_of?(::Hash) }
    arr
  end
end
