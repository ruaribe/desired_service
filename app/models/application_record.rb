# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  ALLOWD_CONTENT_TYPES = '
    image/jpeg
    image/png
    image/gif
    image/bmp
  '
end
