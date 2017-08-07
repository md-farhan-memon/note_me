class NotesController < ApplicationController
  include NotesHelper
  load_and_authorize_resource
  before_action :set_sharing_status, only: %i[create update]
  before_action :initialize_note, only: %i[new create]

  def create
    @note.assign_attributes(note_params.except(:tags_list))
    if @note.save
      @note.tags_list = note_params[:tags_list]
      redirect_to redirection_path
    else
      render :new
    end
  end

  def update
    if @note.update_attributes(note_params.except(:tags_list))
      @note.update_tags(note_params[:tags_list])
      redirect_to redirection_path
    else
      render :edit
    end
  end

  def drafted
    @notes = current_user.notes.drafted.date_sorted.page(params[:page] || 1)
  end

  def shared
    @notes = current_user.notes.shared.date_sorted.page(params[:page] || 1)
  end

  def share
    msg = if valid_share? && (role = @user.add_role(share_params[:role], @note)).persisted?
            role.update_attribute(:provider_id, current_user.id)
            "#{@user.name} successfully added."
          else
            "#{share_params[:email]} is not a valid user."
          end
    redirect_to edit_note_path(@note), flash: { error: msg }
  end

  def remove_access
    user = User.find_by_email(params[:email])
    msg = if user.present?
            user.remove_role(params[:role], @note)
            "#{user.name} has been removed."
          else
            "Couldn't find user"
          end
    redirect_to edit_note_path(@note), flash: { error: msg }
  end

  def destroy
    if @note.destroy
      flash[:notice] = 'Successfully deleted Note!'
      redirect_to root_path
    else
      flash[:alert] = 'Error updating post!'
      redirect_to edit_note_path(@note)
    end
  end

  def shared_with_me
    @notes = Note.with_roles(User::ROLES.except(:owner).keys, current_user).page(params[:page] || 1)
  end

  private

  def note_params
    params.require(:note).permit(:title, :body, :tags_list, :shared)
  end

  def share_params
    params.require(:share).permit(:email, :role)
  end

  def set_sharing_status
    params[:note][:shared] = note_shared?
  end

  def initialize_note
    @note = current_user.notes.new
  end
end
