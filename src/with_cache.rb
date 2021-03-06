module WithCache
  def self.included(klass)
    klass.include(CacheMethods)
  end

  module CacheMethods
    def cache_store
      @cache_store ||= DataCache.new(10)
    end

    def with_cache(key, &block)
      data = cache_store.get(key)
      if data.nil? && block_given?
        data = yield
        cache_store.set(key, data) unless data.nil?
      end
      data
    end
  end
end