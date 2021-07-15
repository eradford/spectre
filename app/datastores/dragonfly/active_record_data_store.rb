require 'json'

class ActiveRecordDataStore
  def write(content, opts={})
    Dragonfly.logger.info { "Writing image to the database for [#{content.path}]: #{content.meta.inspect}" }
    id = content.meta[:active_record_id]

    image = id ? Image.find(id) : Image.new

    image.content = content;

    image.save!

    Dragonfly.logger.info { "Wrote image to the database for [#{content.path}] with uid [#{image.id}]" }

    image.id.to_s
  end

  def read(uid)
    Dragonfly.logger.info { "Reading image for uid [#{uid}]" }

    begin
      content = Image.find(uid.to_i).content
    rescue ActiveRecord::RecordNotFound => e
      Dragonfly.logger.warn { "No image found in the database for uid [#{uid}]" }
      return nil
    end

    content[:meta][:active_record_id] = uid

    [content[:data], content[:meta]]
  end

  def destroy(uid)
    Dragonfly.logger.info { "Deleting image from database for uid [#{uid}]" }
    begin
      # TODO enable deletes. The application seems to prematurely delete images, so destroy has been
      # disabled to ensure that needed images are always available
      # Image.destroy(uid)
    rescue ActiveRecord::RecordNotFound => e
      Dragonfly.logger.debug { "No record exists for uid [#{uid}], skipping destroy: #{e.message}\n#{e.backtrace.join("\n")}" };
    end
  end
end
