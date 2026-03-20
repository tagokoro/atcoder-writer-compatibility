require 'net/http'
require 'nokogiri'
require 'cgi'

class ScrapeError < StandardError; end
class PostNotFoundError < ScrapeError; end
class MultiplePostError < ScrapeError; end
class WriterSectionNotFoundError < ScrapeError; end

class WritersScraper
  def initialize(contest)
    @contest = contest
  end

  def get_writers
    doc = fetch_page
    post = find_target_post(doc)
    extract_writers(post)
  end

  private

  def fetch_page
    url = URI("https://atcoder.jp/posts/?keyword=#{@contest}")
    html = Net::HTTP.get(url)
    Nokogiri::HTML.parse(html)
  end

  def find_target_post(doc)
    target_posts = doc.css('.panel-body.blog-post')
    raise PostNotFoundError if target_posts.empty?
    raise MultiplePostError if target_posts.length > 1

    target_posts.first
  end

  def extract_writers(post)
    text_post = post.inner_html.gsub(/[\n\r]/, '').strip.split('- ')
    writer_item = text_post.find { |item| item.match?(/^[Ww]riter/) }
    raise WriterSectionNotFoundError unless writer_item

    parse_writer_names(writer_item)
  end

  def parse_writer_names(writer_item)
    writer_html = writer_item.sub(/^[Ww]riter\s*/, '')
    writer_html_decoded = CGI.unescapeHTML(writer_html)
    writer_doc = Nokogiri::HTML(writer_html_decoded)
    writer_doc.css('a.username').map(&:text)
  end
end
