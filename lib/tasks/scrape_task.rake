namespace :scrape_task do
  desc '最新のコンテストWriterを取得'
  task :latest => :environment do |t,args|
    contest_types = ["ABC","ARC","AGC"]

    contest_types.each do |type|
      scrape_contest(type)
    end
  end

  private

  def scrape_contest(type)
    latest_id = (Contest.latest_id(type: type) || 0)+1
    contest_name = "%s%03d" % [type, latest_id]

    puts "#{contest_name}のWriterを取得中..."

    writers = WritersScraper.new(contest_name).get_writers

    return unless writers

    ActiveRecord::Base.transaction do
      contest = Contest.create!(contest_type: type, contest_id: latest_id)
      writers.each do |name|
        writer = Writer.find_or_create_by!(username: name)
        WriterContest.find_or_create_by!(writer: writer, contest: contest)
      end
    end

    puts "取得したWriter: #{writers}"
  rescue PostNotFoundError
    puts "#{contest_name}: 記事が見つかりませんでした"
  rescue WriterSectionNotFoundError
    puts "#{contest_name}: Writerセクションがありません"
  rescue ActiveRecord::RecordInvalid => e
    puts "#{contest_name}: DB保存エラー - #{e.message}"
  end
end
