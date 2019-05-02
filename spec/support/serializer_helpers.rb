module SerializerHelpers
  def data_attributes(serializable_hash)
    @data_attributes ||= serializable_hash[:data][:attributes]
  end
end
