class MovieDecorator < Draper::Decorator
  delegate_all

  def cover
    URI.join(ENV.fetch('PAIRGURU_BASE_URL'), poster)
  end

  def rating
    context['rating'] || 0.0
  end

  def description
    context['plot'] || ''
  end

  def release_date
    object.released_at.to_datetime.strftime('%d-%m-%Y')
  end

  private

  def poster
    context['poster'] || ''
  end
end
