require 'yaml'
 
def update_action(base,file)
  home = YAML::load(ENV["HOME"] + "/live_set/temperature/config.yml")["home"]
  
  temp = nil
  swt = nil
  if file == "tmp" then
    i = 0
    File.open(base + "/" + file) do |f|
      while line = f.gets
        if line.length > 0 then
          temp = home["min_temp"]
          swt = 1
          i = i + 1
          
          #off信号判定
          if i == home["off"] && line.split(" ")[1].to_i > home["threshold"] then
            swt = 0
          end

          #温度判定
          if i == home["temperature"]["1bit"] && line.split(" ")[1].to_i > home["threshold"] then
            temp = temp + 1
          end
          if i == home["temperature"]["2bit"] && line.split(" ")[1].to_i > home["threshold"] then
            temp = temp + 2
          end
          if i == home["temperature"]["3bit"] && line.split(" ")[1].to_i > home["threshold"] then
            temp = temp + 4
          end
          if i == home["temperature"]["4bit"] && line.split(" ")[1].to_i > home["threshold"] then
            temp = temp + 8
          end
        end
      end
    end

    #tmpファイルがいっぱいになるので削除する
    if i > 1 then
      p base
      p file
      File.open(base + "/" + file,'w'){|f| f = nil}      
    end


  end
  return {"temp" => temp, "swt" => swt}
end

def temp2freq(temp)
  #0度をMIDIノートナンバー0（C-1）とし、基準音をA-1（13.75Hz）とする
  temp = temp - 5
  oct = temp.div(7)
  note = temp.modulo(7)
  frequency = 13.75 * (2 ** oct)
  #3度までは度数分の全音階
  if note < 3 then
    frequency = frequency * (2 ** ((note * 2).quo(12))).to_f
  #4～7度は度数-1分の全音階＋半音
  else
    frequency = frequency * (2 ** ((note * 2 - 1).quo(12))).to_f
  end
  return frequency
end
