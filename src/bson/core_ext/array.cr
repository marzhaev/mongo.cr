class Array(T)
  def to_bson(bson = BSON.new)
    each_with_index do |item, i|
      case item
      when Array
        bson.append_array(i.to_s) do |appender, child|
          item.to_bson(child)
        end
      when Hash
        bson.append_document(i.to_s) do |child|
          item.to_bson(child)
        end
      when Nil then bson[i.to_s] = item
      when Int32 then bson[i.to_s] = item
      when Int64 then bson[i.to_s] = item
      when BSON::Binary then bson[i.to_s] = item
      when Bool then bson[i.to_s] = item
      when Float32 then bson[i.to_s] = item
      when Float64 then bson[i.to_s] = item
      when BSON::MinKey then bson[i.to_s] = item
      when BSON::MaxKey then bson[i.to_s] = item
      when BSON::ObjectId then bson[i.to_s] = item
      when String then bson[i.to_s] = item
      when Symbol then bson[i.to_s] = item
      when Time then bson[i.to_s] = item
      when BSON::Timestamp then bson[i.to_s] = item
      when BSON::Code then bson[i.to_s] = item
      when BSON then bson[i.to_s] = item
      when Regex then bson[i.to_s] = item
      when BSON::Field then raise "Ouch, field is being passed"
      else
        # Allows serialization of custom structures
        bson[i.to_s] = item.to_bson
      end
    end
    bson
  end
end
