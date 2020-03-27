class MovieDecorator < Draper::Decorator
  delegate_all

  def cover
    URI.join(ENV.fetch('PAIRGURU_BASE_URL'), context['poster'])
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
