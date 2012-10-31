module ActiverecordImportMethods
  #taken from import gem
  def synchronize(instances, subclass, keys=[self.primary_key])
    return if instances.empty?
  
    conditions = {}
    order = ""
    
    key_values = keys.map { |key| instances.map(&"#{key}".to_sym) }
    keys.zip(key_values).each { |key, values| conditions[key] = values }
    order = keys.map{ |key| "#{key} ASC" }.join(",")
    
    fresh_instances = subclass.find( :all, :conditions=>conditions, :order=>order )
    instances.each do |instance|
      matched_instance = fresh_instances.detect do |fresh_instance|
        keys.all?{ |key| fresh_instance.send(key) == instance.send(key) }
      end
      
      if matched_instance
        instance.clear_aggregation_cache
        instance.clear_association_cache
        instance.instance_variable_set '@attributes', matched_instance.attributes
      end
    end
  end
end

