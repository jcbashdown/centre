module Validators

  def correct_context_attributes(context_attributes)
    context_attributes.each do |attr|
      errors.add(attr, "should be blank") if send(attr).present?
    end
  end

end
