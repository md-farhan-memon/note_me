class NotesController < ApplicationController
  include NotesHelper
  before_action :set_note, only: %i[show edit]
  load_and_authorize_resource
  skip_authorize_resource only: %i[home new create drafted shared shared_with_me]
  before_action :initialize_note, only: %i[new create]
  before_action :set_sharing_status, only: %i[create update]

  def home
    redirect_to drafted_notes_path if current_user.present?
  end

  def create
    @note.assign_attributes(note_params)
    if @note.save
      redirect_to note_path(@note)
    else
      render :new
    end
  end

  def update
    if @note.update_attributes(note_params.except(:tags_list))
      @note.update_tags(note_params[:tags_list])
      redirect_to note_path(@note)
    else
      render :edit
    end
  end

  def drafted
    @notes = current_user.notes.drafted.recently_modified.page(params[:page] || 1)
  end

  def shared
    @notes = current_user.notes.shared.recently_modified.page(params[:page] || 1)
  end

  def share
    msg = if @note.added_role_to_user?(share_params, current_user.id)
            "#{share_params[:email]} successfully added."
          else
            "#{share_params[:email]} could not be added."
          end
    redirect_to note_path(@note), flash: { notice: msg }
  end

  def remove_access
    user = User.find_by_email(params[:email])
    msg = if user.present?
            @note.remove_role_from_user(user, params[:role])
            "#{user.name} has been removed."
          else
            "Couldn't find user"
          end
    redirect_to note_path(@note), flash: { error: msg }
  end

  def destroy
    if @note.destroy
      redirect_to root_path, flash: { error: 'Successfully deleted Note!' }
    else
      redirect_to edit_note_path(@note), flash: { error: 'Error Deleting post!' }
    end
  end

  def shared_with_me
    @notes = Note.includes(:user).with_roles(User::ROLES.except(:owner).keys, current_user)
                 .page(params[:page] || 1)
  end

  private

  def note_params
    params.require(:note).permit(:title, :body, :tags_list, :shared)
  end

  def share_params
    params.require(:share).permit(:email, :role)
  end

  def set_sharing_status
    params[:note][:shared] = note_shareable?
  end

  def initialize_note
    @note = current_user.notes.new
  end

  def set_current_note
    @note = Note.includes(:user).find(params[:id])
  end

  def set_note
    @note = Note.includes(:tags).find(params[:id])
  end
end
