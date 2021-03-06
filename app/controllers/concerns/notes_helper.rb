module NotesHelper
  def note_shareable?
    params[:commit] == 'Save & Share'
  end

  def owner_text(note)
    name = if current_user.has_role?(:owner, note)
             'You are'
           else
             "#{note.user.name} is"
           end
    "#{name} the owner of this Note."
  end
end
