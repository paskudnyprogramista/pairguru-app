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

  def release_date
    object.released_at.to_datetime.strftime('%d-%m-%Y')
  end
end
