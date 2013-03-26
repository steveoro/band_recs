class CrudObserver < ActiveRecord::Observer
  observe :author, :band, :musician, :song, :tag, :take, :recording, :user


  def after_create( model_record )
    begin
      user_name = User.find( model_record.user_id ).name
    rescue
      user_name = "INVALID USER ID:'#{model_record.user_id}'"
    end
    action_name = nil
    action_desc = nil

    if ( model_record.class.name.downcase.to_sym == :user )
      action_name = "NEW USER CREATION!"
      action_desc = "User row added"
    else
      action_name = "#{model_record.class.name} row creation"
      action_desc = "new row added successfully"
    end

    m = AgexMailer.action_notify_mail( AGEX_DEVELOPMENT_EMAILS, user_name, action_name, action_desc )
    m.deliver()
  end


  def after_destroy( model_record )
    begin
      user_name = User.find( model_record.user_id ).name
    rescue
      user_name = "INVALID USER ID:'#{model_record.user_id}'"
    end
    action_name = nil
    action_desc = nil

    if ( model_record.class.name.downcase.to_sym == :user )
      action_name = "USER DELETION!"
      action_desc = "row destroyed!"
    else
      action_name = "#{model_record.class.name} row DELETION"
      action_desc = "row destroyed!"
    end

    m = AgexMailer.action_notify_mail( AGEX_DEVELOPMENT_EMAILS, user_name, action_name, action_desc )
    m.deliver()
  end
end
