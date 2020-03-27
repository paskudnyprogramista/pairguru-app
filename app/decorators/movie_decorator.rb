class MovieDecorator < Draper::Decorator
  delegate_all

  # TODO: Check if we can build url better
  def cover
    [ENV.fetch('PAIRGURU_BASE_URL'), context['poster']].join('/')
  end

  def rating
    context['rating']
  end

  def description
    context['plot']
  end
end
