class BSON
  struct ObjectId
    include Comparable(ObjectId)

    def initialize(@handle : LibBSON::Oid*)
    end

    def initialize(str : String)
      handle = Pointer(LibBSON::Oid).malloc(1)
      LibBSON.bson_oid_init_from_string(handle, str.to_unsafe)
      initialize(handle)
    end

    def initialize
      ctx = LibBSON.bson_context_get_default
      handle = Pointer(LibBSON::Oid).malloc(1)
      LibBSON.bson_oid_init(handle, ctx)
      initialize(handle)
    end

    def initialize(pull : JSON::PullParser)
      if pull.kind.string? && (raw = pull.read_string)
        initialize(raw)
      end
    end

    def hash
      LibBSON.bson_oid_hash(@handle)
    end

    def to_bson
      self
    end

    def to_s
      buf = StaticArray(UInt8, 25).new(0_u8)
      LibBSON.bson_oid_to_string(@handle, buf)
      String.new(buf.to_slice)
    end

    def ==(other : ObjectId)
      LibBSON.bson_oid_equal(@handle, other)
    end

    def ==(other)
      false
    end

    def <=>(other : ObjectId)
      LibBSON.bson_oid_compare(@handle, other)
    end

    def to_unsafe
      @handle
    end

    def time
      t = LibBSON.bson_oid_get_time_t(@handle)
      ts = LibC::Timespec.new
      ts.tv_sec = t
      Time.new(ts, Time::Location::UTC)
    end

    def to_json(json : JSON::Builder)
      json.string(self.to_s[0..23])
    end

    def self.is_valid?(str : String) : Bool
      str.matches?(/^[0-9a-fA-F]{24}$/)
    end
  end
end
