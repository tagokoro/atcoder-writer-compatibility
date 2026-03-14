namespace :scrape_task do
  desc '最新のコンテストWriterを取得'
  task latest: :environment do
    ["ABC", "ARC", "AGC"].each do |type|
      scrape_latest(type)
    end
  end

  desc '過去のコンテストWriterを取得'
  task setup: :environment do
    puts "=== 初期セットアップ開始 ==="

    contest_ranges = {
      "ABC" => 1..450,
      "ARC" => 1..200,
      "AGC" => 1..70
    }

    contest_ranges.each do |type, range|
      puts "\n--- #{type} (#{range.first}~#{range.last}) ---"

      range.each do |id|
        scrape_and_save(type, id)
        sleep 1
      end
    end

    puts "\n=== セットアップ完了 ==="
  end
end

def scrape_latest(type)
  latest_id = (Contest.latest_id(type: type) || 0) + 1
  scrape_and_save(type, latest_id)
end

def scrape_and_save(type, contest_id)
  contest_name = "%s%03d" % [type, contest_id]

  if Contest.exists?(contest_type: type, contest_id: contest_id)
    puts "#{contest_name}: スキップ（保存済み）"
    return
  end

  puts "#{contest_name} を取得中..."

  writers = WritersScraper.new(contest_name).get_writers

  return if writers.blank?

  ActiveRecord::Base.transaction do
    contest = Contest.create!(contest_type: type, contest_id: contest_id)
    writers.each do |name|
      writer = Writer.find_or_create_by!(username: name)
      WriterContest.find_or_create_by!(writer: writer, contest: contest)
    end
  end

  puts "#{contest_name}: #{writers.size}人のWriterを保存"
rescue PostNotFoundError
  puts "#{contest_name}: 記事が見つかりませんでした"
rescue WriterSectionNotFoundError
  puts "#{contest_name}: Writerセクションがありません"
rescue MultiplePostError
  puts "#{contest_name}: 記事が複数見つかりました"
rescue ActiveRecord::RecordInvalid => e
  puts "#{contest_name}: DB保存エラー - #{e.message}"
end
