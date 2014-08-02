# encoding: utf-8
#
require('nokogiri')
require('open-uri')

doc_avg =  Nokogiri::HTML(open('http://baseball-data.com/13/stats/hitter2-all/avg-3.html'))
doc_hr =  Nokogiri::HTML(open('http://baseball-data.com/13/stats/hitter2-all/hr-2.html'))
doc_rbi =  Nokogiri::HTML(open('http://baseball-data.com/13/stats/hitter2-all/rbi-2.html'))
doc_sb =  Nokogiri::HTML(open('http://baseball-data.com/13/stats/hitter2-all/sb-2.html'))

docList = [doc_avg,doc_hr,doc_rbi,doc_sb]

th = doc_avg.css('thead:first-child th')

keys = Array.new

th.each do |th|
    keys.push(th.text)
end

data = Array.new

delList = ["順位","チーム","打席数","打率","二塁打","三塁打","盗塁刺","長打率","出塁率","敬遠"]

playerList = Array.new

#Append Player Data
docList.each do |doc|
    tr = doc.css('tbody tr')

    tr.each do |th|
        flag = 0
        player = Hash.new
        td = th.css('td')

        td.each_with_index do |td,j|
            col = keys[j]
            if  col == "選手名" 
                player[col] = td.text
                if !playerList.include?(td.text)
                    playerList.push(td.text)
                else
                    flag = 1
                end
            end
            player[col] = td.text.to_i if ! delList.include?(col) && col != "選手名" 
        end
        data.push(player) if flag != 1
    end
end

#Write to matrix.m
col_index = Array.new

data[0].each_key do |key|
    if key != "選手名"
        col_index.push(key)
    end
end

col_line = '# '

col_index.each do |index|
    col_line += "#{index} "
end

open('matrix.m','w') do |f|
    f.puts col_line
    f.puts "X = ["
    data.each do |player|
        line = '' 
        player.each do |key,val|
            if (key!="選手名")
                line += "#{val} "
            end
        end
        line += ';'
        f.puts line
    end
    f.puts "]"
end

open('list.text','w') do |f|
    f.puts col_line
    data.each do |player|
        line = '' 
        player.each do |key,val|
            line += "#{val} "
        end
        f.puts line
    end
end

open('player.csv','w') do |f|
    data.each do |player| 
        player.each do |key,val|
            if key == '選手名'
                f.puts "#{val} "
            end
        end
    end
end


