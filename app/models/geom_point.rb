class GeomPoint < Struct.new(:latitude, :longitude)

  def self.nobrainer_cast_user_to_model(value)
    case value
    when GeomPoint then value
    when Hash  then new(value[:latitude] || value['latitude'], value[:longitude] || value['longitude'])
    else raise NoBrainer::Error::InvalidType
    end
  end

  # This class method translates the given value to a compatible
  # RethinkDB type value.
  # It is used when writing to the database, for example saving a model.
  def self.nobrainer_cast_model_to_db(value)
    {
      '$reql_type$' => 'GEOMETRY',
      'coordinates' => [value.longitude, value.latitude],
      'type' => 'Point'
    }
  end

  # This class method translates a value from the database to the proper type.
  # It is used when reading from the database.
  def self.nobrainer_cast_db_to_model(value)
    lat = value['coordinates'][1]
    lon = value['coordinates'][0]
    GeomPoint.new(lat, lon)
  end
end