# frozen_string_literal: true

module Timestampable
  extend ActiveSupport::Concern

  TIME_FORMAT = '%Y-%m-%dT%H:%M:%S.%L000Z'

  def timestamp(time)
    time = Time.zone.at(time.to_i) unless time.respond_to? :strftime
    time.strftime TIME_FORMAT
  end
end
