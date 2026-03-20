class WriterWinRateCalculator
  def initialize(writer_name:, user_name:, contest_type:)
    @writer_name = writer_name
    @user_name = user_name
    @contest_type = contest_type
  end

  def calculate
    return nil if writer.nil?
    return 0 if participated_contests.empty?

    win_contest_count = participated_contests.count { |contest| contest['NewRating'] > contest['OldRating'] }

    (win_contest_count.to_f / participated_contests.size * 100).round(2)
  end

  def writer
    @writer ||= Writer.find_by(username: @writer_name)
  end

  def writer_contests
    @writer_contests ||= writer.contests.where(contest_type: @contest_type)
                               .pluck(:contest_type, :contest_id)
                               .map { |type, id| format('%s%03d', type, id) }
  end

  def user_history
    @user_history ||= AtcoderApi.fetch_history(username: @user_name)
  end

  def participated_contests
    user_history.select do |contest|
      contest_name = contest['ContestScreenName'].split('.').first.upcase
      writer_contests.include?(contest_name)
    end
  end
end
