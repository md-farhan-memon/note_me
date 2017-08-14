class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities

    # owner_note_ids  = Note.with_role(:owner, user).pluck(:id)
    # editor_note_ids = Note.with_role(:editor, user).pluck(:id)
    # reader_note_ids = Note.with_role(:reader, user).pluck(:id)

    editor_owner_ids  = Note.with_role(%i[editor owner], user).pluck(:id)
    reader_editor_ids = Note.with_role(%i[reader editor], user).pluck(:id)

    can     :manage,  Note, id: editor_owner_ids
    can     :read,    Note, id: reader_editor_ids
    cannot  :destroy, Note, id: reader_editor_ids
  end
end
