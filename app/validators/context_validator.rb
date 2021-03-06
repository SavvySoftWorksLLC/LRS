class ContextValidator < ActiveModel::EachValidator

  include CommonValidations

  def validate_each(record, attribute, value)
    check_registration(record, attribute, value)
    check_instructor(record, attribute, value)
    check_team(record, attribute, value)
    check_statement(record, attribute, value)
    check_language(record, attribute, value)
    check_context_activites(record, attribute, value)
    check_extensions(record, attribute, value)
  end

  private

  def check_registration(record, attribute, value)
    return unless value && value['registration']
    unless validate_uuid(value['registration'])
      record.errors[attribute] << (options[:message] || "Invalid registration")
    end
  end

  def check_instructor(record, attribute, value)
    return unless value && value['instructor']
    if value['instructor'].is_a?(Hash)
      # TODO: THIS SHOULD BE VALIDATED AS AN AGENT OR GROUP
      check_inverse_functional_identifier(record, attribute, value['instructor'])
      check_agent_object_type(record, attribute, value['instructor'])
      check_mbox(record, attribute, value['instructor'])
      check_openid(record, attribute, value['instructor'])
      check_account(record, attribute, value['instructor'])
      check_account_home_page(record, attribute, value['instructor'])
    else
      record.errors[attribute] << (options[:message] || "Agent in Context instructor is not a properly formatted dictionary")
    end
  end

  def check_team(record, attribute, value)
    return unless value && value['team']
    # TODO: THIS SHOULD BE VALIDATED AS A GROUP
    check_inverse_functional_identifier(record, attribute, value['team'])
    check_group_object_type(record, attribute, value['team'])
    check_mbox(record, attribute, value['team'])
  end

  def check_statement(record, attribute, value)
    return unless value && value['statement']
    unless value['statement']['objectType'] && value['statement']['objectType'] == 'StatementRef'
      record.errors[attribute] << (options[:message] || "objectType must be set to StatementRef")
    end
    unless validate_uuid(value['statement']['id'])
      record.errors[attribute] << (options[:message] || "Invalid statement ID")
    end
  end

  def check_language(record, attribute, value)
    # TODO: CHECK LANGUAGE VALUES
    return unless value && value['language']
    languages = ['en-us']
    unless languages.include?(value['language'].downcase)
      record.errors[attribute] << (options[:message] || "Invalid language")
    end
  end

  def check_context_activites(record, attribute, value)
    return unless value && value['contextActivities']
    types = ['parent', 'grouping', 'category', 'other']
    types.each do |type|
      activities = value['contextActivities'][type]
      if activities
        activities.each do |activity|
          record.errors[attribute] << (options[:message] || "#{type} objectType must be set to Activity") unless (activity['objectType'].nil? || activity['objectType'] == 'Activity')
          if activity['id']
            record.errors[attribute] << (options[:message] || "#{type} : invalid activity ID") unless validate_iri(activity['id'])
          else
            record.errors[attribute] << (options[:message] || "#{type} : invalid activity ID")
          end
        end
      end
    end
  end

  def check_extensions(record, attribute, value)
    return unless value && value['extensions']
    value['extensions'].keys.each do |key|
      record.errors[attribute] << (options[:message] || "context with value key was not a valid URI") unless validate_iri(key)
    end
  end

  def check_agent_object_type(record, attribute, value)
    return unless value && value['objectType']
    unless value && value['objectType'] && value['objectType'] == 'Agent'
      record.errors[attribute] << (options[:message] || "invalid agent object type")
    end
  end

  def check_group_object_type(record, attribute, value)
    return unless value && value['objectType']
    unless value && value['objectType'] && value['objectType'] == 'Group'
      record.errors[attribute] << (options[:message] || "invalid group object type")
    end
  end

end