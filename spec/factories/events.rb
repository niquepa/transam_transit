FactoryGirl.define do

  trait :basic_event_traits do
    association :asset, :factory => :bus
  end

  factory :condition_update_like_event, :class => :asset_event do
    basic_event_traits
    asset_event_type { ConditionUpdateEvent.asset_event_type }
    condition_type { ConditionType.find_by(:name => "Adequate") }
    assessed_rating 3
    event_date "2014-01-01 12:00:00"
    current_mileage 25000
  end

  factory :condition_update_event do
    basic_event_traits
    asset_event_type_id { ConditionUpdateEvent.asset_event_type.id }
    condition_type_id { ConditionType.find_by(:name => "Adequate").id }
    assessed_rating 3
    event_date "2014-01-01 12:00:00"
    current_mileage 25000
  end

  factory :disposition_update_event do
    basic_event_traits
    asset_event_type { DispositionUpdateEvent.asset_event_type }
    disposition_type { DispositionType.find_by(:name => "Public Sale") }
    sales_proceeds 25000
    address1 "123 Fake St"
    city "Nowheresvile"
    state "MA"
    zip "12345"
    new_owner_name "Mr Morebucks"
    event_date Date.today
    #mileage_at_disposition 0
    age_at_disposition 0
  end

  factory :service_status_update_event do
    basic_event_traits
    asset_event_type_id { ServiceStatusUpdateEvent.asset_event_type.id }
    service_status_type_id 2
    event_date Date.today
  end

  factory :location_update_event do
    basic_event_traits
    asset_event_type_id 2
    association :parent, :factory => :administration_building
  end

  factory :mileage_update_event do
    basic_event_traits
    asset_event_type { AssetEventType.find_by_class_name("MileageUpdateEvent") }
    current_mileage 100000
  end

  factory :schedule_disposition_update_event do
    basic_event_traits
    asset_event_type_id 12
    disposition_date Date.today + 8.years
  end

  factory :schedule_replacement_update_event do
    basic_event_traits
    asset_event_type_id 11
    # Note that this can have either a replacement or a rebuild year, but it needs at least one
  end
end
