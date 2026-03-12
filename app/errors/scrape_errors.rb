module ScrapeErrors
  class ScrapeError <  StandardError; end
  class PostNotFoundError < ScrapeError ; end
  class MultiplePostError < ScrapeError; end
  class WriterSectionNotFoundError < ScrapeError; end
end