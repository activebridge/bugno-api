# frozen_string_literal: true

module Constants
  module Event
    BROWSER_JS = 'browser-js'
    OCCURRENCE_LIMIT = 100
    FIRST_NOTIFICATION_POINT = 5
    OCCURRENCE_NOTIFICATION_POINTS = [FIRST_NOTIFICATION_POINT, 10, 25, 50, 100, 150, 250,
                                      500, 750, 1000, 2000, 3000, 4000].freeze
    MESSAGE_SIMILARITY_PERCENT = 0.1
  end
end
