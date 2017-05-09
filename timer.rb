require 'time'
def timer(arg, &proc)
  x = case arg
  when Numeric then arg
  when Time    then arg - Time.now
  when String  then Time.parse(arg) - Time.now
  else raise   end

  sleep x if block_given?
  yield
end

# # 10秒後に実行
# timer(10) do
#   puts "10秒経った"
# end

# # 3分後に実行
# timer(3 * 60) do
#   puts "3分経った"
# end

# # 今日の22時に実行
# timer(Time.parse("22:00")) do
#   puts "おやすみの時間"
# end

# # 今日の24時（明日の0時）に実行
# timer("24:00") do
#   puts "よるほー"
# end

# timer("00:15"){} # 0時15分までsleep
# #
# # 0時15分になったら始めたい処理
# #