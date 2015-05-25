class ServiceProviderType < ActiveRecord::Base

  # default scope
  default_scope { where(:active => true) }

  def to_s
    "#{code}-#{name}"
  end

end
