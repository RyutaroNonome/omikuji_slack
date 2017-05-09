require 'sinatra'
require 'slack'
require './timer.rb'
require './path.rb'
line = "--------------------------------------------"

# channelのid
bot_name = "Yakiniku Omikuzi"

Thread.start do
  Slack.auth_test

    people = []

    Slack.configure {|config| config.token = @TOKEN }

      client = Slack.realtime

        tasks = [ "近藤さん♡　", "近藤さん♡　", "近藤さん♡　", "近藤さん♡　"]
        reception_responses = ["受付完了です〜_(┐「ε:)_", "受付完了ですd(´ω｀*)", "抽選受付完了です(゜∀。)", "_(:3 」∠ )_抽選受付完了です"]

        isStarted = false

        client.on :message do |data|

          if (data['text'] == 'Hi' && data['subtype'] != 'bot_message' && data['channel'] == @yakiniku && isStarted == false && (data['user'] == 'U3TNC97FW' || data['user'] == 'U3U5LSXA8'))
            test_params = {
              channel: @yakiniku,
              username: bot_name,
              icon_emoji: ":meat_on_bone:",
              text: "Hi!"}
            Slack.chat_postMessage test_params
          end

          if (data['text'] == 'start' && data['subtype'] != 'bot_message' && data['channel'] == @yakiniku && isStarted == false && (data['user'] == 'U3TNC97FW' || data['user'] == 'U3U5LSXA8'))
            isStarted = true
            operation_started_params = {
              channel: @yakiniku,
              username: bot_name,
              icon_emoji: ":meat_on_bone:",
              text: "お疲れ様です♪\n焼肉抽選を始めますので、\n参加希望の方は「ノ」と言ってね三_(┐「ε:)_"}
            Slack.chat_postMessage operation_started_params
          end

          if ((data['text'] == 'ノ' || data['text'] =='丿' || data['text'] =='ﾉ') && data['subtype'] != 'bot_message' && data['channel'] == @yakiniku && isStarted == true)
            people.push("<@#{data['user']}>").uniq!
            # people.push("<@#{data['user']}>")
            if people.length >= 5
              tasks.push("　　*自腹*　　")
            end
            params = {
              channel: @yakiniku,
              username: bot_name,
              icon_emoji: ":meat_on_bone:",
              text: "<@#{data['user']}>\n#{reception_responses.sample}\n `#{people.length}` 人目♫"
            }
            Slack.chat_postMessage params

          elsif ((data['text'] == 'notノ' || data['text'] =='not丿' || data['text'] =='notﾉ') && data['subtype'] != 'bot_message' && data['channel'] == @yakiniku && isStarted == true)
            if people.length >= 5
              tasks.delete_at(people.length - 1)
            end
            people.delete("<@#{data['user']}>")
            delete_params = {
              channel: @yakiniku,
              username: bot_name,
              icon_emoji: ":meat_on_bone:",
              text: "<@#{data['user']}>\n抽選から抜けました(｀・v・´)ｂ\n現在 `#{people.length}` 人です♫\ntasksの要素数：#{tasks.length}"
            }
            Slack.chat_postMessage delete_params

          #人数足りない場合は、pushとつぶやく。
          elsif (data['text'] == 'push' && data['subtype'] != 'bot_message' && data['channel'] == @yakiniku && isStarted == true && (data['user'] == 'U3TNC97FW' || data['user'] == 'U3U5LSXA8'))
              hoge = []
              @remind_texts = []
              tasks.shuffle.zip(people.shuffle.uniq){ |a| hoge << a.join("：　") }
              # tasks.shuffle.zip(people.shuffle){ |a| hoge << a.join("：　") }
              hoge.each do |fuga|
                @remind_texts.push(fuga)
                temp_params = {
                  channel: @yakiniku,
                  username: bot_name,
                  text: "#{line}\n#{fuga}"}
                Slack.chat_postMessage temp_params
              end #hoge.each
                last_params = {
                  channel: @yakiniku,
                  username: bot_name,
                  text: "#{line}\n　お支払い完了までが焼肉Partyです♪\n終わったらリアクションしてね♡\n　全抽選参加者は `#{people.length}` 人でしたd(´ω｀*)\n#{line}"}
                Slack.chat_postMessage last_params
              # break
              people.clear
              tasks.clear
              isStarted = false
          end
        end #client
      client.start
  end #Slack


get '/' do #routing

# 上記コードが正常に動いている場合、URL開くとOKと表示される。
"yakiniku"

end #routing