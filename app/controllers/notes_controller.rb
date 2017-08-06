class NotesController < ApplicationController
  def new
    @note = current_user.notes.new
  end

  def create
    @note = current_user.notes.new(notes_params.slice(:title, :body))
    if @note.save
      @note.tags_list = notes_params[:tags_list]
      redirect_to note_path(@note)
    else
      render :new
    end
  end

  def show
    @note = Note.find_by_id(params[:id])
  end

  def drafted
    @notes = current_user.notes.drafted.date_sorted.page(params[:page] || 1)
  end

  def shared
    @notes = current_user.notes.shared.date_sorted.page(params[:page] || 1)
  end

  private

  def notes_params
    params.require(:note).permit(:title, :body, :tags_list)
  end
end
