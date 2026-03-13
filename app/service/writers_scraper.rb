require 'open-uri'
require 'nokogiri'
require 'cgi'

class ScrapeError < StandardError; end
class PostNotFoundError < ScrapeError ; end
class MultiplePostError < ScrapeError; end
class WriterSectionNotFoundError < ScrapeError; end

class WritersScraper
  def initialize(contest)
    @contest = contest
  end


  def get_writers
    url = "https://atcoder.jp/posts/?keyword=#{@contest}"
    html  = URI.open(url).read
    doc = Nokogiri::HTML.parse(html)

    target_posts = doc.css('.panel-body.blog-post')
    raise PostNotFoundError if target_posts.empty?
    raise MultiplePostError if target_posts.length > 1

    text_post = target_posts.first.inner_html.gsub(/[\n\r]/,'').strip.split('- ')
    writer_item = text_post.find { |item| item.match?(/^[Ww]riter/) }
    raise WriterSectionNotFoundError unless writer_item

    writer_html = writer_item.sub(/^[Ww]riter\s*/, '')
    writer_html_decoded = CGI.unescapeHTML(writer_html)
    writer_doc = Nokogiri::HTML(writer_html_decoded)
    writer_usernames = writer_doc.css('a.username').map(&:text)
    return writer_usernames
  end
end