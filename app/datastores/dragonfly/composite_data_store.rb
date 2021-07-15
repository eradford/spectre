class CompositeDataStore
  def initialize(primary_store, *ancillary_stores)
    @stores = [primary_store]
    @stores += ancillary_stores

    Dragonfly.logger.info { "CompositeDataStore initialized with stores: #{@stores.inspect}" }
  end

  def write(content, opts={})
    @stores[0].write(content, opts)
  end

  def read(uid)
    for store in @stores
      value = store.read(uid)

      return value if value
    end

    return nil
  end

  def destroy(uid)
    @stores.each { |store| store.destroy(uid) }
  end
end
