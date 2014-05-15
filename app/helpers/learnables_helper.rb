module LearnablesHelper
  def current_vocabulary
    current_user.try(:current_vocabulary).try(:name)
  end
end
