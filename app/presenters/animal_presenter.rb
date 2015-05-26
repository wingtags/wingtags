class AnimalPresenter < BasePresenter
  def tag_code
    @model.tag_code.to_s.rjust(3, "0")
  end

  def name
    @model.name
  end

  def observation_count
    @obs_count ||= @model.observations.count
  end

  def last_observed
    if (observation_count > 0)
      newest_observation = @model.observations.order_by(:observed_at => :desc).first
      time_interval = h.time_ago_in_words(newest_observation.observed_at)
      "Last seen #{time_interval} ago."
    end
  end

  def avatar_url
    if @model.avatar
      @model.avatar.remote_url
    else
      h.image_path('gallery.jpg')
    end
  end
end