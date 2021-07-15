class Image < ActiveRecord::Base
  validates :data, :meta, presence: true

  def data=(value)
    write_attribute(:data, value && value.force_encoding(Encoding::IBM864))
  end

  def data
    encodedData = read_attribute(:data)
    encodedData && encodedData.force_encoding(Encoding::IBM864)
  end

  def meta=(value)
    write_attribute(:meta, value && value.to_json)
  end

  def meta
    jsonMeta = read_attribute(:meta)
    jsonMeta && JSON.parse(jsonMeta)
  end

  def content=(value)
    return unless value

    self.data = value.data
    self.meta = value.meta
  end

  def content
    {
      data: data,
      meta: meta
    }
  end
end
