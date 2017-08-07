module NotesHelper
  def redirection_path
    if note_params[:shared]
      edit_note_path(@note)
    else
      note_path(@note)
    end
  end

  def note_shared?
    params[:commit] == 'Save & Share'
  end

  def owner_text(note)
    user = User.with_role(:owner, note).first
    name = if user.eql?(current_user)
             'You are'
           else
             "#{user.name} is"
           end
    "#{name} the owner of this Note."
  end

  def valid_share?
    (@user = User.find_by_email(share_params[:email])).present? &&
      !current_user.eql?(@user)
  end
end
